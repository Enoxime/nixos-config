#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.4.0-alpha
# date: 2025-09-29 10:48:15
dir_exists__32_v0() {

# bshchk (https://git.blek.codes/blek/bshchk)
deps=('[' '[' 'return' 'return' '[' '[' 'return' 'return' '[' 'return' 'return' '[' 'return' 'return' '[' 'bc' 'sed' 'mkdir' '[' '[' 'return' 'return' 'id' '[' '[' 'return' 'return' '[' 'curl' '[' 'wget' '[' 'aria2c' 'return' 'return' '[' 'bc' 'sed' 'bc' 'sed' 'bc' 'sed' 'exit' '[' '[' 'exit' '[' 'exit' 'return' 'nix' '[' 'exit' 'umount' '[' 'exit' 'mount' '[' 'exit' 'btrfs' '[' 'exit' 'umount' '[' 'exit' 'nix' '[' 'exit' 'return' '[' '[' '[' 'bc' 'sed' 'bc' 'sed' '[' '[' '[' 'bc' 'sed' 'exit' '[' '[' '[' 'bc' 'sed' 'bc' 'sed' '[' 'bc' 'sed' 'exit' '[' '[' '[' 'bc' 'sed' 'exit' '[' '[' '[' 'bc' 'sed' 'bc' 'sed' '[' '[' '[' '[' '[' 'bc' 'sed' 'bc' 'sed' '[' 'exit' '[' '[' '[' 'bc' 'sed' 'bc' 'sed' '[' 'bc' 'sed' 'exit' '[' '[' '[' 'bc' 'sed' 'bc' 'sed' '[' 'bc' 'sed' 'true' '[' 'nvme' 'cp' '[' 'exit' 'cp' '[' 'exit' 'cp' '[' 'exit' 'nixos-install' '[' 'exit' 'return' '[' 'bc' 'sed' 'bc' 'sed' 'bc' 'sed' 'exit' '[' '[' 'exit' '[' 'exit' 'return' '[' '[' '[' 'bc' 'sed' 'bc' 'sed' '[' '[' 'exit' '[' '[' '[' 'bc' 'sed' 'exit' '[' '[' '[' 'bc' 'sed' 'bc' 'sed' '[' '[' '[' 'bc' 'sed' 'bc' 'sed' '[' 'exit' '[' '[' '[' 'bc' 'sed' 'bc' 'sed' '[' 'bc' 'sed' 'exit' '[' '[' '[' 'bc' 'sed' 'bc' 'sed' '[' 'bc' 'sed' 'true' 'cp' '[' 'exit' 'cd' 'exit' 'bsdtar' '[' 'exit' 'cd' 'exit' 'curl' 'sh' '[' 'exit' 'nix' '[' 'exit' 'return' '[' 'bc' 'sed' 'exit' '[' 'bc' 'sed' 'exit' '[' '[' 'bc' 'sed' 'bc' 'sed' 'bc' 'sed' '[' '[' 'bc' 'sed' 'bc' 'sed' 'bc' 'sed' '[' '[' '[' 'bc' 'sed' 'exit')
non_ok=()

for d in $deps
do
    if ! command -v $d > /dev/null 2>&1; then
        non_ok+=$d
    fi
done

if (( ${#non_ok[@]} != 0 )); then
    >&2 echo "RDC Failed!"
    >&2 echo "  This program requires these commands:"
    >&2 echo "  > $deps"
    >&2 echo "    --- "
    >&2 echo "  From which, these are missing:"
    >&2 echo "  > $non_ok"
    >&2 echo "Make sure that those are installed and are present in \$PATH."
    exit 1
fi

unset non_ok
unset deps
# Dependencies are OK at this point


    local path=$1
    [ -d "${path}" ]
    __AS=$?
    if [ $__AS != 0 ]; then
        __AF_dir_exists32_v0=0
        return 0
    fi
    __AF_dir_exists32_v0=1
    return 0
}
file_exists__33_v0() {
    local path=$1
    [ -f "${path}" ]
    __AS=$?
    if [ $__AS != 0 ]; then
        __AF_file_exists33_v0=0
        return 0
    fi
    __AF_file_exists33_v0=1
    return 0
}
file_write__35_v0() {
    local path=$1
    local content=$2
    __AMBER_VAL_0=$(echo "${content}" >"${path}")
    __AS=$?
    if [ $__AS != 0 ]; then
        __AF_file_write35_v0=''
        return $__AS
    fi
    __AF_file_write35_v0="${__AMBER_VAL_0}"
    return 0
}
file_append__36_v0() {
    local path=$1
    local content=$2
    __AMBER_VAL_1=$(echo "${content}" >>"${path}")
    __AS=$?
    if [ $__AS != 0 ]; then
        __AF_file_append36_v0=''
        return $__AS
    fi
    __AF_file_append36_v0="${__AMBER_VAL_1}"
    return 0
}
dir_create__38_v0() {
    local path=$1
    dir_exists__32_v0 "${path}"
    __AF_dir_exists32_v0__52_12="$__AF_dir_exists32_v0"
    if [ $(echo '!' "$__AF_dir_exists32_v0__52_12" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        mkdir -p "${path}"
        __AS=$?
    fi
}
is_command__97_v0() {
    local command=$1
    [ -x "$(command -v ${command})" ]
    __AS=$?
    if [ $__AS != 0 ]; then
        __AF_is_command97_v0=0
        return 0
    fi
    __AF_is_command97_v0=1
    return 0
}
is_root__102_v0() {
    __AMBER_VAL_2=$(id -u)
    __AS=$?
    if [ $(
        [ "_${__AMBER_VAL_2}" != "_0" ]
        echo $?
    ) != 0 ]; then
        __AF_is_root102_v0=1
        return 0
    fi
    __AF_is_root102_v0=0
    return 0
}
file_download__140_v0() {
    local url=$1
    local path=$2
    is_command__97_v0 "curl"
    __AF_is_command97_v0__9_9="$__AF_is_command97_v0"
    is_command__97_v0 "wget"
    __AF_is_command97_v0__12_9="$__AF_is_command97_v0"
    is_command__97_v0 "aria2c"
    __AF_is_command97_v0__15_9="$__AF_is_command97_v0"
    if [ "$__AF_is_command97_v0__9_9" != 0 ]; then
        curl -L -o "${path}" "${url}"
        __AS=$?
    elif [ "$__AF_is_command97_v0__12_9" != 0 ]; then
        wget "${url}" -P "${path}"
        __AS=$?
    elif [ "$__AF_is_command97_v0__15_9" != 0 ]; then
        aria2c "${url}" -d "${path}"
        __AS=$?
    else
        __AF_file_download140_v0=0
        return 0
    fi
    __AF_file_download140_v0=1
    return 0
}
__0_nixos_config_github="github:Enoxime/nixos-config"
__1_raw_nixos_config_github="https://raw.githubusercontent.com/Enoxime/nixos-config/refs/heads"
__2_dir_path="/persist"
menu__142_v0() {
    echo "
################
# nixos-config #
################

Script that install and setup NixOS or nix in the Macbook case

Available Commands:
  linux_install   Install NixOS for a GNU/Linux setup
  darwin_install  Install nix for a Darwin setup

Flags:
  -h  --help    Show help for this script
"
}
linux_menu__143_v0() {
    echo "
###############################
# nixos-config: linux_install #
###############################

Install NixOS on a system

Flags:
  -c  --configuration-name  Name of the configuration to use. Could be \"desktop\" or \"framework\"
  -d  --disk-path           Udev path of the disk where to install NixOS
  -h  --help                Show help for linux_install
  -m  --machine-name        Name of the machine also known as the hostname
      --secure              Fill the disk zeros by opening the disk with cryptsetup. Default to false
  -s  --sops-secret-path    Path of the sops file
  -u  --username            Username for the system
  -v  --version             Specify a tag or a branch. Set to latest by default
"
}
linux_private__144_v0() {
    local m=$1
    local u=$2
    local file_name="private.nix"
    local content=""
    __AMBER_LEN="${m}"
    __AMBER_LEN="${u}"
    if [ $(echo $(echo "${#__AMBER_LEN}" '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $(echo "${#__AMBER_LEN}" '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        content="{
  ${m} = {
    username = \"${u}\";
  };
}
"
    else
        echo "machine_name or username empty"'!'""
        exit 1
    fi
    file_exists__33_v0 "${__2_dir_path}/private/${file_name}"
    __AF_file_exists33_v0__66_6="$__AF_file_exists33_v0"
    if [ "$__AF_file_exists33_v0__66_6" != 0 ]; then
        file_write__35_v0 "${__2_dir_path}/private/${file_name}" "${content}"
        __AS=$?
        if [ $__AS != 0 ]; then
            echo "File: ${__2_dir_path}/private/${file_name}. Was not created"'!'" Status: $__AS"
            exit 1
        fi
        __AF_file_write35_v0__67_5="${__AF_file_write35_v0}"
        echo "${__AF_file_write35_v0__67_5}" >/dev/null 2>&1
    else
        file_append__36_v0 "${__2_dir_path}/private/${file_name}" "${content}"
        __AS=$?
        if [ $__AS != 0 ]; then
            echo "File: ${__2_dir_path}/private/${file_name}. Was not created"'!'" Status: $__AS"
            exit 1
        fi
        __AF_file_append36_v0__73_5="${__AF_file_append36_v0}"
        echo "${__AF_file_append36_v0__73_5}" >/dev/null 2>&1
    fi
    __AF_linux_private144_v0="${__2_dir_path}/private/${file_name}"
    return 0
}
linux_disko__145_v0() {
    local machine_name=$1
    local version=$2
    file_download__140_v0 "${__1_raw_nixos_config_github}/${version}/hosts/${machine_name}/disko-configuration.nix" "${__2_dir_path}/disko-configuration.nix"
    __AF_file_download140_v0__87_3="$__AF_file_download140_v0"
    echo "$__AF_file_download140_v0__87_3" >/dev/null 2>&1
    # Destroy, format and mount the disk via disko
    nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ${__2_dir_path}/disko-configuration.nix
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Something went wrong with disko"'!'" Error: $__AS"
        exit 1
    fi
    # Make a snapshot of the root filesystem
    umount -R /mnt
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Something went wrong with the recursive umount"'!'""
        exit 1
    fi
    mount /dev/mapper/system /mnt
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Something went wrong with the mount of the system"'!'""
        exit 1
    fi
    btrfs subvolume snapshot -r /mnt/@root /mnt/@root-blank
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Something went wrong during the root snapshot"'!'""
        exit 1
    fi
    umount /mnt
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Something went wrong with the root umount"'!'""
        exit 1
    fi
    # Mount back the system
    nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode mount ${__2_dir_path}/disko-configuration.nix
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Something went wrong with disko"'!'" Error: $__AS"
        exit 1
    fi
    __AF_linux_disko145_v0=1
    return 0
}
linux_install__146_v0() {
    local opts=("${!1}")
    local configuration_name=""
    local disk_path=""
    local machine_name=""
    local secure_erase=0
    local sops_secret_path=""
    local username=""
    local version="latest"
    dir_create__38_v0 "${__2_dir_path}"
    __AF_dir_create38_v0__143_3="$__AF_dir_create38_v0"
    echo "$__AF_dir_create38_v0__143_3" >/dev/null 2>&1
    dir_create__38_v0 "${__2_dir_path}/private"
    __AF_dir_create38_v0__144_3="$__AF_dir_create38_v0"
    echo "$__AF_dir_create38_v0__144_3" >/dev/null 2>&1
    dir_create__38_v0 "${__2_dir_path}/sops/age"
    __AF_dir_create38_v0__145_3="$__AF_dir_create38_v0"
    echo "$__AF_dir_create38_v0__145_3" >/dev/null 2>&1
    i=0
    for opt in "${opts[@]}"; do
        if [ $(echo $(
            [ "_${opt}" != "_-c" ]
            echo $?
        ) '||' $(
            [ "_${opt}" != "_--configuration-name" ]
            echo $?
        ) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            local c_opt="${opts[$(echo ${i} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
            if [ $(echo $(
                [ "_${c_opt}" != "_desktop" ]
                echo $?
            ) '||' $(
                [ "_${c_opt}" != "_framework" ]
                echo $?
            ) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                configuration_name="${c_opt}"
            else
                linux_menu__143_v0
                __AF_linux_menu143_v0__154_11="${__AF_linux_menu143_v0}"
                echo "${__AF_linux_menu143_v0__154_11}" >/dev/null 2>&1
                echo "Wrong configuration name"'!'""
                exit 1
            fi
        elif [ $(echo $(
            [ "_${opt}" != "_-d" ]
            echo $?
        ) '||' $(
            [ "_${opt}" != "_--disk-path" ]
            echo $?
        ) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            local d_opt="${opts[$(echo ${i} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
            __AMBER_LEN="${d_opt}"
            if [ $(echo "${#__AMBER_LEN}" '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                disk_path="${d_opt}"
            else
                linux_menu__143_v0
                __AF_linux_menu143_v0__165_11="${__AF_linux_menu143_v0}"
                echo "${__AF_linux_menu143_v0__165_11}" >/dev/null 2>&1
                echo "Disk path not specified"'!'""
                exit 1
            fi
        elif [ $(echo $(
            [ "_${opt}" != "_-h" ]
            echo $?
        ) '||' $(
            [ "_${opt}" != "_--help" ]
            echo $?
        ) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            linux_menu__143_v0
            __AF_linux_menu143_v0__172_9="${__AF_linux_menu143_v0}"
            echo "${__AF_linux_menu143_v0__172_9}" >/dev/null 2>&1
            exit 0
        elif [ $(echo $(
            [ "_${opt}" != "_-m" ]
            echo $?
        ) '||' $(
            [ "_${opt}" != "_--machine-name" ]
            echo $?
        ) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            machine_name="${opts[$(echo ${i} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
        elif [ $(
            [ "_${opt}" != "_--secure" ]
            echo $?
        ) != 0 ]; then
            secure_erase=1
        elif [ $(echo $(
            [ "_${opt}" != "_-s" ]
            echo $?
        ) '||' $(
            [ "_${opt}" != "_--sops-secret-path" ]
            echo $?
        ) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            local s_opt="${opts[$(echo ${i} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
            file_exists__33_v0 "${s_opt}"
            __AF_file_exists33_v0__182_12="$__AF_file_exists33_v0"
            if [ "$__AF_file_exists33_v0__182_12" != 0 ]; then
                sops_secret_path="${s_opt}"
            else
                linux_menu__143_v0
                __AF_linux_menu143_v0__185_11="${__AF_linux_menu143_v0}"
                echo "${__AF_linux_menu143_v0__185_11}" >/dev/null 2>&1
                echo "Sops secret file not found"'!'""
                exit 1
            fi
        elif [ $(echo $(
            [ "_${opt}" != "_-u" ]
            echo $?
        ) '||' $(
            [ "_${opt}" != "_--username" ]
            echo $?
        ) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            local u_opt="${opts[$(echo ${i} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
            __AMBER_LEN="${u_opt}"
            if [ $(echo "${#__AMBER_LEN}" '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                username="${u_opt}"
            else
                linux_menu__143_v0
                __AF_linux_menu143_v0__196_11="${__AF_linux_menu143_v0}"
                echo "${__AF_linux_menu143_v0__196_11}" >/dev/null 2>&1
                echo "Username is empty"'!'""
                exit 1
            fi
        elif [ $(echo $(
            [ "_${opt}" != "_-v" ]
            echo $?
        ) '||' $(
            [ "_${opt}" != "_--version" ]
            echo $?
        ) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            local v_opt="${opts[$(echo ${i} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
            __AMBER_LEN="${v_opt}"
            if [ $(echo "${#__AMBER_LEN}" '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                version="${v_opt}"
            fi
        fi
        ((i++)) || true
    done
    if [ ${secure_erase} != 0 ]; then
        nvme format --force ${disk_path}
        __AS=$?
    fi
    linux_private__144_v0 "${machine_name}" "${username}"
    __AF_linux_private144_v0__211_22="${__AF_linux_private144_v0}"
    local private_path="${__AF_linux_private144_v0__211_22}"
    linux_disko__145_v0 "${machine_name}" "${version}"
    __AF_linux_disko145_v0__213_3="$__AF_linux_disko145_v0"
    echo "$__AF_linux_disko145_v0__213_3" >/dev/null 2>&1
    # Copy the private.nix file in the permanent directory
    dir_create__38_v0 "/mnt/persist/private"
    __AF_dir_create38_v0__216_3="$__AF_dir_create38_v0"
    echo "$__AF_dir_create38_v0__216_3" >/dev/null 2>&1
    cp "${private_path}" "/mnt/persist/private/private.nix"
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Something went wrong during the copy of the private.nix file"'!'""
        exit 1
    fi
    # Copy the sops secret in the temporary directory
    cp "${sops_secret_path}" "${__2_dir_path}/sops/age/keys.txt"
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Something went wrong during the copy of the age key file"'!'""
        exit 1
    fi
    # Copy the sops secret in the permanent directory
    dir_create__38_v0 "/mnt/persist/sops/age"
    __AF_dir_create38_v0__229_3="$__AF_dir_create38_v0"
    echo "$__AF_dir_create38_v0__229_3" >/dev/null 2>&1
    cp "${sops_secret_path}" "/mnt/persist/sops/age/keys.txt"
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Something went wrong during the copy of the age key file"'!'""
        exit 1
    fi
    # Install NixOS
    nixos-install --root /mnt --flake ${__0_nixos_config_github}/${version}#${configuration_name} --impure
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Something went wrong with nixos-install"'!'" Error: $__AS"
        exit 1
    fi
    echo "Ready to reboot. Don't forget to remove the usb key"
    __AF_linux_install146_v0=1
    return 0
}
darwin_private__148_v0() {
    local machine_name=$1
    local username=$2
    local content=""
    local private_path=""
    __AMBER_LEN="${machine_name}"
    __AMBER_LEN="${username}"
    if [ $(echo $(echo "${#__AMBER_LEN}" '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '&&' $(echo "${#__AMBER_LEN}" '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        private_path="/Users/${username}/src/perso/darwin/private.nix"
        content="{
  ${machine_name} = {
    username = \"${username}\";
  };
}
"
    else
        echo "machine_name or username empty"'!'""
        exit 1
    fi
    file_exists__33_v0 "${private_path}"
    __AF_file_exists33_v0__285_6="$__AF_file_exists33_v0"
    if [ "$__AF_file_exists33_v0__285_6" != 0 ]; then
        file_write__35_v0 "${private_path}" "${content}"
        __AS=$?
        if [ $__AS != 0 ]; then
            echo "File: ${private_path}. Was not created"'!'" Status: $__AS"
            exit 1
        fi
        __AF_file_write35_v0__286_5="${__AF_file_write35_v0}"
        echo "${__AF_file_write35_v0__286_5}" >/dev/null 2>&1
    else
        file_append__36_v0 "${private_path}" "${content}"
        __AS=$?
        if [ $__AS != 0 ]; then
            echo "File: ${private_path}. Was not created"'!'" Status: $__AS"
            exit 1
        fi
        __AF_file_append36_v0__292_5="${__AF_file_append36_v0}"
        echo "${__AF_file_append36_v0__292_5}" >/dev/null 2>&1
    fi
    __AF_darwin_private148_v0="${private_path}"
    return 0
}
darwin_install__149_v0() {
    local opts=("${!1}")
    local configuration_name=""
    local machine_name=""
    local sops_secret_path=""
    local username=""
    local version="main"
    i=0
    for opt in "${opts[@]}"; do
        if [ $(echo $(
            [ "_${opt}" != "_-c" ]
            echo $?
        ) '||' $(
            [ "_${opt}" != "_--configuration-name" ]
            echo $?
        ) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            local c_opt="${opts[$(echo ${i} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
            if [ $(
                [ "_${c_opt}" != "_work" ]
                echo $?
            ) != 0 ]; then
                configuration_name="${c_opt}"
            else
                linux_menu__143_v0
                __AF_linux_menu143_v0__316_11="${__AF_linux_menu143_v0}"
                echo "${__AF_linux_menu143_v0__316_11}" >/dev/null 2>&1
                echo "Wrong configuration name"'!'""
                exit 1
            fi
        elif [ $(echo $(
            [ "_${opt}" != "_-h" ]
            echo $?
        ) '||' $(
            [ "_${opt}" != "_--help" ]
            echo $?
        ) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            linux_menu__143_v0
            __AF_linux_menu143_v0__323_9="${__AF_linux_menu143_v0}"
            echo "${__AF_linux_menu143_v0__323_9}" >/dev/null 2>&1
            exit 0
        elif [ $(echo $(
            [ "_${opt}" != "_-m" ]
            echo $?
        ) '||' $(
            [ "_${opt}" != "_--machine-name" ]
            echo $?
        ) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            machine_name="${opts[$(echo ${i} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
        elif [ $(echo $(
            [ "_${opt}" != "_-s" ]
            echo $?
        ) '||' $(
            [ "_${opt}" != "_--sops-secret-path" ]
            echo $?
        ) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            local s_opt="${opts[$(echo ${i} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
            file_exists__33_v0 "${s_opt}"
            __AF_file_exists33_v0__331_12="$__AF_file_exists33_v0"
            if [ "$__AF_file_exists33_v0__331_12" != 0 ]; then
                sops_secret_path="${s_opt}"
            else
                linux_menu__143_v0
                __AF_linux_menu143_v0__334_11="${__AF_linux_menu143_v0}"
                echo "${__AF_linux_menu143_v0__334_11}" >/dev/null 2>&1
                echo "Sops secret file not found"'!'""
                exit 1
            fi
        elif [ $(echo $(
            [ "_${opt}" != "_-u" ]
            echo $?
        ) '||' $(
            [ "_${opt}" != "_--username" ]
            echo $?
        ) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            local u_opt="${opts[$(echo ${i} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
            __AMBER_LEN="${u_opt}"
            if [ $(echo "${#__AMBER_LEN}" '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                username="${u_opt}"
            else
                linux_menu__143_v0
                __AF_linux_menu143_v0__345_11="${__AF_linux_menu143_v0}"
                echo "${__AF_linux_menu143_v0__345_11}" >/dev/null 2>&1
                echo "Username is empty"'!'""
                exit 1
            fi
        elif [ $(echo $(
            [ "_${opt}" != "_-v" ]
            echo $?
        ) '||' $(
            [ "_${opt}" != "_--version" ]
            echo $?
        ) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            local v_opt="${opts[$(echo ${i} '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')]}"
            __AMBER_LEN="${v_opt}"
            if [ $(echo "${#__AMBER_LEN}" '>' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
                version="${v_opt}"
            fi
        fi
        ((i++)) || true
    done
    # Copy the sops secret in the permanent directory
    dir_create__38_v0 "/Users/${username}/.config/sops/age"
    __AF_dir_create38_v0__359_3="$__AF_dir_create38_v0"
    echo "$__AF_dir_create38_v0__359_3" >/dev/null 2>&1
    cp "${sops_secret_path}" "/Users/${username}/.config/sops/age/keys.txt"
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Something went wrong during the copy of the age key file"'!'""
        exit 1
    fi
    # Create source directory
    dir_create__38_v0 "/Users/${username}/src/perso/darwin"
    __AF_dir_create38_v0__366_3="$__AF_dir_create38_v0"
    echo "$__AF_dir_create38_v0__366_3" >/dev/null 2>&1
    # Setup the repository for installation
    file_download__140_v0 "https://github.com/Enoxime/nixos-config/archive/refs/heads/${version}.zip" "/Users/${username}/src/perso/darwin.zip"
    __AF_file_download140_v0__369_3="$__AF_file_download140_v0"
    echo "$__AF_file_download140_v0__369_3" >/dev/null 2>&1
    cd "/Users/${username}/src/perso" || exit
    bsdtar -x --strip-components=1 --directory darwin -f darwin.zip
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Something went wrong with unzip darwin.zip"'!'" Error: $__AS"
        exit 1
    fi
    cd "/Users/${username}/src/perso/darwin" || exit
    darwin_private__148_v0 "${machine_name}" "${username}"
    __AF_darwin_private148_v0__379_3="${__AF_darwin_private148_v0}"
    echo "${__AF_darwin_private148_v0__379_3}" >/dev/null 2>&1
    # Install Nix darwin
    curl -fsSL https://install.determinate.systems.nix | sh -s -- install --determinate
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Something went wrong with installing darwin"'!'" Error: $__AS"
        exit 1
    fi
    nix run nix-darwin/master#darwwin-rebuild -- switch --flake path:.#${configuration_name}
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Something went wrong with installing darwin"'!'" Error: $__AS"
        exit 1
    fi
    echo "Ready to reboot"
    __AF_darwin_install149_v0=1
    return 0
}
declare -r args=("$0" "$@")
is_root__102_v0
__AF_is_root102_v0__398_10="$__AF_is_root102_v0"
if [ $(echo '!' "$__AF_is_root102_v0__398_10" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
    echo "This script requires root permissions"'!'""
    exit 1
fi
if [ $(echo "${#args[@]}" '<' 2 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
    menu__142_v0
    __AF_menu142_v0__405_7="${__AF_menu142_v0}"
    echo "${__AF_menu142_v0__405_7}" >/dev/null 2>&1
    exit 0
elif [ $(
    [ "_${args[1]}" != "_linux_install" ]
    echo $?
) != 0 ]; then
    __SLICE_UPPER_3=$(echo "${#args[@]}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    __SLICE_OFFSET_4=2
    __SLICE_OFFSET_4=$((__SLICE_OFFSET_4 > 0 ? __SLICE_OFFSET_4 : 0))
    __SLICE_LENGTH_5=$(echo $(echo "${#args[@]}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' $__SLICE_OFFSET_4 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    __SLICE_LENGTH_5=$((__SLICE_LENGTH_5 > 0 ? __SLICE_LENGTH_5 : 0))
    linux_args=("${args[@]:$__SLICE_OFFSET_4:$__SLICE_LENGTH_5}")
    linux_install__146_v0 linux_args[@]
    __AF_linux_install146_v0__411_7="$__AF_linux_install146_v0"
    echo "$__AF_linux_install146_v0__411_7" >/dev/null 2>&1
elif [ $(
    [ "_${args[1]}" != "_darwin_install" ]
    echo $?
) != 0 ]; then
    __SLICE_UPPER_6=$(echo "${#args[@]}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    __SLICE_OFFSET_7=2
    __SLICE_OFFSET_7=$((__SLICE_OFFSET_7 > 0 ? __SLICE_OFFSET_7 : 0))
    __SLICE_LENGTH_8=$(echo $(echo "${#args[@]}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') '-' $__SLICE_OFFSET_7 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
    __SLICE_LENGTH_8=$((__SLICE_LENGTH_8 > 0 ? __SLICE_LENGTH_8 : 0))
    darwin_args=("${args[@]:$__SLICE_OFFSET_7:$__SLICE_LENGTH_8}")
    darwin_install__149_v0 darwin_args[@]
    __AF_darwin_install149_v0__416_7="$__AF_darwin_install149_v0"
    echo "$__AF_darwin_install149_v0__416_7" >/dev/null 2>&1
elif [ $(echo $(
    [ "_${args[1]}" != "_-h" ]
    echo $?
) '||' $(
    [ "_${args[1]}" != "_--help" ]
    echo $?
) | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
    menu__142_v0
    __AF_menu142_v0__419_45="${__AF_menu142_v0}"
    echo "${__AF_menu142_v0__419_45}" >/dev/null 2>&1
else
    menu__142_v0
    __AF_menu142_v0__421_11="${__AF_menu142_v0}"
    echo "${__AF_menu142_v0__421_11}" >/dev/null 2>&1
fi
exit 1
