# nixos-config

An installer for my personal setup

## Why should I use your repo ?

- Setup secure and encrypted disk
- Use btrfs
- Wayland with Hyprland
- I tried to make it as much simple and understandable as possible

## To install on blank system

NOTE:

- Secure erase works on ssd types only

### Preparation

requirements:

- usb stick
- a computer
- Internet
- your brain (two or more neurons are recommended)
- patience
- a large vocabulary of insults just in case you lost patience

### Secure erase the disk and install

```bash
./install.sh -s true -m MACHINENAME -d /dev/nvme0n0 -f "github:Enoxime/nixos-config"
# Change the password of your username
nixos-enter --root /mnt -c 'passwd USERNAME'
reboot
```

## Resources

https://home-manager-options.extranix.com/?query=&release=master
https://search.nixos.org/packages
https://mynixos.com/options
https://wearewaylandnow.com/
https://github.com/Alexays/Waybar/wiki/Module:-Hyprland#window
https://nix.catppuccin.com/search/rolling/

## Learn

https://nix.dev/tutorials/packaging-existing-software
https://nixos-and-flakes.thiscute.world/nix-store/intro

## TODOs

BORGbackup

Check what path is important for NixOS. See https://nixos.wiki/wiki/Btrfs#Installation_with_encryption
or https://notes.tiredofit.ca/books/linux/page/installing-nixos-encrypted-btrfs-impermanance

Impermanence:
https://github.com/nix-community/impermanence
https://nixos.wiki/wiki/Impermanence

incus:
https://linuxcontainers.org/
https://linuxcontainers.org/incus/
https://wiki.nixos.org/wiki/Incus

## Sources

hyprland
waybar
swww
nixos
etc...

## Inspirations

https://github.com/Misterio77/nix-starter-configs/tree/main
https://github.com/aurreland/nix-config/tree/master
https://github.com/tiredofit/nixos-config/tree/main
https://github.com/clementpoiret/nixos-config/tree/main
https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/tree/main
https://github.com/JaKooLit/Hyprland-Dots/tree/main
https://github.com/HeinzDev/Hyprland-dotfiles
https://github.com/redyf/nixdots/tree/main
https://github.com/gpskwlkr/nixos-hyprland-flake/tree/main
https://flarexes.com/hyprland-getting-started-configure-screen-lock-brightness-volume-authentication-and-more
https://github.com/sejjy/mechabar/tree/main

## Install or remove apps

```bash
sudo nixos-rebuild switch --flake .#framework
sudo nixos-rebuild switch --flake github:Enoxime/nixos-config#framework
```

## Upgrade

```bash
sudo nixos-rebuild switch --flake github:Enoxime/nixos-config#framework --upgrade-all
```
