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
    local path_51="${1}"
    [ -d "${path_51}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# file_exists(path: Text)
file_exists__39_v0() {
    local path_62="${1}"
    [ -f "${path_62}" ]
    __status=$?
    ret_file_exists39_v0="$(( __status == 0 ))"
    return 0
}

# file_write(path: Text, content: Text)
file_write__41_v0() {
    local path_81="${1}"
    local content_82="${2}"
    local command_0
    command_0="$(printf '%s
' "${content_82}" > "${path_81}")"
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
    local path_83="${1}"
    local content_84="${2}"
    local command_1
    command_1="$(printf '%s
' "${content_84}" >> "${path_83}")"
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
    local path_50="${1}"
    dir_exists__38_v0 "${path_50}"
    local ret_dir_exists38_v0__87_12="${ret_dir_exists38_v0}"
    if [ "$(( ! ret_dir_exists38_v0__87_12 ))" != 0 ]; then
        mkdir -p "${path_50}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_dir_create44_v0=''
            return "${__status}"
        fi
    fi
}

# is_command(command: Text)
is_command__126_v0() {
    local command_104="${1}"
    [ -x "$(command -v "${command_104}")" ]
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
    local message_117="${1}"
    local array_3=("${message_117}")
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
    local url_102="${1}"
    local path_103="${2}"
    is_command__126_v0 "curl"
    local ret_is_command126_v0__15_9="${ret_is_command126_v0}"
    is_command__126_v0 "wget"
    local ret_is_command126_v0__18_9="${ret_is_command126_v0}"
    is_command__126_v0 "aria2c"
    local ret_is_command126_v0__21_9="${ret_is_command126_v0}"
    if [ "${ret_is_command126_v0__15_9}" != 0 ]; then
        curl -L -o "${path_103}" "${url_102}">/dev/null 2>&1
        __status=$?
    elif [ "${ret_is_command126_v0__18_9}" != 0 ]; then
        wget "${url_102}" -P "${path_103}">/dev/null 2>&1
        __status=$?
    elif [ "${ret_is_command126_v0__21_9}" != 0 ]; then
        aria2c "${url_102}" -d "${path_103}">/dev/null 2>&1
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
  -v  --version             Specify a tag or a branch. Set to latest by default
"
}

# linux_password(p: Text, u: Text)
linux_password__246_v0() {
    local p_112="${1}"
    local u_113="${2}"
    dir_create__44_v0 "/mnt/persist/home/${u_113}"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_114="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_114}" 1
    fi
    local command_5
    command_5="$(mkpasswd ''"${p_112}"'')"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong with the mkpasswd command"'!'"" 1
        exit 1
    fi
    local hashed_password_115="${command_5}"
    file_write__41_v0 "/mnt/persist/home/${u_113}/hashedPasswordFile" "${hashed_password_115}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "File: /mnt/persist/home/${u_113}/hashedPasswordFile. Was not created"'!'" Status: ${__status}" 1
        exit 1
    fi
    ret_linux_password246_v0="/mnt/persist/home/${u_113}/hashedPasswordFile"
    return 0
}

# linux_private(m: Text, u: Text)
linux_private__247_v0() {
    local m_77="${1}"
    local u_78="${2}"
    local file_name_79="private.nix"
    local content_80=""
    local __length_6="${m_77}"
    local __length_7="${u_78}"
    if [ "$(( $(( ${#__length_6} > 0 )) && $(( ${#__length_7} > 0 )) ))" != 0 ]; then
        content_80="{
  ${m_77} = {
    username = \"${u_78}\";
  };
}
"
    else
        echo_error__142_v0 "machine_name or username empty"'!'"" 1
        exit 1
    fi
    file_exists__39_v0 "${dir_path_5}/private/${file_name_79}"
    local ret_file_exists39_v0__86_6="${ret_file_exists39_v0}"
    if [ "${ret_file_exists39_v0__86_6}" != 0 ]; then
        file_write__41_v0 "${dir_path_5}/private/${file_name_79}" "${content_80}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo_error__142_v0 "File: ${dir_path_5}/private/${file_name_79}. Was not created"'!'" Status: ${__status}" 1
            exit 1
        fi
    else
        file_append__42_v0 "${dir_path_5}/private/${file_name_79}" "${content_80}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo_error__142_v0 "File: ${dir_path_5}/private/${file_name_79}. Was not created"'!'" Status: ${__status}" 1
            exit 1
        fi
    fi
    ret_linux_private247_v0="${dir_path_5}/private/${file_name_79}"
    return 0
}

