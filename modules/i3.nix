# i3 user config — keyboard-driven tiling. Mod = Alt, because the Super/Win
# key is grabbed by Windows over RDP and never reaches the session.
# Launch commands use absolute store paths so they resolve in the xrdp session.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rofi # app launcher (Alt+d)
    feh # wallpaper
  ];

  xdg.configFile."i3/config".text = ''
    # Managed by Nix (modules/i3.nix). Docs: https://i3wm.org/docs/userguide.html
    set $mod Mod1
    # Mod1 = Alt. Super/Win is eaten by Windows over RDP.

    font pango:JetBrainsMono Nerd Font 10

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

    # --- status bar ---
    bar {
        status_command ${pkgs.i3status}/bin/i3status
        position top
    }
  '';
}
