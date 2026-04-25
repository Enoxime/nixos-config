{ pkgs, ... }:
let
  zsh_aliases = {
    UUID = "$(uuidgen | tr -d \\n)";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    "......" = "cd ../../../../..";
    cat = "bat --style header --style snip --style changes --style header";
    "l." = "exa -ald --color=always --group-directories-first --icons .*";
    # la = "exa -a --color=always --group-directories-first --icons";
    # ll = "exa -l --color=always --group-directories-first --icons";
    # ls = "exa -al --color=always --group-directories-first --icons";
    # lt = "exa -aT --color=always --group-directories-first --icons";
    untar = "tar -zxvf ";
    wget = "wget -c ";
    meteo = "curl 'wttr.in/Montreal?0&lang=fr'";
    gitkeep = "find ''$([[ ! -z $@ ]] && echo $@ || echo \".\") -type d -empty -exec touch {}/.gitkeep \;";
    dgitkeep = "find ''$([[ ! -z $@ ]] && echo $@ || echo \".\") -name \".gitkeep\" -type f -delete";
    testssl = "docker run -it --rm --name test_ssl drwetter/testssl.sh";
    tf = "tofu";
    trf = "terraform";
    tal = "talosctl";
    th = "talhelper";
    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))'";
    urlencode = "python -c 'import urllib.parse as ul, sys; print(ul.quote_plus(sys.argv[1]))'";
  };
in
{
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      shellAliases = zsh_aliases;
      dirHashes = {
        src = "$HOME/src";
      };
      initContent = ''
        # battery
        RPROMPT='$(battery_pct_prompt) ...'
        BATTERY_CHARGING="⚡️"
        ZSH_AUTOSUGGEST_USE_ASYNC="true"

        # krew
        export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

        # uv auto source (source /path/to/activate)
        function auto_uv_source {
          local project_venv="''${PWD}/.venv"

          if [[ -d "$project_venv" ]]; then
            if [[ -z "$VIRTUAL_ENV" || "$VIRTUAL_ENV" != "$project_venv" ]]; then
              if [[ -n "$VIRTUAL_ENV" ]] && typeset -f deactivate >/dev/null; then
                deactivate
              fi
              source "$project_venv/bin/activate"
            fi
          elif [[ -n "$VIRTUAL_ENV" && "$VIRTUAL_ENV" == */.venv ]] && typeset -f deactivate >/dev/null; then
            deactivate
          fi
        }

        function cd {
          builtin cd "$@"
          auto_uv_source
        }

        auto_uv_source
        export TERM=xterm-256color

        # kubecolor
        # TODO: find a better way via nix to concat those files
        cat $HOME/.kube/kubecolor.yaml $HOME/.kube/kubecolor-catppuccin.yaml > $HOME/.kube/color.yaml
        export KUBECOLOR_CONFIG="$HOME/.kube/color.yaml"
      '';
      oh-my-zsh = {
        enable = true;
        # custom = "$HOME/.oh-my-custom";
        # theme = "bira";
        theme = "lukerandall";
        plugins = [
          "battery"
          "command-not-found"
          "fluxcd"
          "git"
          "helm"
          "history"
          "kubectl"
          "ssh"
          "sudo"
        ];
      };
    };

    bash = {
      enable = true;
      enableCompletion = true;
      # TODO add your custom bashrc here
      bashrcExtra = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.kube/plugins/bin"
      '';

      # set some aliases, feel free to add more or remove some
      shellAliases = {
        k = "kubectl";
        urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))'";
        urlencode = "python -c 'import urllib.parse as ul, sys; print(ul.quote_plus(sys.argv[1]))'";
      };
    };
  };

  home.packages = with pkgs; [
    acpi
    acpitool
    xterm
  ];
}
