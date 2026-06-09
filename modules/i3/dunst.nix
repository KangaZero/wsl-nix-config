{ pkgs, ... }:
{
  # libnotify = `notify-send` for testing: notify-send "hi" "body"
  home.packages = [ pkgs.libnotify ];

  # Notification daemon. Config + package + D-Bus activation file are managed
  # here; the actual daemon is started from i3 (exec in modules/i3/default.nix)
  # because xrdp+i3 has no graphical-session.target to autostart the unit.
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # --- geometry ---
        width = 320;
        height = 300; # max height; dunst grows down to this
        origin = "top-right";
        offset = "12x12";
        gap_size = 6;
        notification_limit = 5;

        # --- rice: rounded, framed, Catppuccin Mocha ---
        frame_width = 2;
        frame_color = "#89b4fa"; # blue
        separator_color = "frame";
        corner_radius = 10;
        transparency = 0; # WSL/xrdp: no compositor → keep opaque
        progress_bar = true;
        progress_bar_height = 8;
        progress_bar_frame_width = 1;

        # --- text ---
        font = "JetBrainsMono Nerd Font 10";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        word_wrap = true;
        padding = 12;
        horizontal_padding = 12;
        text_icon_padding = 8;

        # --- icons ---
        icon_position = "left";
        min_icon_size = 24;
        max_icon_size = 48;
        enable_recursive_icon_lookup = true;

        # --- behaviour ---
        follow = "mouse";
        idle_threshold = 120;
        show_age_threshold = 60;
        sticky_history = true;
        history_length = 20;
        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
      };

      # urgency tiers — frame color signals severity, body stays Mocha base/text
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#89b4fa"; # blue
        timeout = 5;
      };
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#cba6f7"; # mauve
        timeout = 8;
      };
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#f38ba8"; # red
        timeout = 0; # critical stays until dismissed
      };
    };
  };
}
