#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.5.1-alpha
# We cannot import `bash_version` from `env.ab` because it imports `text.ab` making a circular dependency.

# bshchk (https://git.blek.codes/blek/bshchk)
deps=('[' 'return' '[' 'return' '[' 'return' 'return' '[' 'return' 'return' '[' 'mkdir' '[' 'return' '[' '[' 'return' 'return' 'id' '[' '[' 'return' 'return' '[' 'curl' '[' 'wget' '[' 'aria2c' 'return' '[' 'mkpasswd' '[' 'exit' '[' 'exit' 'return' '[' 'exit' '[' '[' 'exit' '[' 'exit' 'return' '[' 'nix' '[' 'exit' 'umount' '[' 'exit' 'mount' '[' 'exit' 'btrfs' '[' 'exit' 'umount' '[' 'exit' 'nix' '[' 'exit' 'return' '[' '[' '[' '[' '[' '[' '[' '[' '[' 'exit' '[' '[' '[' '[' 'exit' '[' '[' '[' 'exit' '[' '[' '[' '[' '[' '[' '[' 'exit' '[' '[' '[' '[' '[' '[' 'exit' '[' '[' '[' '[' 'exit' '[' '[' '[' '[' 'true' '[' 'nvme' '[' 'cp' '[' 'exit' 'cp' '[' 'exit' '[' 'cp' '[' 'exit' 'nixos-install' '[' 'exit' 'return' '[' 'exit' '[' '[' 'exit' '[' 'exit' 'return' '[' '[' '[' '[' '[' 'exit' '[' '[' '[' 'exit' '[' '[' '[' '[' '[' '[' '[' 'exit' '[' '[' '[' '[' 'exit' '[' '[' '[' '[' 'true' '[' 'cp' '[' 'exit' '[' '[' 'cd' 'exit' 'bsdtar' '[' 'exit' 'cd' 'exit' 'curl' 'sh' '[' 'exit' 'nix' '[' 'exit' 'return' '[' 'exit' '[' 'exit' '[' '[' 'bc' 'sed' 'bc' 'sed' '[' '[' 'bc' 'sed' 'bc' 'sed' '[' '[' '[' 'exit')
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


# This is a workaround to avoid that issue and the import system should be improved in the future.
dir_exists__36_v0() {
    local path=$1
    [ -d "${path}" ]
    __status=$?
    ret_dir_exists36_v0="$(( ${__status} == 0 ))"
    return 0
}

file_exists__37_v0() {
    local path=$1
    [ -f "${path}" ]
    __status=$?
    ret_file_exists37_v0="$(( ${__status} == 0 ))"
    return 0
}

file_write__39_v0() {
    local path=$1
    local content=$2
    command_0="$(echo "${content}" > "${path}")"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_file_write39_v0=''
        return "${__status}"
    fi
    ret_file_write39_v0="${command_0}"
    return 0
}

file_append__40_v0() {
    local path=$1
    local content=$2
    command_1="$(echo "${content}" >> "${path}")"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_file_append40_v0=''
        return "${__status}"
    fi
    ret_file_append40_v0="${command_1}"
    return 0
}

dir_create__42_v0() {
    local path=$1
    dir_exists__36_v0 "${path}"
    ret_dir_exists36_v0__87_12="${ret_dir_exists36_v0}"
    if [ "$(( ! ${ret_dir_exists36_v0__87_12} ))" != 0 ]; then
        mkdir -p "${path}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_dir_create42_v0=''
            return "${__status}"
        fi
    fi
}

is_command__104_v0() {
    local command=$1
    [ -x "$(command -v "${command}")" ]
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_is_command104_v0=0
        return 0
    fi
    ret_is_command104_v0=1
    return 0
}

is_root__109_v0() {
    command_2="$(id -u)"
    __status=$?
    if [ "$([ "_${command_2}" != "_0" ]; echo $?)" != 0 ]; then
        ret_is_root109_v0=1
        return 0
    fi
    ret_is_root109_v0=0
    return 0
}

