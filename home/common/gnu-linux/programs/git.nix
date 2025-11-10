{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;
    settings = {
      alias ={
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        sw = "switch";
      };
      user = {
        name = "Enoxime";
        email = "4358598+Enoxime@users.noreply.github.com";
      };
      branch = {
        sort = "committerdate";
      };
      column = {
        ui = "auto";
      };
      commit = {
        gpgsign = true;
        verbose = true;
      };
      core = {
        editor = "nvim";
        excludesfile = "~/.gitignore";
        fsmonitor = true;
        untrackedCache = true;
        # pager = "delta";
      };
      # delta = {
      #   navigate = true;
      #   dark = true;
      #   light = false;
      # };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      fetch = {
        all = true;
        fsckobjects = true;
        prune = true;
        pruneTags = true;
      };
      grep = {
        patternType = "perl";
      };
      help = {
        autocorrect = "prompt";
      };
      init = {
        defaultBranch = "main";
      };
      # interactive = {
      #   diffFilter = "delta --color-only";
      # };
      merge = {
        conflictstyle = "zdiff3";
        tool = "meld";
      };
      pull = {
        ff = false;
        rebase = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      receive = {
        fsckObjects = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      tag = {
        sort = "version:refname";
      };
      transfer = {
        fsckobjects = true;
      };
      "url \"git@github.com:\"" = {
        insteadOf = "https://github.com/";
      };
    };
    attributes = [
      "* text=auto"
      "*.pdf diff=astextplain"
      "*.PDF diff=astextplain"
      "*.rtf diff=astextplain"
      "*.RTF diff=astextplain"
      "*.md text diff=markdown"
      "*.mdx text diff=markdown"
      "*.tex text diff=tex"
      "*.adoc text"
      "*.csv text"
      "*.txt text"
      "*.sql text"
      "*.epub diff=astextplain"
      "*.png binary"
      "*.jpg binary"
      "*.jpeg binary"
      "*.gif binary"
      "*.tif binary"
      "*.tiff binary"
      "*.ico binary"
      "*.svg text"
      "*.bash text eol=lf"
      "*.fish text eol=lf"
      "*.ksh text eol=lf"
      "*.sh text eol=lf"
      "*.zsh text eol=lf"
      "*.bat text eol=crlf"
      "*.cmd text eol=crlf"
      "*.ps1 text eol=crlf"
      "*.json text"
      "*.toml text"
      "*.xml text"
      "*.yaml text"
      "*.yml text"
      "*.7z binary"
      "*.bz binary"
      "*.bz2 binary"
      "*.bzip2 binary"
      "*.gz binary"
      "*.lz binary"
      "*.lzma binary"
      "*.rar binary"
      "*.tar binary"
      "*.taz binary"
      "*.tbz binary"
      "*.tbz2 binary"
      "*.tgz binary"
      "*.tlz binary"
      "*.txz binary"
      "*.xz binary"
      "*.Z binary"
      "*.zip binary"
      "*.zst binary"
      "*.patch -text"
      ".gitattributes export-ignore"
      ".gitignore export-ignore"
      ".gitkeep export-ignore"
    ];
    ignores = [
      ".vscode"
    ];
  };

  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      dark = true;
      light = false;
    };
  };

  home.packages = with pkgs; [
    meld
    git-extras
  ];
}
