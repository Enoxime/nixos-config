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

        # Pipenv auto source (pipenv shell)
        function auto_pipenv_shell {
          if [ ! -n "''${PIPENV_ACTIVE+1}" ]; then
            if [ -f "Pipfile" ] ; then
              pipenv shell
            fi
          fi
        }

        function cd {
          builtin cd "$@"
          auto_pipenv_shell
        }

        auto_pipenv_shell
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
        urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
        urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      };
    };
  };

  home.packages = with pkgs; [
    acpi
    acpitool
    xterm
  ];
}
