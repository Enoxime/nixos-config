#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.6.0-alpha
[ "$EUID" -ne 0 ] && { { command -v sudo >/dev/null 2>&1 && __sudo=sudo; } || { command -v doas >/dev/null 2>&1 && __sudo=doas; }; }
if [ -n "$ZSH_VERSION" ]; then
    EXEC_SHELL="zsh"
    IFS='.' read -A EXEC_SHELL_VERSION <<< "$ZSH_VERSION"
elif [ -n "$KSH_VERSION" ]; then
    EXEC_SHELL="ksh"
    __exec_shell_version="${.sh.version##*/}"
    IFS='.' read -a EXEC_SHELL_VERSION <<< "${__exec_shell_version%% *}"
else
    EXEC_SHELL="bash"
    EXEC_SHELL_VERSION=("${BASH_VERSINFO[0]}" "${BASH_VERSINFO[1]}" "${BASH_VERSINFO[2]}")
fi
# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_53="${1}"
    [ -d "${path_53}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# file_exists(path: Text)
file_exists__39_v0() {
    local path_64="${1}"
    [ -f "${path_64}" ]
    __status=$?
    ret_file_exists39_v0="$(( __status == 0 ))"
    return 0
}

# file_write(path: Text, content: Text)
file_write__41_v0() {
    local path_84="${1}"
    local content_85="${2}"
    local command_0
    command_0="$(printf '%s
' "${content_85}" > "${path_84}")"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_file_write41_v0=''
        return "${__status}"
    fi
    ret_file_write41_v0="${command_0}"
    return 0
}

# file_append(path: Text, content: Text)
file_append__42_v0() {
    local path_86="${1}"
    local content_87="${2}"
    local command_1
    command_1="$(printf '%s
' "${content_87}" >> "${path_86}")"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_file_append42_v0=''
        return "${__status}"
    fi
    ret_file_append42_v0="${command_1}"
    return 0
}

# dir_create(path: Text)
dir_create__44_v0() {
    local path_52="${1}"
    dir_exists__38_v0 "${path_52}"
    local ret_dir_exists38_v0__87_12="${ret_dir_exists38_v0}"
    if [ "$(( ! ret_dir_exists38_v0__87_12 ))" != 0 ]; then
        mkdir -p "${path_52}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_dir_create44_v0=''
            return "${__status}"
        fi
    fi
}

# is_command(command: Text)
is_command__126_v0() {
    local command_107="${1}"
    [ -x "$(command -v "${command_107}")" ]
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_is_command126_v0=0
        return 0
    fi
    ret_is_command126_v0=1
    return 0
}

# is_root()
is_root__131_v0() {
    local command_2
    command_2="$(id -u)"
    __status=$?
    if [ "$([ "_${command_2}" != "_0" ]; echo $?)" != 0 ]; then
        ret_is_root131_v0=1
        return 0
    fi
    ret_is_root131_v0=0
    return 0
}

# printf(format: Text, args: [Text])
printf__132_v0() {
    local format_15="${1}"
    local args_16=("${!2}")
    args_16=("${format_15}" "${args_16[@]}")
    __status=$?
    printf "${args_16[@]}"
    __status=$?
}

# echo_info(message: Text)
echo_info__139_v0() {
    local message_120="${1}"
    local array_3=("${message_120}")
    printf__132_v0 "\\x1b[1;3;97;44m%s\\x1b[0m
" array_3[@]
}

# echo_error(message: Text, exit_code: Int)
echo_error__142_v0() {
    local message_13="${1}"
    local exit_code_14="${2}"
    local array_4=("${message_13}")
    printf__132_v0 "\\x1b[1;3;97;41m%s\\x1b[0m
" array_4[@]
    if [ "$(( exit_code_14 > 0 ))" != 0 ]; then
        exit "${exit_code_14}"
    fi
}

# file_download(url: Text, path: Text)
file_download__241_v0() {
    local url_105="${1}"
    local path_106="${2}"
    is_command__126_v0 "curl"
    local ret_is_command126_v0__15_9="${ret_is_command126_v0}"
    is_command__126_v0 "wget"
    local ret_is_command126_v0__18_9="${ret_is_command126_v0}"
    is_command__126_v0 "aria2c"
    local ret_is_command126_v0__21_9="${ret_is_command126_v0}"
    if [ "${ret_is_command126_v0__15_9}" != 0 ]; then
        curl -L -o "${path_106}" "${url_105}">/dev/null 2>&1
        __status=$?
    elif [ "${ret_is_command126_v0__18_9}" != 0 ]; then
        wget "${url_105}" -P "${path_106}">/dev/null 2>&1
        __status=$?
    elif [ "${ret_is_command126_v0__21_9}" != 0 ]; then
        aria2c "${url_105}" -d "${path_106}">/dev/null 2>&1
        __status=$?
    else
        ret_file_download241_v0=''
        return 1
    fi
}

nixos_config_github_3="github:Enoxime/nixos-config"
raw_nixos_config_github_4="https://raw.githubusercontent.com/Enoxime/nixos-config/refs/heads"
dir_path_5="/persist"
# menu()
menu__244_v0() {
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

# linux_menu()
linux_menu__245_v0() {
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
  -v  --version             Specify a tag or a branch. Set to main by default
      --disko-version       Specify a tag or a branch for disko. Set to latest by default
"
}

# linux_password(p: Text, u: Text)
linux_password__246_v0() {
    local p_115="${1}"
    local u_116="${2}"
    dir_create__44_v0 "/mnt/persist/home/${u_116}"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_117="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_117}" 1
    fi
    local command_5
    command_5="$(mkpasswd ''"${p_115}"'')"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong with the mkpasswd command"'!'"" 1
        exit 1
    fi
    local hashed_password_118="${command_5}"
    file_write__41_v0 "/mnt/persist/home/${u_116}/hashedPasswordFile" "${hashed_password_118}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "File: /mnt/persist/home/${u_116}/hashedPasswordFile. Was not created"'!'" Status: ${__status}" 1
        exit 1
    fi
    ret_linux_password246_v0="/mnt/persist/home/${u_116}/hashedPasswordFile"
    return 0
}

# linux_private(m: Text, u: Text)
linux_private__247_v0() {
    local m_80="${1}"
    local u_81="${2}"
    local file_name_82="private.nix"
    local content_83=""
    local __length_6="${m_80}"
    local __length_7="${u_81}"
    if [ "$(( $(( ${#__length_6} > 0 )) && $(( ${#__length_7} > 0 )) ))" != 0 ]; then
        content_83="{
  ${m_80} = {
    username = \"${u_81}\";
  };
}
"
    else
        echo_error__142_v0 "machine_name or username empty"'!'"" 1
        exit 1
    fi
    file_exists__39_v0 "${dir_path_5}/private/${file_name_82}"
    local ret_file_exists39_v0__87_6="${ret_file_exists39_v0}"
    if [ "${ret_file_exists39_v0__87_6}" != 0 ]; then
        file_write__41_v0 "${dir_path_5}/private/${file_name_82}" "${content_83}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo_error__142_v0 "File: ${dir_path_5}/private/${file_name_82}. Was not created"'!'" Status: ${__status}" 1
            exit 1
        fi
    else
        file_append__42_v0 "${dir_path_5}/private/${file_name_82}" "${content_83}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo_error__142_v0 "File: ${dir_path_5}/private/${file_name_82}. Was not created"'!'" Status: ${__status}" 1
            exit 1
        fi
    fi
    ret_linux_private247_v0="${dir_path_5}/private/${file_name_82}"
    return 0
}

# linux_disko(machine_name: Text, version: Text)
linux_disko__248_v0() {
    local machine_name_103="${1}"
    local version_104="${2}"
    file_download__241_v0 "${raw_nixos_config_github_4}/${version_104}/hosts/${machine_name_103}/disko-configuration.nix" "${dir_path_5}/disko-configuration.nix"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_108="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_108}" 1
    fi
    # Destroy, format and mount the disk via disko
    nix     --extra-experimental-features "nix-command flakes"     run github:nix-community/disko/latest     -- --mode destroy,format,mount       ${dir_path_5}/disko-configuration.nix
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong with disko"'!'" Error: ${__status}" 1
        exit 1
    fi
    # Make a snapshot of the root filesystem
    umount -R /mnt
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong with the recursive umount"'!'"" 1
        exit 1
    fi
    mount /dev/mapper/system /mnt
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong with the mount of the system"'!'"" 1
        exit 1
    fi
    btrfs subvolume snapshot -r /mnt/@root /mnt/@root-blank
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong during the root snapshot"'!'"" 1
        exit 1
    fi
    umount /mnt
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong with the root umount"'!'"" 1
        exit 1
    fi
    # Mount back the system
    nix     --extra-experimental-features "nix-command flakes"     run github:nix-community/disko/latest     -- --mode mount       ${dir_path_5}/disko-configuration.nix
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong with disko"'!'" Error: ${__status}" 1
        exit 1
    fi
    ret_linux_disko248_v0=1
    return 0
}

# linux_install(opts: [Text])
linux_install__249_v0() {
    local opts_42=("${!1}")
    local configuration_name_43=""
    local disk_path_44=""
    local machine_name_45=""
    local password_46=""
    local secure_erase_47=0
    local sops_secret_path_48=""
    local username_49=""
    local version_50=""
    local disko_version_51="latest"
    dir_create__44_v0 "${dir_path_5}"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_54="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_54}" 1
    fi
    dir_create__44_v0 "${dir_path_5}/private"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_55="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_55}" 1
    fi
    dir_create__44_v0 "${dir_path_5}/sops/age"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_56="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_56}" 1
    fi
    i_58=0;
    for opt_57 in "${opts_42[@]}"; do
        if [ "$(( $([ "_${opt_57}" != "_-c" ]; echo $?) || $([ "_${opt_57}" != "_--configuration-name" ]; echo $?) ))" != 0 ]; then
            local c_opt_59="${opts_42[$(( i_58 + 1 ))]?"Index out of bounds (at install.ab:181:26)"}"
            if [ "$(( $([ "_${c_opt_59}" != "_desktop" ]; echo $?) || $([ "_${c_opt_59}" != "_framework" ]; echo $?) ))" != 0 ]; then
                configuration_name_43="${c_opt_59}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "Wrong configuration name"'!'"" 1
                exit 1
            fi
        elif [ "$(( $([ "_${opt_57}" != "_-d" ]; echo $?) || $([ "_${opt_57}" != "_--disk-path" ]; echo $?) ))" != 0 ]; then
            local d_opt_60="${opts_42[$(( i_58 + 1 ))]?"Index out of bounds (at install.ab:192:26)"}"
            local __length_10="${d_opt_60}"
            if [ "$(( ${#__length_10} > 0 ))" != 0 ]; then
                disk_path_44="${d_opt_60}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "Disk path not specified"'!'"" 1
                exit 1
            fi
        elif [ "$(( $([ "_${opt_57}" != "_-h" ]; echo $?) || $([ "_${opt_57}" != "_--help" ]; echo $?) ))" != 0 ]; then
            linux_menu__245_v0
            exit 0
        elif [ "$(( $([ "_${opt_57}" != "_-m" ]; echo $?) || $([ "_${opt_57}" != "_--machine-name" ]; echo $?) ))" != 0 ]; then
            machine_name_45="${opts_42[$(( i_58 + 1 ))]?"Index out of bounds (at install.ab:207:67)"}"
        elif [ "$(( $([ "_${opt_57}" != "_-p" ]; echo $?) || $([ "_${opt_57}" != "_--password" ]; echo $?) ))" != 0 ]; then
            local p_opt_61="${opts_42[$(( i_58 + 1 ))]?"Index out of bounds (at install.ab:210:26)"}"
            local __length_11="${p_opt_61}"
            if [ "$(( ${#__length_11} > 0 ))" != 0 ]; then
                password_46="${p_opt_61}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "password is empty"'!'"" 1
                exit 1
            fi
        elif [ "$([ "_${opt_57}" != "_--secure" ]; echo $?)" != 0 ]; then
            secure_erase_47=1
        elif [ "$(( $([ "_${opt_57}" != "_-s" ]; echo $?) || $([ "_${opt_57}" != "_--sops-secret-path" ]; echo $?) ))" != 0 ]; then
            local s_opt_62="${opts_42[$(( i_58 + 1 ))]?"Index out of bounds (at install.ab:223:26)"}"
            file_exists__39_v0 "${s_opt_62}"
            local ret_file_exists39_v0__224_12="${ret_file_exists39_v0}"
            if [ "${ret_file_exists39_v0__224_12}" != 0 ]; then
                sops_secret_path_48="${s_opt_62}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "Sops secret file not found"'!'"" 1
                exit 1
            fi
        elif [ "$(( $([ "_${opt_57}" != "_-u" ]; echo $?) || $([ "_${opt_57}" != "_--username" ]; echo $?) ))" != 0 ]; then
            local u_opt_65="${opts_42[$(( i_58 + 1 ))]?"Index out of bounds (at install.ab:234:26)"}"
            local __length_12="${u_opt_65}"
            if [ "$(( ${#__length_12} > 0 ))" != 0 ]; then
                username_49="${u_opt_65}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "Username is empty"'!'"" 1
                exit 1
            fi
        elif [ "$(( $([ "_${opt_57}" != "_-v" ]; echo $?) || $([ "_${opt_57}" != "_--version" ]; echo $?) ))" != 0 ]; then
            local v_opt_66="${opts_42[$(( i_58 + 1 ))]?"Index out of bounds (at install.ab:245:26)"}"
            local __length_13="${v_opt_66}"
            if [ "$(( ${#__length_13} > 0 ))" != 0 ]; then
                version_50="${v_opt_66}"
            else
                version_50="main"
            fi
        elif [ "$([ "_${opt_57}" != "_--disko-version" ]; echo $?)" != 0 ]; then
            local disko_version_opt_67="${opts_42[$(( i_58 + 1 ))]?"Index out of bounds (at install.ab:254:38)"}"
            local __length_14="${disko_version_opt_67}"
            if [ "$(( ${#__length_14} > 0 ))" != 0 ]; then
                disko_version_51="${disko_version_opt_67}"
            else
                disko_version_51="latest"
            fi
        fi
        (( i_58++ )) || true
    done
    local __length_15="${password_46}"
    if [ "$(( ${#__length_15} == 0 ))" != 0 ]; then
        linux_menu__245_v0
        echo_error__142_v0 "error: password is empty"'!'"" 1
        exit 1
    fi
    if [ "${secure_erase_47}" != 0 ]; then
        nvme format --force ${disk_path_44}
        __status=$?
    fi
    linux_private__247_v0 "${machine_name_45}" "${username_49}"
    local private_path_88="${ret_linux_private247_v0}"
    linux_disko__248_v0 "${machine_name_45}" "${disko_version_51}"
    # Copy the private.nix file in the permanent directory
    dir_create__44_v0 "/mnt/persist/private"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_109="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_109}" 1
    fi
    cp "${private_path_88}" "/mnt/persist/private/private.nix"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong during the copy of the private.nix file"'!'"" 1
        exit 1
    fi
    # Copy the sops secret in the temporary directory
    cp "${sops_secret_path_48}" "${dir_path_5}/sops/age/keys.txt"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong during the copy of the age key file"'!'"" 1
        exit 1
    fi
    # Copy the sops secret in the permanent directory
    dir_create__44_v0 "/mnt/persist/sops/age"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_110="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_110}" 1
    fi
    cp "${sops_secret_path_48}" "/mnt/persist/sops/age/keys.txt"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong during the copy of the age key file"'!'"" 1
        exit 1
    fi
    # Create the hashed password file containing the user password
    linux_password__246_v0 "${password_46}" "${username_49}"
    # Install NixOS
    nixos-install --root /mnt --flake ${nixos_config_github_3}/${version_50}#${configuration_name_43} --impure
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong with nixos-install"'!'" Error: ${__status}" 1
        exit 1
    fi
    echo_info__139_v0 "Ready to reboot. Don't forget to remove the usb key"
    ret_linux_install249_v0=1
    return 0
}

# darwin_private(machine_name: Text, username: Text)
darwin_private__251_v0() {
    local machine_name_149="${1}"
    local username_150="${2}"
    local content_151=""
    local private_path_152=""
    local __length_16="${machine_name_149}"
    local __length_17="${username_150}"
    if [ "$(( $(( ${#__length_16} > 0 )) && $(( ${#__length_17} > 0 )) ))" != 0 ]; then
        private_path_152="/Users/${username_150}/src/perso/darwin/private.nix"
        content_151="{
  ${machine_name_149} = {
    username = \"${username_150}\";
  };
}
"
    else
        echo_error__142_v0 "machine_name or username empty"'!'"" 1
        exit 1
    fi
    file_exists__39_v0 "${private_path_152}"
    local ret_file_exists39_v0__353_6="${ret_file_exists39_v0}"
    if [ "${ret_file_exists39_v0__353_6}" != 0 ]; then
        file_write__41_v0 "${private_path_152}" "${content_151}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo_error__142_v0 "File: ${private_path_152}. Was not created"'!'" Status: ${__status}" 1
            exit 1
        fi
    else
        file_append__42_v0 "${private_path_152}" "${content_151}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo_error__142_v0 "File: ${private_path_152}. Was not created"'!'" Status: ${__status}" 1
            exit 1
        fi
    fi
    ret_darwin_private251_v0="${private_path_152}"
    return 0
}

