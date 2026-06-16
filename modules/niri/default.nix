_:
let
  # Pamela palette — used in focus-ring and mako border (mako.nix mirrors these).
  colorFocusActive = "#8897F4";
  colorFocusInactive = "#2f354b";

  # Clipboard-history picker: lists cliphist entries in rofi, pipes selection
  # back through cliphist decode, then writes to the Wayland clipboard.
  # Single-line string — niri's spawn passes this verbatim to sh -c; newlines
  # inside KDL string args break niri's argument parser.
  cliphist-picker =
    "cliphist list"
    + " | rofi -dmenu"
    + " -theme ~/.config/rofi/applet.rasi"
    + " -theme-str 'listview { lines: 10; } window { width: 700px; }'"
    + " | cliphist decode"
    + " | wl-copy";
in
{
  imports = [
    ./rofi.nix
    ./noctalia.nix
  ];

  xdg.configFile."niri/config.kdl".text = ''
    // ─── Input ───────────────────────────────────────────────────────────────
    input {
        keyboard {
            xkb {
                layout "us,jp"
            }
        }

        touchpad {
            tap
            natural-scroll
        }
    }

    // ─── Layout ──────────────────────────────────────────────────────────────
    layout {
        gaps 8

        focus-ring {
            width 2
            active-color "${colorFocusActive}"
            inactive-color "${colorFocusInactive}"
        }
    }

    // Instruct clients to omit their server-side decoration chrome (titlebars,
    // borders). Niri draws focus rings itself; CSD wastes vertical space.
    prefer-no-csd

    // ─── Autostart ───────────────────────────────────────────────────────────
    // Launched via `weston --fullscreen -- niri` (not niri-session), so
    // graphical-session.target never fires. Spawn services directly.
    spawn-at-startup "noctalia-shell"

    // ─── Keybinds ────────────────────────────────────────────────────────────
    // Mod = Alt.  Super is captured by Windows/WSLg window chrome.
    binds {
        // ── Launchers ──────────────────────────────────────────────────────
        Alt+Return { spawn "kitty"; }
        Alt+D      { spawn "rofi" "-show" "drun"; }
        Alt+Tab    { spawn "rofi" "-show" "window"; }
        Alt+Shift+D { spawn "rofi" "-show" "combi"; }
        Alt+C      { spawn "rofi" "-show" "calc" "-no-show-match" "-no-sort"; }
        Alt+Shift+V { spawn "sh" "-c" "${cliphist-picker}"; }
        Alt+Shift+Slash { spawn "rofi-cheatsheet"; }
        Alt+Shift+E     { spawn "rofi-powermenu"; }

        // ── Window management ──────────────────────────────────────────────
        Alt+Shift+Q repeat=false { close-window; }
        Alt+F               { fullscreen-window; }
        Alt+Shift+F         { maximize-column; }
        Alt+Space           { toggle-window-floating; }

        // ── Focus — vim keys ──────────────────────────────────────────────
        Alt+H { focus-column-left; }
        Alt+J { focus-window-down; }
        Alt+K { focus-window-up; }
        Alt+L { focus-column-right; }

        // ── Focus — arrow keys ────────────────────────────────────────────
        Alt+Left  { focus-column-left; }
        Alt+Down  { focus-window-down; }
        Alt+Up    { focus-window-up; }
        Alt+Right { focus-column-right; }

        // ── Move — vim keys ───────────────────────────────────────────────
        Alt+Shift+H { move-column-left; }
        Alt+Shift+J { move-window-down; }
        Alt+Shift+K { move-window-up; }
        Alt+Shift+L { move-column-right; }

        // ── Move — arrow keys ─────────────────────────────────────────────
        Alt+Shift+Left  { move-column-left; }
        Alt+Shift+Down  { move-window-down; }
        Alt+Shift+Up    { move-window-up; }
        Alt+Shift+Right { move-column-right; }

        // ── Workspaces ────────────────────────────────────────────────────
        Alt+1 { focus-workspace 1; }
        Alt+2 { focus-workspace 2; }
        Alt+3 { focus-workspace 3; }
        Alt+4 { focus-workspace 4; }
        Alt+5 { focus-workspace 5; }
        Alt+6 { focus-workspace 6; }
        Alt+7 { focus-workspace 7; }
        Alt+8 { focus-workspace 8; }
        Alt+9 { focus-workspace 9; }

        Alt+Shift+1 { move-column-to-workspace 1; }
        Alt+Shift+2 { move-column-to-workspace 2; }
        Alt+Shift+3 { move-column-to-workspace 3; }
        Alt+Shift+4 { move-column-to-workspace 4; }
        Alt+Shift+5 { move-column-to-workspace 5; }

        // ── Workspace scroll ──────────────────────────────────────────────
        Alt+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
        Alt+WheelScrollUp   cooldown-ms=150 { focus-workspace-up; }

        // ── Resize ────────────────────────────────────────────────────────
        Alt+R       { switch-preset-column-width; }
        Alt+Minus   { set-column-width "-10%"; }
        Alt+Equal   { set-column-width "+10%"; }
        Alt+Shift+Minus { set-window-height "-10%"; }
        Alt+Shift+Equal { set-window-height "+10%"; }

        // ── Keyboard layout toggle ─────────────────────────────────────────
        Alt+Ctrl+L { switch-layout "next"; }
    }
  '';
}