file_download__148_v0() {
    local url=$1
    local path=$2
    is_command__104_v0 "curl"
    ret_is_command104_v0__14_9="${ret_is_command104_v0}"
    is_command__104_v0 "wget"
    ret_is_command104_v0__17_9="${ret_is_command104_v0}"
    is_command__104_v0 "aria2c"
    ret_is_command104_v0__20_9="${ret_is_command104_v0}"
    if [ "${ret_is_command104_v0__14_9}" != 0 ]; then
        curl -L -o "${path}" "${url}" >/dev/null 2>&1
        __status=$?
    elif [ "${ret_is_command104_v0__17_9}" != 0 ]; then
        wget "${url}" -P "${path}" >/dev/null 2>&1
        __status=$?
    elif [ "${ret_is_command104_v0__20_9}" != 0 ]; then
        aria2c "${url}" -d "${path}" >/dev/null 2>&1
        __status=$?
    else
        ret_file_download148_v0=''
        return 1
    fi
}

nixos_config_github_3="github:Enoxime/nixos-config"
raw_nixos_config_github_4="https://raw.githubusercontent.com/Enoxime/nixos-config/refs/heads"
dir_path_5="/persist"
menu__150_v0() {
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

linux_menu__151_v0() {
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
  -p  --password            Password of the username for the system (GNU/Linux only)
      --secure              Fill the disk zeros by opening the disk with cryptsetup. Default to false
  -s  --sops-secret-path    Path of the sops file
  -u  --username            Username for the system
  -v  --version             Specify a tag or a branch. Set to latest by default
"
}

linux_password__152_v0() {
    local p=$1
    local u=$2
    dir_create__42_v0 "/mnt/persist/home/${u}"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_33="${__status}"
        echo "Command failed with exit code: ${code_33}"
    fi
    command_3="$(mkpasswd ''"${p}"'')"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong with the mkpasswd command"'!'""
        exit 1
    fi
    hashed_password_34="${command_3}"
    file_write__39_v0 "/mnt/persist/home/${u}/hashedPasswordFile" "${hashed_password_34}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "File: /mnt/persist/home/${u}/hashedPasswordFile. Was not created"'!'" Status: ${__status}"
        exit 1
    fi
    ret_linux_password152_v0="/mnt/persist/home/${u}/hashedPasswordFile"
    return 0
}

linux_private__153_v0() {
    local m=$1
    local u=$2
    file_name_27="private.nix"
    content_28=""
    __length_4="${m}"
    __length_5="${u}"
    if [ "$(( $(( ${#__length_4} > 0 )) && $(( ${#__length_5} > 0 )) ))" != 0 ]; then
        content_28="{
  ${m} = {
    username = \"${u}\";
  };
}
"
    else
        echo "machine_name or username empty"'!'""
        exit 1
    fi
    file_exists__37_v0 "${dir_path_5}/private/${file_name_27}"
    ret_file_exists37_v0__86_6="${ret_file_exists37_v0}"
    if [ "${ret_file_exists37_v0__86_6}" != 0 ]; then
        file_write__39_v0 "${dir_path_5}/private/${file_name_27}" "${content_28}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo "File: ${dir_path_5}/private/${file_name_27}. Was not created"'!'" Status: ${__status}"
            exit 1
        fi
    else
        file_append__40_v0 "${dir_path_5}/private/${file_name_27}" "${content_28}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo "File: ${dir_path_5}/private/${file_name_27}. Was not created"'!'" Status: ${__status}"
            exit 1
        fi
    fi
    ret_linux_private153_v0="${dir_path_5}/private/${file_name_27}"
    return 0
}