# darwin_install(opts: [Text])
darwin_install__252_v0() {
    local opts_130=("${!1}")
    local configuration_name_131=""
    local machine_name_132=""
    local sops_secret_path_133=""
    local username_134=""
    local version_135="main"
    i_137=0;
    for opt_136 in "${opts_130[@]}"; do
        if [ "$(( $([ "_${opt_136}" != "_-c" ]; echo $?) || $([ "_${opt_136}" != "_--configuration-name" ]; echo $?) ))" != 0 ]; then
            local c_opt_138="${opts_130[$(( i_137 + 1 ))]?"Index out of bounds (at install.ab:380:26)"}"
            if [ "$([ "_${c_opt_138}" != "_work" ]; echo $?)" != 0 ]; then
                configuration_name_131="${c_opt_138}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "Wrong configuration name"'!'"" 1
                exit 1
            fi
        elif [ "$(( $([ "_${opt_136}" != "_-h" ]; echo $?) || $([ "_${opt_136}" != "_--help" ]; echo $?) ))" != 0 ]; then
            linux_menu__245_v0
            exit 0
        elif [ "$(( $([ "_${opt_136}" != "_-m" ]; echo $?) || $([ "_${opt_136}" != "_--machine-name" ]; echo $?) ))" != 0 ]; then
            machine_name_132="${opts_130[$(( i_137 + 1 ))]?"Index out of bounds (at install.ab:395:67)"}"
        elif [ "$(( $([ "_${opt_136}" != "_-s" ]; echo $?) || $([ "_${opt_136}" != "_--sops-secret-path" ]; echo $?) ))" != 0 ]; then
            local s_opt_139="${opts_130[$(( i_137 + 1 ))]?"Index out of bounds (at install.ab:398:26)"}"
            file_exists__39_v0 "${s_opt_139}"
            local ret_file_exists39_v0__399_12="${ret_file_exists39_v0}"
            if [ "${ret_file_exists39_v0__399_12}" != 0 ]; then
                sops_secret_path_133="${s_opt_139}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "Sops secret file not found"'!'"" 1
                exit 1
            fi
        elif [ "$(( $([ "_${opt_136}" != "_-u" ]; echo $?) || $([ "_${opt_136}" != "_--username" ]; echo $?) ))" != 0 ]; then
            local u_opt_140="${opts_130[$(( i_137 + 1 ))]?"Index out of bounds (at install.ab:409:26)"}"
            local __length_20="${u_opt_140}"
            if [ "$(( ${#__length_20} > 0 ))" != 0 ]; then
                username_134="${u_opt_140}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "Username is empty"'!'"" 1
                exit 1
            fi
        elif [ "$(( $([ "_${opt_136}" != "_-v" ]; echo $?) || $([ "_${opt_136}" != "_--version" ]; echo $?) ))" != 0 ]; then
            local v_opt_141="${opts_130[$(( i_137 + 1 ))]?"Index out of bounds (at install.ab:420:26)"}"
            local __length_21="${v_opt_141}"
            if [ "$(( ${#__length_21} > 0 ))" != 0 ]; then
                version_135="${v_opt_141}"
            fi
        fi
        (( i_137++ )) || true
    done
    # Copy the sops secret in the permanent directory
    dir_create__44_v0 "/Users/${username_134}/.config/sops/age"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_142="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_142}" 1
    fi
    cp "${sops_secret_path_133}" "/Users/${username_134}/.config/sops/age/keys.txt"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong during the copy of the age key file"'!'"" 1
        exit 1
    fi
    # Create source directory
    dir_create__44_v0 "/Users/${username_134}/src/perso/darwin"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_143="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_143}" 1
    fi
    # Setup the repository for installation
    file_download__241_v0 "https://github.com/Enoxime/nixos-config/archive/refs/heads/${version_135}.zip" "/Users/${username_134}/src/perso/darwin.zip"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_144="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_144}" 1
    fi
    cd "/Users/${username_134}/src/perso"
    __status=$?
    bsdtar -x --strip-components=1 --directory darwin -f darwin.zip
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong with unzip darwin.zip"'!'" Error: ${__status}" 1
        exit 1
    fi
    cd "/Users/${username_134}/src/perso/darwin"
    __status=$?
    darwin_private__251_v0 "${machine_name_132}" "${username_134}"
    # Install Nix darwin
    curl -fsSL https://install.determinate.systems.nix | sh -s -- install --determinate
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong with installing darwin"'!'" Error: ${__status}" 1
        exit 1
    fi
    nix run nix-darwin/master#darwwin-rebuild -- switch --flake path:.#${configuration_name_131}
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong with installing darwin"'!'" Error: ${__status}" 1
        exit 1
    fi
    echo_info__139_v0 "Ready to reboot"
    ret_darwin_install252_v0=1
    return 0
}

