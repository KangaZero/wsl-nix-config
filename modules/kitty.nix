{ pkgs, ... }:

{
  # Kitty config translated from dotfiles-mac/kitty/kitty.conf into declarative
  # home-manager options. The Tokyo Night Moon palette (was current-theme.conf)
  # is inlined into `settings` instead of using `themeFile`, because the dotfiles
  # theme carries custom overrides (borders, opacity, background image) on top of
  # the base palette.
  #
  # Dropped from the original: the `include current-theme.conf` indirection and
  # dark-theme.auto.conf (macOS `auto_color_scheme` light/dark switching — n/a on
  # WSL/Linux).
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrains Mono";
      package = pkgs.jetbrains-mono;
    };

    settings = {
      # --- Tokyo Night Moon palette ---
      background = "#222436";
      foreground = "#c8d3f5";
      selection_background = "#2d3f76";
      selection_foreground = "#c8d3f5";
      url_color = "#4fd6be";
      cursor = "#bd93f9";
      cursor_text_color = "#222436";

      active_tab_background = "#82aaff";
      active_tab_foreground = "#1e2030";
      inactive_tab_background = "#2f334d";
      inactive_tab_foreground = "#545c7e";

      color0 = "#1b1d2b";
      color1 = "#ff757f";
      color2 = "#c3e88d";
      color3 = "#ffc777";
      color4 = "#82aaff";
      color5 = "#c099ff";
      color6 = "#86e1fc";
      color7 = "#828bb8";
      color8 = "#444a73";
      color9 = "#ff8d94";
      color10 = "#c7fb6d";
      color11 = "#ffd8ab";
      color12 = "#9ab8ff";
      color13 = "#caabff";
      color14 = "#b2ebff";
      color15 = "#c8d3f5";
      color16 = "#ff966c";
      color17 = "#c53b53";

      # --- cursor ---
      cursor_shape = "block";
      cursor_trail = 200;
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = 2;

      # --- mouse ---
      mouse_hide_wait = -1;

      # --- window layout ---
      remember_window_size = true;
      initial_window_width = 1920;
      initial_window_height = 1080;
      window_border_width = "2pt";
      draw_minimal_borders = true;
      window_padding_width = 5;
      active_border_color = "#bd93f9";
      inactive_border_color = "#2a0944";
      inactive_text_alpha = "0.85";
      hide_window_decorations = true;

      # --- tab bar ---
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      tab_bar_background = "none";
      tab_bar_margin_color = "none";

      # --- background / transparency (needs a compositor; WSLg provides one) ---
      background_opacity = "0.85";
      transparent_background_colors = "red@0.5 #00ff00@0.3";
      dynamic_background_opacity = true;
      # Sideloaded from dotfiles (same pattern as nvim); not reproducible if that
      # path moves. Migrate into a flake input alongside the nvim config later.
      background_image = "/home/KangaZero/Documents/dotfiles-mac/kitty/cat-watching-the-star_pixelart_purple_animated.gif";
      background_image_layout = "scaled";
      background_tint = "0.85";

      # --- misc ---
      allow_remote_control = "yes";
      # notify_on_cmd_finish dropped: no notification daemon on WSL, so it no-ops.
    };
  };

  # kitty renders via OpenGL, but WSL has no GPU DRM node (/dev/dri absent) so
  # Mesa cannot get a hardware GL context (the libEGL/ZINK/dri2 errors). Force
  # software rendering (llvmpipe). This must be in the *launching* environment —
  # programs.kitty.settings.env only affects processes spawned inside kitty, not
  # kitty's own GL init. Session-wide, but harmless on WSL where hardware GL is
  # unavailable anyway.
  home.sessionVariables.LIBGL_ALWAYS_SOFTWARE = "1";
}