# linux_disko(machine_name: Text, version: Text)
linux_disko__248_v0() {
    local machine_name_100="${1}"
    local version_101="${2}"
    file_download__241_v0 "${raw_nixos_config_github_4}/${version_101}/hosts/${machine_name_100}/disko-configuration.nix" "${dir_path_5}/disko-configuration.nix"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_105="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_105}" 1
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
    local opts_41=("${!1}")
    local configuration_name_42=""
    local disk_path_43=""
    local machine_name_44=""
    local password_45=""
    local secure_erase_46=0
    local sops_secret_path_47=""
    local username_48=""
    local version_49="latest"
    dir_create__44_v0 "${dir_path_5}"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_52="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_52}" 1
    fi
    dir_create__44_v0 "${dir_path_5}/private"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_53="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_53}" 1
    fi
    dir_create__44_v0 "${dir_path_5}/sops/age"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_54="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_54}" 1
    fi
    i_56=0;
    for opt_55 in "${opts_41[@]}"; do
        if [ "$(( $([ "_${opt_55}" != "_-c" ]; echo $?) || $([ "_${opt_55}" != "_--configuration-name" ]; echo $?) ))" != 0 ]; then
            local c_opt_57="${opts_41[$(( i_56 + 1 ))]?"Index out of bounds (at install.ab:179:26)"}"
            if [ "$(( $([ "_${c_opt_57}" != "_desktop" ]; echo $?) || $([ "_${c_opt_57}" != "_framework" ]; echo $?) ))" != 0 ]; then
                configuration_name_42="${c_opt_57}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "Wrong configuration name"'!'"" 1
                exit 1
            fi
        elif [ "$(( $([ "_${opt_55}" != "_-d" ]; echo $?) || $([ "_${opt_55}" != "_--disk-path" ]; echo $?) ))" != 0 ]; then
            local d_opt_58="${opts_41[$(( i_56 + 1 ))]?"Index out of bounds (at install.ab:190:26)"}"
            local __length_10="${d_opt_58}"
            if [ "$(( ${#__length_10} > 0 ))" != 0 ]; then
                disk_path_43="${d_opt_58}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "Disk path not specified"'!'"" 1
                exit 1
            fi
        elif [ "$(( $([ "_${opt_55}" != "_-h" ]; echo $?) || $([ "_${opt_55}" != "_--help" ]; echo $?) ))" != 0 ]; then
            linux_menu__245_v0
            exit 0
        elif [ "$(( $([ "_${opt_55}" != "_-m" ]; echo $?) || $([ "_${opt_55}" != "_--machine-name" ]; echo $?) ))" != 0 ]; then
            machine_name_44="${opts_41[$(( i_56 + 1 ))]?"Index out of bounds (at install.ab:205:67)"}"
        elif [ "$(( $([ "_${opt_55}" != "_-p" ]; echo $?) || $([ "_${opt_55}" != "_--password" ]; echo $?) ))" != 0 ]; then
            local p_opt_59="${opts_41[$(( i_56 + 1 ))]?"Index out of bounds (at install.ab:208:26)"}"
            local __length_11="${p_opt_59}"
            if [ "$(( ${#__length_11} > 0 ))" != 0 ]; then
                password_45="${p_opt_59}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "password is empty"'!'"" 1
                exit 1
            fi
        elif [ "$([ "_${opt_55}" != "_--secure" ]; echo $?)" != 0 ]; then
            secure_erase_46=1
        elif [ "$(( $([ "_${opt_55}" != "_-s" ]; echo $?) || $([ "_${opt_55}" != "_--sops-secret-path" ]; echo $?) ))" != 0 ]; then
            local s_opt_60="${opts_41[$(( i_56 + 1 ))]?"Index out of bounds (at install.ab:221:26)"}"
            file_exists__39_v0 "${s_opt_60}"
            local ret_file_exists39_v0__222_12="${ret_file_exists39_v0}"
            if [ "${ret_file_exists39_v0__222_12}" != 0 ]; then
                sops_secret_path_47="${s_opt_60}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "Sops secret file not found"'!'"" 1
                exit 1
            fi
        elif [ "$(( $([ "_${opt_55}" != "_-u" ]; echo $?) || $([ "_${opt_55}" != "_--username" ]; echo $?) ))" != 0 ]; then
            local u_opt_63="${opts_41[$(( i_56 + 1 ))]?"Index out of bounds (at install.ab:232:26)"}"
            local __length_12="${u_opt_63}"
            if [ "$(( ${#__length_12} > 0 ))" != 0 ]; then
                username_48="${u_opt_63}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "Username is empty"'!'"" 1
                exit 1
            fi
        elif [ "$(( $([ "_${opt_55}" != "_-v" ]; echo $?) || $([ "_${opt_55}" != "_--version" ]; echo $?) ))" != 0 ]; then
            local v_opt_64="${opts_41[$(( i_56 + 1 ))]?"Index out of bounds (at install.ab:243:26)"}"
            local __length_13="${v_opt_64}"
            if [ "$(( ${#__length_13} > 0 ))" != 0 ]; then
                version_49="${v_opt_64}"
            fi
        fi
        (( i_56++ )) || true
    done
    local __length_14="${password_45}"
    if [ "$(( ${#__length_14} == 0 ))" != 0 ]; then
        linux_menu__245_v0
        echo_error__142_v0 "error: password is empty"'!'"" 1
        exit 1
    fi
    if [ "${secure_erase_46}" != 0 ]; then
        nvme format --force ${disk_path_43}
        __status=$?
    fi
    linux_private__247_v0 "${machine_name_44}" "${username_48}"
    local private_path_85="${ret_linux_private247_v0}"
    linux_disko__248_v0 "${machine_name_44}" "${version_49}"
    # Copy the private.nix file in the permanent directory
    dir_create__44_v0 "/mnt/persist/private"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_106="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_106}" 1
    fi
    cp "${private_path_85}" "/mnt/persist/private/private.nix"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong during the copy of the private.nix file"'!'"" 1
        exit 1
    fi
    # Copy the sops secret in the temporary directory
    cp "${sops_secret_path_47}" "${dir_path_5}/sops/age/keys.txt"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong during the copy of the age key file"'!'"" 1
        exit 1
    fi
    # Copy the sops secret in the permanent directory
    dir_create__44_v0 "/mnt/persist/sops/age"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_107="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_107}" 1
    fi
    cp "${sops_secret_path_47}" "/mnt/persist/sops/age/keys.txt"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong during the copy of the age key file"'!'"" 1
        exit 1
    fi
    # Create the hashed password file containing the user password
    linux_password__246_v0 "${password_45}" "${username_48}"
    # Install NixOS
    nixos-install --root /mnt --flake ${nixos_config_github_3}/${version_49}#${configuration_name_42} --impure
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
    local machine_name_146="${1}"
    local username_147="${2}"
    local content_148=""
    local private_path_149=""
    local __length_15="${machine_name_146}"
    local __length_16="${username_147}"
    if [ "$(( $(( ${#__length_15} > 0 )) && $(( ${#__length_16} > 0 )) ))" != 0 ]; then
        private_path_149="/Users/${username_147}/src/perso/darwin/private.nix"
        content_148="{
  ${machine_name_146} = {
    username = \"${username_147}\";
  };
}
"
    else
        echo_error__142_v0 "machine_name or username empty"'!'"" 1
        exit 1
    fi
    file_exists__39_v0 "${private_path_149}"
    local ret_file_exists39_v0__338_6="${ret_file_exists39_v0}"
    if [ "${ret_file_exists39_v0__338_6}" != 0 ]; then
        file_write__41_v0 "${private_path_149}" "${content_148}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo_error__142_v0 "File: ${private_path_149}. Was not created"'!'" Status: ${__status}" 1
            exit 1
        fi
    else
        file_append__42_v0 "${private_path_149}" "${content_148}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo_error__142_v0 "File: ${private_path_149}. Was not created"'!'" Status: ${__status}" 1
            exit 1
        fi
    fi
    ret_darwin_private251_v0="${private_path_149}"
    return 0
}

