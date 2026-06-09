{ pkgs, ... }:
let
  # Wallpaper pinned from dharmx/walls (reproducible, no blob in repo).
  # Refresh hash: nix store prefetch-file --json <url>
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/dharmx/walls/main/outrun/a_street_with_buildings_and_signs.png";
    hash = "sha256-J3hVCXKFxIJPftHrvxMZ3fG6lwA2SjOLaHD96BxExUs=";
  };
in
{
  imports = [
    ./rofi.nix
    ./dunst.nix
    ./polybar.nix
  ];

  home.packages = with pkgs; [
    feh # wallpaper
  ];

  # --- i3 ---
  xdg.configFile."i3/config".text = ''
    # Managed by Nix (modules/i3.nix). Docs: https://i3wm.org/docs/userguide.html
    set $mod Mod1
    # Mod1 = Alt. Super/Win is eaten by Windows over RDP.

    font pango:JetBrainsMono Nerd Font 10

    # --- Catppuccin Mocha palette ---
    set $rosewater #f5e0dc
    set $mauve     #cba6f7
    set $red       #f38ba8
    set $peach     #fab387
    set $green     #a6e3a1
    set $blue      #89b4fa
    set $lavender  #b4befe
    set $text      #cdd6f4
    set $overlay0  #6c7086
    set $surface0  #313244
    set $base      #1e1e2e
    set $crust     #11111b

    # window borders: class            border    bg        text   indicator  child_border
    client.focused                     $lavender $base     $text  $rosewater $lavender
    client.focused_inactive            $overlay0 $base     $text  $rosewater $overlay0
    client.unfocused                   $overlay0 $base     $text  $rosewater $overlay0
    client.urgent                      $peach    $base     $peach $overlay0  $peach
    client.placeholder                 $overlay0 $base     $text  $overlay0  $overlay0
    client.background                  $base

    # --- rice: gaps + clean borders ---
    gaps inner 8
    gaps outer 4
    smart_gaps on
    default_border pixel 2
    smart_borders on
    hide_edge_borders smart

    # --- autostart ---
    exec --no-startup-id ${pkgs.feh}/bin/feh --bg-fill ${wallpaper}
    exec --no-startup-id ${pkgs.dunst}/bin/dunst
    exec --no-startup-id greenclip daemon
    exec_always --no-startup-id polybar-start

    # --- launch ---
    bindsym $mod+Return exec ${pkgs.kitty}/bin/kitty
    bindsym $mod+d exec rofi -show drun
    bindsym $mod+Tab exec rofi -show window
    bindsym $mod+Shift+d exec rofi -show combi
    bindsym $mod+c exec rofi -show calc -modi calc -no-show-match -no-sort
    bindsym $mod+Shift+v exec rofi -modi "clipboard:greenclip print" -show clipboard -theme ~/.config/rofi/applet.rasi -theme-str 'listview { lines: 10; } window { width: 700px; }'
    bindsym $mod+Shift+slash exec rofi-cheatsheet
    bindsym $mod+Shift+q kill

    # --- focus (vim keys + arrows) ---
    bindsym $mod+h focus left
    bindsym $mod+j focus down
    bindsym $mod+k focus up
    bindsym $mod+l focus right
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right

    # --- move ---
    bindsym $mod+Shift+h move left
    bindsym $mod+Shift+j move down
    bindsym $mod+Shift+k move up
    bindsym $mod+Shift+l move right

    # --- layout ---
    bindsym $mod+b split h
    bindsym $mod+v split v
    bindsym $mod+f fullscreen toggle
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split
    bindsym $mod+space floating toggle

    # --- workspaces ---
    bindsym $mod+1 workspace number 1
    bindsym $mod+2 workspace number 2
    bindsym $mod+3 workspace number 3
    bindsym $mod+4 workspace number 4
    bindsym $mod+5 workspace number 5
    bindsym $mod+6 workspace number 6
    bindsym $mod+7 workspace number 7
    bindsym $mod+8 workspace number 8
    bindsym $mod+9 workspace number 9
    bindsym $mod+Shift+1 move container to workspace number 1
    bindsym $mod+Shift+2 move container to workspace number 2
    bindsym $mod+Shift+3 move container to workspace number 3
    bindsym $mod+Shift+4 move container to workspace number 4
    bindsym $mod+Shift+5 move container to workspace number 5

    # --- session ---
    bindsym $mod+Shift+c reload
    bindsym $mod+Shift+r restart
    bindsym $mod+Shift+e exec rofi-powermenu

    # --- resize mode ---
    bindsym $mod+r mode "resize"
    mode "resize" {
        bindsym h resize shrink width 10 px or 10 ppt
        bindsym j resize grow height 10 px or 10 ppt
        bindsym k resize shrink height 10 px or 10 ppt
        bindsym l resize grow width 10 px or 10 ppt
        bindsym Return mode "default"
        bindsym Escape mode "default"
    }

    # --- status bar: polybar (see ./polybar.nix), launched via exec_always above.
    #     No i3 bar {} block — polybar replaces i3bar entirely. ---
  '';
}