linux_disko__154_v0() {
    local machine_name=$1
    local version=$2
    file_download__148_v0 "${raw_nixos_config_github_4}/${version}/hosts/${machine_name}/disko-configuration.nix" "${dir_path_5}/disko-configuration.nix"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_30="${__status}"
        echo "Command failed with exit code: ${code_30}"
    fi
    # Destroy, format and mount the disk via disko
    nix     --extra-experimental-features "nix-command flakes"     run github:nix-community/disko/latest     -- --mode destroy,format,mount       ${dir_path_5}/disko-configuration.nix
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong with disko"'!'" Error: ${__status}"
        exit 1
    fi
    # Make a snapshot of the root filesystem
    umount -R /mnt
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong with the recursive umount"'!'""
        exit 1
    fi
    mount /dev/mapper/system /mnt
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong with the mount of the system"'!'""
        exit 1
    fi
    btrfs subvolume snapshot -r /mnt/@root /mnt/@root-blank
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong during the root snapshot"'!'""
        exit 1
    fi
    umount /mnt
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong with the root umount"'!'""
        exit 1
    fi
    # Mount back the system
    nix     --extra-experimental-features "nix-command flakes"     run github:nix-community/disko/latest     -- --mode mount       ${dir_path_5}/disko-configuration.nix
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong with disko"'!'" Error: ${__status}"
        exit 1
    fi
    ret_linux_disko154_v0=1
    return 0
}