typeset -r args_6=("$0" "$@")
is_root__131_v0
ret_is_root131_v0__472_10="${ret_is_root131_v0}"
if [ "$(( ! ret_is_root131_v0__472_10 ))" != 0 ]; then
    echo_error__142_v0 "This script requires root permissions"'!'"" 1
    exit 1
fi
__length_23=("${args_6[@]}")
if [ "$(( ${#__length_23[@]} < 2 ))" != 0 ]; then
    menu__244_v0
    exit 0
elif [ "$([ "_${args_6[1]?"Index out of bounds (at install.ab:483:10)"}" != "_linux_install" ]; echo $?)" != 0 ]; then
    __length_25=("${args_6[@]}")
    slice_upper_24="$(( ${#__length_25[@]} + 1 ))"
    slice_offset_26=2
    slice_offset_26=$((${slice_offset_26} > 0 ? ${slice_offset_26} : 0))
    slice_length_27="$(( slice_upper_24 - slice_offset_26 ))"
    slice_length_27=$((${slice_length_27} > 0 ? ${slice_length_27} : 0))
    linux_args_17=("${args_6[@]:${slice_offset_26}:${slice_length_27}}")
    linux_install__249_v0 linux_args_17[@]
elif [ "$([ "_${args_6[1]?"Index out of bounds (at install.ab:488:10)"}" != "_darwin_install" ]; echo $?)" != 0 ]; then
    __length_29=("${args_6[@]}")
    slice_upper_28="$(( ${#__length_29[@]} + 1 ))"
    slice_offset_30=2
    slice_offset_30=$((${slice_offset_30} > 0 ? ${slice_offset_30} : 0))
    slice_length_31="$(( slice_upper_28 - slice_offset_30 ))"
    slice_length_31=$((${slice_length_31} > 0 ? ${slice_length_31} : 0))
    darwin_args_121=("${args_6[@]:${slice_offset_30}:${slice_length_31}}")
    darwin_install__252_v0 darwin_args_121[@]
elif [ "$(( $([ "_${args_6[1]?"Index out of bounds (at install.ab:493:10)"}" != "_-h" ]; echo $?) || $([ "_${args_6[1]?"Index out of bounds (at install.ab:493:29)"}" != "_--help" ]; echo $?) ))" != 0 ]; then
    menu__244_v0
else
    menu__244_v0
fi
exit 1