# darwin_install(opts: [Text])
darwin_install__252_v0() {
    local opts_127=("${!1}")
    local configuration_name_128=""
    local machine_name_129=""
    local sops_secret_path_130=""
    local username_131=""
    local version_132="main"
    i_134=0;
    for opt_133 in "${opts_127[@]}"; do
        if [ "$(( $([ "_${opt_133}" != "_-c" ]; echo $?) || $([ "_${opt_133}" != "_--configuration-name" ]; echo $?) ))" != 0 ]; then
            local c_opt_135="${opts_127[$(( i_134 + 1 ))]?"Index out of bounds (at install.ab:365:26)"}"
            if [ "$([ "_${c_opt_135}" != "_work" ]; echo $?)" != 0 ]; then
                configuration_name_128="${c_opt_135}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "Wrong configuration name"'!'"" 1
                exit 1
            fi
        elif [ "$(( $([ "_${opt_133}" != "_-h" ]; echo $?) || $([ "_${opt_133}" != "_--help" ]; echo $?) ))" != 0 ]; then
            linux_menu__245_v0
            exit 0
        elif [ "$(( $([ "_${opt_133}" != "_-m" ]; echo $?) || $([ "_${opt_133}" != "_--machine-name" ]; echo $?) ))" != 0 ]; then
            machine_name_129="${opts_127[$(( i_134 + 1 ))]?"Index out of bounds (at install.ab:380:67)"}"
        elif [ "$(( $([ "_${opt_133}" != "_-s" ]; echo $?) || $([ "_${opt_133}" != "_--sops-secret-path" ]; echo $?) ))" != 0 ]; then
            local s_opt_136="${opts_127[$(( i_134 + 1 ))]?"Index out of bounds (at install.ab:383:26)"}"
            file_exists__39_v0 "${s_opt_136}"
            local ret_file_exists39_v0__384_12="${ret_file_exists39_v0}"
            if [ "${ret_file_exists39_v0__384_12}" != 0 ]; then
                sops_secret_path_130="${s_opt_136}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "Sops secret file not found"'!'"" 1
                exit 1
            fi
        elif [ "$(( $([ "_${opt_133}" != "_-u" ]; echo $?) || $([ "_${opt_133}" != "_--username" ]; echo $?) ))" != 0 ]; then
            local u_opt_137="${opts_127[$(( i_134 + 1 ))]?"Index out of bounds (at install.ab:394:26)"}"
            local __length_19="${u_opt_137}"
            if [ "$(( ${#__length_19} > 0 ))" != 0 ]; then
                username_131="${u_opt_137}"
            else
                linux_menu__245_v0
                echo_error__142_v0 "Username is empty"'!'"" 1
                exit 1
            fi
        elif [ "$(( $([ "_${opt_133}" != "_-v" ]; echo $?) || $([ "_${opt_133}" != "_--version" ]; echo $?) ))" != 0 ]; then
            local v_opt_138="${opts_127[$(( i_134 + 1 ))]?"Index out of bounds (at install.ab:405:26)"}"
            local __length_20="${v_opt_138}"
            if [ "$(( ${#__length_20} > 0 ))" != 0 ]; then
                version_132="${v_opt_138}"
            fi
        fi
        (( i_134++ )) || true
    done
    # Copy the sops secret in the permanent directory
    dir_create__44_v0 "/Users/${username_131}/.config/sops/age"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_139="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_139}" 1
    fi
    cp "${sops_secret_path_130}" "/Users/${username_131}/.config/sops/age/keys.txt"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong during the copy of the age key file"'!'"" 1
        exit 1
    fi
    # Create source directory
    dir_create__44_v0 "/Users/${username_131}/src/perso/darwin"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_140="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_140}" 1
    fi
    # Setup the repository for installation
    file_download__241_v0 "https://github.com/Enoxime/nixos-config/archive/refs/heads/${version_132}.zip" "/Users/${username_131}/src/perso/darwin.zip"
    __status=$?
    if [ "${__status}" != 0 ]; then
    code_141="${__status}"
        echo_error__142_v0 "Command failed with exit code: ${code_141}" 1
    fi
    cd "/Users/${username_131}/src/perso"
    __status=$?
    bsdtar -x --strip-components=1 --directory darwin -f darwin.zip
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong with unzip darwin.zip"'!'" Error: ${__status}" 1
        exit 1
    fi
    cd "/Users/${username_131}/src/perso/darwin"
    __status=$?
    darwin_private__251_v0 "${machine_name_129}" "${username_131}"
    # Install Nix darwin
    curl -fsSL https://install.determinate.systems.nix | sh -s -- install --determinate
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__142_v0 "Something went wrong with installing darwin"'!'" Error: ${__status}" 1
        exit 1
    fi
    nix run nix-darwin/master#darwwin-rebuild -- switch --flake path:.#${configuration_name_128}
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
ret_is_root131_v0__457_10="${ret_is_root131_v0}"
if [ "$(( ! ret_is_root131_v0__457_10 ))" != 0 ]; then
    echo_error__142_v0 "This script requires root permissions"'!'"" 1
    exit 1
fi
__length_22=("${args_6[@]}")
if [ "$(( ${#__length_22[@]} < 2 ))" != 0 ]; then
    menu__244_v0
    exit 0
elif [ "$([ "_${args_6[1]?"Index out of bounds (at install.ab:468:10)"}" != "_linux_install" ]; echo $?)" != 0 ]; then
    __length_24=("${args_6[@]}")
    slice_upper_23="$(( ${#__length_24[@]} + 1 ))"
    slice_offset_25=2
    slice_offset_25=$((${slice_offset_25} > 0 ? ${slice_offset_25} : 0))
    slice_length_26="$(( slice_upper_23 - slice_offset_25 ))"
    slice_length_26=$((${slice_length_26} > 0 ? ${slice_length_26} : 0))
    linux_args_17=("${args_6[@]:${slice_offset_25}:${slice_length_26}}")
    linux_install__249_v0 linux_args_17[@]
elif [ "$([ "_${args_6[1]?"Index out of bounds (at install.ab:473:10)"}" != "_darwin_install" ]; echo $?)" != 0 ]; then
    __length_28=("${args_6[@]}")
    slice_upper_27="$(( ${#__length_28[@]} + 1 ))"
    slice_offset_29=2
    slice_offset_29=$((${slice_offset_29} > 0 ? ${slice_offset_29} : 0))
    slice_length_30="$(( slice_upper_27 - slice_offset_29 ))"
    slice_length_30=$((${slice_length_30} > 0 ? ${slice_length_30} : 0))
    darwin_args_118=("${args_6[@]:${slice_offset_29}:${slice_length_30}}")
    darwin_install__252_v0 darwin_args_118[@]
elif [ "$(( $([ "_${args_6[1]?"Index out of bounds (at install.ab:478:10)"}" != "_-h" ]; echo $?) || $([ "_${args_6[1]?"Index out of bounds (at install.ab:478:29)"}" != "_--help" ]; echo $?) ))" != 0 ]; then
    menu__244_v0
else
    menu__244_v0
fi
exit 1
