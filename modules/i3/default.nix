{ pkgs, ... }:
{
  imports = [
    ./rofi.nix
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
    exec --no-startup-id ${pkgs.feh}/bin/feh --bg-solid "#1e1e2e"

    # --- launch ---
    bindsym $mod+Return exec ${pkgs.kitty}/bin/kitty
    bindsym $mod+d exec ${pkgs.rofi}/bin/rofi -show drun
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
    bindsym $mod+Shift+e exec ${pkgs.i3}/bin/i3-nagbar -t warning -m 'Exit i3?' -B 'Yes' '${pkgs.i3}/bin/i3-msg exit'

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

    # --- status bar (Catppuccin Mocha) ---
    bar {
        status_command ${pkgs.i3status}/bin/i3status
        position top
        font pango:JetBrainsMono Nerd Font 10
        colors {
            background $base
            statusline $text
            separator  $overlay0
            # class            border    bg        text
            focused_workspace  $lavender $lavender $crust
            active_workspace   $surface0 $surface0 $text
            inactive_workspace $base     $base     $text
            urgent_workspace   $peach    $peach    $crust
            binding_mode       $peach    $peach    $crust
        }
    }
  '';

  # --- i3status ---
  xdg.configFile."i3status/config".text = ''
    general {
        colors = true
        interval = 5
        color_good = "#a6e3a1"
        color_degraded = "#f9e2af"
        color_bad = "#f38ba8"
    }

    order += "cpu_usage"
    order += "memory"
    order += "tztime local"

    cpu_usage {
        format = "  %usage"
    }

    memory {
        format = "  %used"
        threshold_degraded = "1G"
        format_degraded = "MEMORY < %available"
    }

    tztime local {
        format = "  %Y-%m-%d   %H:%M"
    }
  '';
}
