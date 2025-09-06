#!/usr/bin/env bash

set -e

# Variables defaults
__secure_erase="${SECURE_ERASE:-false}"
__machine_name="${MACHINE_NAME:-bubule}"
__disk_path="${DISK_PATH:-/dev/nvme0n1}"
__flake_path="${FLAKE_PATH:-}"


function menu() {
  cat << EOF
##################
# NixOS intaller #
##################

-s | SECURE_ERASE    Fill the disk zeros by opening the disk with cryptsetup. Default to false
-n | MACHINE_NAME    Set the machine name. Default to bubule
-d | DISK_PATH       Set the disk path were the installation will be done
-f | FLAKE_PATH      Set the path to the flake folder for NixOS installation
-h | n/a             Show help menu
EOF
}


while getopts 's:n:d:f:h:' OPTION; do
  case "${OPTION}" in
    s)
      __secure_erase=${OPTARG:-__secure_erase}
      ;;
    n)
      __machine_name="${OPTARG:-__machine_name}"
      ;;
    d)
      __disk_path="${OPTARG:-__disk_path}"
      ;;
    f)
      __flake_path="${OPTARG:__flake_path}"
      ;;
    h)
      menu && exit 0;
      ;;
    ?)
      menu && exit 1;
      ;;
  esac
done


##########################
# Variables verification #
##########################

# Check if EFI is loaded
[[ ! -d "/sys/firmware/efi/efivars" ]] && echo "EFI not loaded" && exit 1;

# Check if flake file exists
[[ ! -d "${__flake_path}" ]] && echo "flake file path missing" && exit 1;

##########################


##############
# Erase disk #
##############

# If option to erase securely is set
if [[ "${__secure_erase}" != "false" ]]; then
  __secure_erase_disk_type=$(lsblk -do path,tran | grep -v loop | grep "${__disk_path}" | awk '{ print $2}')

  if [[ ${__secure_erase_disk_type} == "nvme" ]]; then
    # TODO: Add check to see which option the nvme supports
    # nvme sanitize "${__disk_path}" --sanact=2 || nvme format "${__disk_path}" --ses=2
    # nvme sanitize "${__disk_path}" --sanact=2 || nvme format "${__disk_path}"
    nvme format "${__disk_path}"
  else
    # TODO: hdparam if not nvme
    exit 0
  fi
fi

# Erase partition table. It cost nothing to do
sgdisk --zap-all "${__disk_path}"

##############


########################################
# Partition, format and mount the disk #
########################################

# TODO: Find why it does not work with disko. It format and 
# all but cannot boot properly on it
# nix \
#   --extra-experimental-features "nix-command flakes" \
#   run github:nix-community/disko -- \
#   --mode format,mount \
#   --no-deps \
#   --flake "${__flake_path}#${__machine_name}"

# Partition
sgdisk --clear \
  --new=1:0:+1GiB \
  --typecode=1:ef00 \
  --change-name=1:EFI \
  \
  --new=2:0:0 \
  --typecode=2:8300 \
  --change-name=2:cryptsystem \
  \
  "${__disk_path}"

# For a weird reason if we do not wait here, cryptsetup cannot
# find the device in the /dev/mapper
sleep 3

# Encrypt container
cryptsetup luksFormat \
  --type luks2 \
  --cipher serpent-xts-plain64 \
  --key-size 512 \
  /dev/disk/by-partlabel/cryptsystem
cryptsetup open \
  --type luks2 \
  /dev/disk/by-partlabel/cryptsystem system

# BTRFS partitioning
mkfs.btrfs --label system /dev/mapper/system
mount --types btrfs LABEL=system /mnt
btrfs subvolume create /mnt/@root
# btrfs subvolume create /mnt/@root_root
# btrfs subvolume create /mnt/@srv
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
# btrfs subvolume create /mnt/@var_cache
btrfs subvolume create /mnt/@var_log
# btrfs subvolume create /mnt/@var_tmp
btrfs subvolume create /mnt/@swap
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@persist

umount --recursive /mnt

# EFI partitioning
mkfs.fat -F32 -n EFI /dev/disk/by-partlabel/EFI

# Mount filesystem
mount \
  --types btrfs \
  --options defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@root \
  LABEL=system \
  /mnt
mount \
  --types btrfs \
  --options defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@home \
  LABEL=system \
  /mnt/home
mount \
  --types btrfs \
  --options defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@nix \
  LABEL=system \
  /mnt/nix
mount \
  --types btrfs \
  --options defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@var_log \
  LABEL=system \
  /mnt/var/log
mount \
  --types btrfs \
  --options defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@swap \
  LABEL=system \
  /mnt/swap
mount \
  --types btrfs \
  --options defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@tmp \
  LABEL=system \
  /mnt/tmp
mount \
  --types btrfs \
  --options defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@snapshots \
  LABEL=system \
  /mnt/.snapshots
mount \
  --types btrfs \
  --options defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@persist \
  LABEL=system \
  /mnt/persist
mkdir /mnt/boot
mount LABEL=EFI /mnt/boot

# Create swapfile
btrfs filesystem mkswapfile --size 38G /mnt/swap/swapfile
swapon /mnt/swap/swapfile


########################################


##
# Sed on missing variables ?
##

##


#################
# Install NixOS #
#################

nixos-install --root /mnt --flake "${__flake_path}#${__machine_name}"

#################


# Does not work if the intended idea is to partition, mount then
# install the system. Instead, the setup will try to install everything 
# and that will overload the space and, eventually, error out of space.
# TODO: It would be nice if it works as I intended
# sudo nix --extra-experimental-features "nix-command flakes" \
#   run 'github:nix-community/disko/latest#disko-install' -- \
#   --flake <flake-url>#<flake-attr> \
#   --write-efi-boot-entries \
#   --disk main <disk-device>

# TODO: Check impermanence https://github.com/nix-community/impermanence
# btrfs subvolume snapshot -r /mnt/root /mnt/.snapshots/root-blank


echo "nixos-enter --root /mnt -c 'passwd alice'"

echo "Ready to reboot! Don't forget to remove the usb key"
