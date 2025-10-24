_: {
  # https://github.com/koekeishiya/yabai
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      mouse_follows_focus = true;
      focus_follows_mouse = "autofocus";
      display_arrangements_order = "default";
      window_origin_display = "default";
      windwow_placement = "second_child";
      layout = "bsp";
      split_type = "vertical";
      top_padding = 5;
      bottom_padding = 5;
      left_padding = 5;
      right_padding = 5;
      window_gap = 5;
    };
  };
}
