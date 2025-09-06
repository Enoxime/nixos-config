{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Minecraft manager
    # prismlauncher
    # https://wiki.nixos.org/wiki/Prism_Launcher
    (prismlauncher.override {
      # Add binary required by some mod
      additionalPrograms = [ ffmpeg ];

      # Change Java runtimes available to Prism Launcher
      # jdks = [
      #   graalvm-ce
      #   zulu8
      #   zulu17
      #   zulu
      # ];
    })
  ];
}