linux_install__155_v0() {
    local opts=("${!1}")
    configuration_name_8=""
    disk_path_9=""
    machine_name_10=""
    password_11=""
    secure_erase_12=0
    sops_secret_path_13=""
    username_14=""
    version_15="latest"
    dir_create__42_v0 "${dir_path_5}"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_16="${__status}"
        echo "Command failed with exit code: ${code_16}"
    fi
    dir_create__42_v0 "${dir_path_5}/private"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_17="${__status}"
        echo "Command failed with exit code: ${code_17}"
    fi
    dir_create__42_v0 "${dir_path_5}/sops/age"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_18="${__status}"
        echo "Command failed with exit code: ${code_18}"
    fi
    i_20=0;
    for opt_19 in "${opts[@]}"; do
        if [ "$(( $([ "_${opt_19}" != "_-c" ]; echo $?) || $([ "_${opt_19}" != "_--configuration-name" ]; echo $?) ))" != 0 ]; then
            c_opt_21="${opts[$(( ${i_20} + 1 ))]}"
            if [ "$(( $([ "_${c_opt_21}" != "_desktop" ]; echo $?) || $([ "_${c_opt_21}" != "_framework" ]; echo $?) ))" != 0 ]; then
                configuration_name_8="${c_opt_21}"
            else
                linux_menu__151_v0 
                echo "Wrong configuration name"'!'""
                exit 1
            fi
        elif [ "$(( $([ "_${opt_19}" != "_-d" ]; echo $?) || $([ "_${opt_19}" != "_--disk-path" ]; echo $?) ))" != 0 ]; then
            d_opt_22="${opts[$(( ${i_20} + 1 ))]}"
            __length_6="${d_opt_22}"
            if [ "$(( ${#__length_6} > 0 ))" != 0 ]; then
                disk_path_9="${d_opt_22}"
            else
                linux_menu__151_v0 
                echo "Disk path not specified"'!'""
                exit 1
            fi
        elif [ "$(( $([ "_${opt_19}" != "_-h" ]; echo $?) || $([ "_${opt_19}" != "_--help" ]; echo $?) ))" != 0 ]; then
            linux_menu__151_v0 
            exit 0
        elif [ "$(( $([ "_${opt_19}" != "_-m" ]; echo $?) || $([ "_${opt_19}" != "_--machine-name" ]; echo $?) ))" != 0 ]; then
            machine_name_10="${opts[$(( ${i_20} + 1 ))]}"
        elif [ "$(( $([ "_${opt_19}" != "_-p" ]; echo $?) || $([ "_${opt_19}" != "_--password" ]; echo $?) ))" != 0 ]; then
            p_opt_23="${opts[$(( ${i_20} + 1 ))]}"
            __length_7="${p_opt_23}"
            if [ "$(( ${#__length_7} > 0 ))" != 0 ]; then
                password_11="${p_opt_23}"
            else
                linux_menu__151_v0 
                echo "password is empty"'!'""
                exit 1
            fi
        elif [ "$([ "_${opt_19}" != "_--secure" ]; echo $?)" != 0 ]; then
            secure_erase_12=1
        elif [ "$(( $([ "_${opt_19}" != "_-s" ]; echo $?) || $([ "_${opt_19}" != "_--sops-secret-path" ]; echo $?) ))" != 0 ]; then
            s_opt_24="${opts[$(( ${i_20} + 1 ))]}"
            file_exists__37_v0 "${s_opt_24}"
            ret_file_exists37_v0__222_12="${ret_file_exists37_v0}"
            if [ "${ret_file_exists37_v0__222_12}" != 0 ]; then
                sops_secret_path_13="${s_opt_24}"
            else
                linux_menu__151_v0 
                echo "Sops secret file not found"'!'""
                exit 1
            fi
        elif [ "$(( $([ "_${opt_19}" != "_-u" ]; echo $?) || $([ "_${opt_19}" != "_--username" ]; echo $?) ))" != 0 ]; then
            u_opt_25="${opts[$(( ${i_20} + 1 ))]}"
            __length_8="${u_opt_25}"
            if [ "$(( ${#__length_8} > 0 ))" != 0 ]; then
                username_14="${u_opt_25}"
            else
                linux_menu__151_v0 
                echo "Username is empty"'!'""
                exit 1
            fi
        elif [ "$(( $([ "_${opt_19}" != "_-v" ]; echo $?) || $([ "_${opt_19}" != "_--version" ]; echo $?) ))" != 0 ]; then
            v_opt_26="${opts[$(( ${i_20} + 1 ))]}"
            __length_9="${v_opt_26}"
            if [ "$(( ${#__length_9} > 0 ))" != 0 ]; then
                version_15="${v_opt_26}"
            fi
        fi
        (( i_20++ )) || true
    done
    if [ "${secure_erase_12}" != 0 ]; then
        nvme format --force ${disk_path_9}
        __status=$?
    fi
    linux_private__153_v0 "${machine_name_10}" "${username_14}"
    private_path_29="${ret_linux_private153_v0}"
    linux_disko__154_v0 "${machine_name_10}" "${version_15}"
    # Copy the private.nix file in the permanent directory
    dir_create__42_v0 "/mnt/persist/private"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_31="${__status}"
        echo "Command failed with exit code: ${code_31}"
    fi
    cp "${private_path_29}" "/mnt/persist/private/private.nix"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong during the copy of the private.nix file"'!'""
        exit 1
    fi
    # Copy the sops secret in the temporary directory
    cp "${sops_secret_path_13}" "${dir_path_5}/sops/age/keys.txt"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong during the copy of the age key file"'!'""
        exit 1
    fi
    # Copy the sops secret in the permanent directory
    dir_create__42_v0 "/mnt/persist/sops/age"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_32="${__status}"
        echo "Command failed with exit code: ${code_32}"
    fi
    cp "${sops_secret_path_13}" "/mnt/persist/sops/age/keys.txt"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong during the copy of the age key file"'!'""
        exit 1
    fi
    # Create the hashed password file containing the user password
    linux_password__152_v0 "${password_11}" "${username_14}"
    # Install NixOS
    nixos-install --root /mnt --flake ${nixos_config_github_3}/${version_15}#${configuration_name_8} --impure
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong with nixos-install"'!'" Error: ${__status}"
        exit 1
    fi
    echo "Ready to reboot. Don't forget to remove the usb key"
    ret_linux_install155_v0=1
    return 0
}

