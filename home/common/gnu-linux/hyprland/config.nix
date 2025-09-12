_: {
  home.file = {
    swappyConfig = {
      enable = true;
      target = "./.config/swappy/config";
      text = ''
        [Default]
        save_dir=$HOME/Pictures/Edits
        save_filename_format=swappy-%Y%m%d-%H%M%S.png
        show_panel=false
        line_size=5
        text_size=20
        text_font=sans-serif
        paint_mode=brush
        early_exit=false
        fill_shape=false

      '';
    };

    pavucontrol = {
      enable = true;
      target = "./.config/pavucontrol.ini";
      text = ''
        [window]
        width=1515
        height=803
        sinkInputType=1
        sourceOutputType=1
        sinkType=0
        sourceType=1
        showVolumeMeters=1

      '';
    };
  };
}
