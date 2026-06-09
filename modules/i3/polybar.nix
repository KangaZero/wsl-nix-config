{ pkgs, ... }:
let
  # Catppuccin Mocha (same hexes as the i3 theme)
  base = "#1e1e2e";
  surface0 = "#313244";
  surface1 = "#45475a";
  text = "#cdd6f4";
  blue = "#89b4fa";
  lavender = "#b4befe";
  mauve = "#cba6f7";
  green = "#a6e3a1";
  peach = "#fab387";
  red = "#f38ba8";
  yellow = "#f9e2af";
  teal = "#94e2d5";

  # Polybar must be built with i3 support for the internal/i3 module.
  polybar = pkgs.polybar.override {
    i3Support = true;
    pulseSupport = false;
    alsaSupport = false;
    githubSupport = false;
    mpdSupport = false;
  };

  # Launcher: kill any running instance, then start the `main` bar.
  polybar-start = pkgs.writeShellScriptBin "polybar-start" ''
    ${polybar}/bin/polybar-msg cmd quit >/dev/null 2>&1 || true
    ${polybar}/bin/polybar main &
  '';
in
{
  home.packages = [
    polybar
    polybar-start
  ];

  # Rounded floating "islands": each module is a pill — body via label-background,
  # rounded caps via half-circle glyphs () in font-1, colored as the pill bg
  # on the transparent bar. pseudo-transparency shows the wallpaper in the gaps.
  xdg.configFile."polybar/config.ini".text = ''
    [bar/main]
    width = 100%:-16
    height = 40
    offset-x = 8
    offset-y = 6
    fixed-center = true
    background = #00000000
    foreground = ${text}
    line-size = 0
    padding = 0
    module-margin = 1
    separator =
    pseudo-transparency = true
    enable-ipc = true
    wm-restack = i3
    cursor-click = pointer

    font-0 = JetBrainsMono Nerd Font:size=11;3
    font-1 = JetBrainsMono Nerd Font:size=20;6

    modules-left = i3 xwindow
    modules-center = date
    modules-right = cpu memory fs eth

    [module/i3]
    type = internal/i3
    pin-workspaces = true
    show-urgent = true
    index-sort = true
    enable-click = true
    enable-scroll = true
    wrapping-scroll = false
    format = <label-state>
    format-prefix = "%{T2}%{T-}"
    format-prefix-foreground = ${surface0}
    format-suffix = "%{T2}%{T-}"
    format-suffix-foreground = ${surface0}
    label-focused = %name%
    label-focused-background = ${mauve}
    label-focused-foreground = ${base}
    label-focused-padding = 1
    label-unfocused = %name%
    label-unfocused-background = ${surface0}
    label-unfocused-foreground = ${text}
    label-unfocused-padding = 1
    label-visible = %name%
    label-visible-background = ${surface1}
    label-visible-foreground = ${text}
    label-visible-padding = 1
    label-urgent = %name%
    label-urgent-background = ${red}
    label-urgent-foreground = ${base}
    label-urgent-padding = 1

    [module/cpu]
    type = internal/cpu
    interval = 2
    format = <label>
    format-prefix = "%{T2}%{T-}"
    format-prefix-foreground = ${surface0}
    format-suffix = "%{T2}%{T-}"
    format-suffix-foreground = ${surface0}
    label = "%{F${blue}} %{F-} %percentage:2%% "
    label-background = ${surface0}
    label-foreground = ${text}

    [module/memory]
    type = internal/memory
    interval = 2
    format = <label>
    format-prefix = "%{T2}%{T-}"
    format-prefix-foreground = ${surface0}
    format-suffix = "%{T2}%{T-}"
    format-suffix-foreground = ${surface0}
    label = "%{F${green}} %{F-} %gb_used%  %percentage_used%% "
    label-background = ${surface0}
    label-foreground = ${text}

    [module/eth]
    type = internal/network
    interface = eth0
    interval = 3
    format-connected = <label-connected>
    format-connected-prefix = "%{T2}%{T-}"
    format-connected-prefix-foreground = ${surface0}
    format-connected-suffix = "%{T2}%{T-}"
    format-connected-suffix-foreground = ${surface0}
    label-connected = "%{F${lavender}} %{F-} %local_ip%  ↓ %downspeed:8% "
    label-connected-background = ${surface0}
    label-connected-foreground = ${text}
    format-disconnected = <label-disconnected>
    format-disconnected-prefix = "%{T2}%{T-}"
    format-disconnected-prefix-foreground = ${surface0}
    format-disconnected-suffix = "%{T2}%{T-}"
    format-disconnected-suffix-foreground = ${surface0}
    label-disconnected = "%{F${red}} %{F-} down "
    label-disconnected-background = ${surface0}
    label-disconnected-foreground = ${text}

    [module/date]
    type = internal/date
    interval = 5
    date = %Y-%m-%d
    time = %H:%M
    format = <label>
    format-prefix = "%{T2}%{T-}"
    format-prefix-foreground = ${surface0}
    format-suffix = "%{T2}%{T-}"
    format-suffix-foreground = ${surface0}
    label = "%{F${peach}} %{F-} %date%  %{F${peach}} %{F-} %time% "
    label-background = ${surface0}
    label-foreground = ${text}

    [module/xwindow]
    type = internal/xwindow
    format = <label>
    format-prefix = "%{T2}%{T-}"
    format-prefix-foreground = ${surface0}
    format-suffix = "%{T2}%{T-}"
    format-suffix-foreground = ${surface0}
    label = "%{F${teal}} %{F-} %title:0:45:…% "
    label-foreground = ${text}
    label-background = ${surface0}
    label-empty = "%{F${teal}} %{F-} desktop "
    label-empty-foreground = ${text}
    label-empty-background = ${surface0}

    [module/fs]
    type = internal/fs
    mount-0 = /
    interval = 30
    format-mounted = <label-mounted>
    format-mounted-prefix = "%{T2}%{T-}"
    format-mounted-prefix-foreground = ${surface0}
    format-mounted-suffix = "%{T2}%{T-}"
    format-mounted-suffix-foreground = ${surface0}
    label-mounted = "%{F${yellow}} %{F-} %percentage_used%% "
    label-mounted-background = ${surface0}
    label-mounted-foreground = ${text}
  '';
}