darwin_private__157_v0() {
    local machine_name=$1
    local username=$2
    content_50=""
    private_path_51=""
    __length_10="${machine_name}"
    __length_11="${username}"
    if [ "$(( $(( ${#__length_10} > 0 )) && $(( ${#__length_11} > 0 )) ))" != 0 ]; then
        private_path_51="/Users/${username}/src/perso/darwin/private.nix"
        content_50="{
  ${machine_name} = {
    username = \"${username}\";
  };
}
"
    else
        echo "machine_name or username empty"'!'""
        exit 1
    fi
    file_exists__37_v0 "${private_path_51}"
    ret_file_exists37_v0__332_6="${ret_file_exists37_v0}"
    if [ "${ret_file_exists37_v0__332_6}" != 0 ]; then
        file_write__39_v0 "${private_path_51}" "${content_50}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo "File: ${private_path_51}. Was not created"'!'" Status: ${__status}"
            exit 1
        fi
    else
        file_append__40_v0 "${private_path_51}" "${content_50}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo "File: ${private_path_51}. Was not created"'!'" Status: ${__status}"
            exit 1
        fi
    fi
    ret_darwin_private157_v0="${private_path_51}"
    return 0
}

darwin_install__158_v0() {
    local opts=("${!1}")
    configuration_name_36=""
    machine_name_37=""
    sops_secret_path_38=""
    username_39=""
    version_40="main"
    i_42=0;
    for opt_41 in "${opts[@]}"; do
        if [ "$(( $([ "_${opt_41}" != "_-c" ]; echo $?) || $([ "_${opt_41}" != "_--configuration-name" ]; echo $?) ))" != 0 ]; then
            c_opt_43="${opts[$(( ${i_42} + 1 ))]}"
            if [ "$([ "_${c_opt_43}" != "_work" ]; echo $?)" != 0 ]; then
                configuration_name_36="${c_opt_43}"
            else
                linux_menu__151_v0 
                echo "Wrong configuration name"'!'""
                exit 1
            fi
        elif [ "$(( $([ "_${opt_41}" != "_-h" ]; echo $?) || $([ "_${opt_41}" != "_--help" ]; echo $?) ))" != 0 ]; then
            linux_menu__151_v0 
            exit 0
        elif [ "$(( $([ "_${opt_41}" != "_-m" ]; echo $?) || $([ "_${opt_41}" != "_--machine-name" ]; echo $?) ))" != 0 ]; then
            machine_name_37="${opts[$(( ${i_42} + 1 ))]}"
        elif [ "$(( $([ "_${opt_41}" != "_-s" ]; echo $?) || $([ "_${opt_41}" != "_--sops-secret-path" ]; echo $?) ))" != 0 ]; then
            s_opt_44="${opts[$(( ${i_42} + 1 ))]}"
            file_exists__37_v0 "${s_opt_44}"
            ret_file_exists37_v0__378_12="${ret_file_exists37_v0}"
            if [ "${ret_file_exists37_v0__378_12}" != 0 ]; then
                sops_secret_path_38="${s_opt_44}"
            else
                linux_menu__151_v0 
                echo "Sops secret file not found"'!'""
                exit 1
            fi
        elif [ "$(( $([ "_${opt_41}" != "_-u" ]; echo $?) || $([ "_${opt_41}" != "_--username" ]; echo $?) ))" != 0 ]; then
            u_opt_45="${opts[$(( ${i_42} + 1 ))]}"
            __length_12="${u_opt_45}"
            if [ "$(( ${#__length_12} > 0 ))" != 0 ]; then
                username_39="${u_opt_45}"
            else
                linux_menu__151_v0 
                echo "Username is empty"'!'""
                exit 1
            fi
        elif [ "$(( $([ "_${opt_41}" != "_-v" ]; echo $?) || $([ "_${opt_41}" != "_--version" ]; echo $?) ))" != 0 ]; then
            v_opt_46="${opts[$(( ${i_42} + 1 ))]}"
            __length_13="${v_opt_46}"
            if [ "$(( ${#__length_13} > 0 ))" != 0 ]; then
                version_40="${v_opt_46}"
            fi
        fi
        (( i_42++ )) || true
    done
    # Copy the sops secret in the permanent directory
    dir_create__42_v0 "/Users/${username_39}/.config/sops/age"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_47="${__status}"
        echo "Command failed with exit code: ${code_47}"
    fi
    cp "${sops_secret_path_38}" "/Users/${username_39}/.config/sops/age/keys.txt"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong during the copy of the age key file"'!'""
        exit 1
    fi
    # Create source directory
    dir_create__42_v0 "/Users/${username_39}/src/perso/darwin"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_48="${__status}"
        echo "Command failed with exit code: ${code_48}"
    fi
    # Setup the repository for installation
    file_download__148_v0 "https://github.com/Enoxime/nixos-config/archive/refs/heads/${version_40}.zip" "/Users/${username_39}/src/perso/darwin.zip"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_49="${__status}"
        echo "Command failed with exit code: ${code_49}"
    fi
    cd "/Users/${username_39}/src/perso" || exit
    bsdtar -x --strip-components=1 --directory darwin -f darwin.zip
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong with unzip darwin.zip"'!'" Error: ${__status}"
        exit 1
    fi
    cd "/Users/${username_39}/src/perso/darwin" || exit
    darwin_private__157_v0 "${machine_name_37}" "${username_39}"
    # Install Nix darwin
    curl -fsSL https://install.determinate.systems.nix | sh -s -- install --determinate
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong with installing darwin"'!'" Error: ${__status}"
        exit 1
    fi
    nix run nix-darwin/master#darwwin-rebuild -- switch --flake path:.#${configuration_name_36}
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Something went wrong with installing darwin"'!'" Error: ${__status}"
        exit 1
    fi
    echo "Ready to reboot"
    ret_darwin_install158_v0=1
    return 0
}

declare -r args_6=("$0" "$@")
is_root__109_v0 
ret_is_root109_v0__451_10="${ret_is_root109_v0}"
if [ "$(( ! ${ret_is_root109_v0__451_10} ))" != 0 ]; then
    echo "This script requires root permissions"'!'""
    exit 1
fi
__length_15=("${args_6[@]}")
if [ "$(( ${#__length_15[@]} < 2 ))" != 0 ]; then
    menu__150_v0 
    exit 0
elif [ "$([ "_${args_6[1]}" != "_linux_install" ]; echo $?)" != 0 ]; then
    __length_17=("${args_6[@]}")
    slice_upper_16="$(echo "${#__length_17[@]}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')"
    slice_offset_18=2
    slice_offset_18=$((${slice_offset_18} > 0 ? ${slice_offset_18} : 0))
    slice_length_19="$(echo "${slice_upper_16}" '-' "${slice_offset_18}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')"
    slice_length_19=$((${slice_length_19} > 0 ? ${slice_length_19} : 0))
    linux_args_7=("${args_6[@]:${slice_offset_18}:${slice_length_19}}")
    linux_install__155_v0 linux_args_7[@]
elif [ "$([ "_${args_6[1]}" != "_darwin_install" ]; echo $?)" != 0 ]; then
    __length_21=("${args_6[@]}")
    slice_upper_20="$(echo "${#__length_21[@]}" '+' 1 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')"
    slice_offset_22=2
    slice_offset_22=$((${slice_offset_22} > 0 ? ${slice_offset_22} : 0))
    slice_length_23="$(echo "${slice_upper_20}" '-' "${slice_offset_22}" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')"
    slice_length_23=$((${slice_length_23} > 0 ? ${slice_length_23} : 0))
    darwin_args_35=("${args_6[@]:${slice_offset_22}:${slice_length_23}}")
    darwin_install__158_v0 darwin_args_35[@]
elif [ "$(( $([ "_${args_6[1]}" != "_-h" ]; echo $?) || $([ "_${args_6[1]}" != "_--help" ]; echo $?) ))" != 0 ]; then
    menu__150_v0 
else
    menu__150_v0 
fi
exit 1
