{ pkgs, lib, ... }:

let
  # ---------------------------------------------------------------------------
  # Pamela palette
  # ---------------------------------------------------------------------------
  colors = {
    bg = "#2f354b";
    fg = "#FDFDFD";
    blue = "#8897F4";
    cyan = "#79E6F3";
    green = "#5ADECD";
    pink = "#F37F97";
    purple = "#C574DD";
    teal = "#00B19F";
    surface = "#3d4563";
  };

  # ---------------------------------------------------------------------------
  # Shell helper: emit current niri keyboard layout as "US" / "JP" / fallback
  #
  # niri msg --json keyboard-layouts returns:
  #   { "KeyboardLayouts": { "keyboard_layouts": { "names": [...], "current_idx": N } } }
  # Source: https://github.com/YaLTeR/niri/blob/main/niri-ipc/src/lib.rs
  # ---------------------------------------------------------------------------
  niriKeyboardLayout = pkgs.writeShellApplication {
    name = "niri-keyboard-layout";
    runtimeInputs = [
      pkgs.niri
      pkgs.jq
    ];
    text = ''
      raw=$(niri msg --json keyboard-layouts 2>/dev/null) || raw=""

      if [ -z "$raw" ]; then
        echo "US"
        exit 0
      fi

      name=$(printf '%s' "$raw" \
        | jq -r '.KeyboardLayouts.names[.KeyboardLayouts.current_idx]' \
        2>/dev/null) || name=""

      if [ -z "$name" ] || [ "$name" = "null" ]; then
        echo "US"
        exit 0
      fi

      # Normalise to 2-char uppercase; case-fold first to avoid duplicate patterns.
      name_lower=$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]')
      case "$name_lower" in
        *jp*|*ja*) echo "JP" ;;
        *us*|*en*|*am*) echo "US" ;;
        *) printf '%s' "$name" | cut -c1-2 | tr '[:lower:]' '[:upper:]' ;;
      esac
    '';
  };

  # ---------------------------------------------------------------------------
  # Waybar JSON settings (single bar)
  # ---------------------------------------------------------------------------
  barSettings = {
    layer = "top";
    position = "top";
    height = 36;
    spacing = 6;
    # Float bar away from screen edge
    margin-top = 6;
    margin-left = 10;
    margin-right = 10;

    modules-left = [
      "niri/workspaces"
      "niri/window"
    ];
    modules-center = [ "clock" ];
    modules-right = [
      "cpu"
      "memory"
      "disk"
      "network"
      "custom/language"
    ];

    # --- niri/workspaces ---------------------------------------------------
    # format = "{id}" shows workspace numbers; CSS classes (active/focused/urgent)
    # handle colour — no dependency on nerd font glyph rendering.
    "niri/workspaces" = {
      format = "{id}";
      all-outputs = false;
      hide-empty = false;
    };

    # --- niri/window -------------------------------------------------------
    "niri/window" = {
      format = "{title}";
      max-length = 60;
      rewrite = {
        "(.*) — Mozilla Firefox" = " $1";
        "(.*) - fish" = " $1";
        "(.*) - nvim" = " $1";
      };
    };

    # --- clock -------------------------------------------------------------
    clock = {
      format = " {:%H:%M}";
      format-alt = " {:%a %d %b %Y}";
      tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
    };

    # --- cpu ---------------------------------------------------------------
    cpu = {
      format = " {usage}%";
      interval = 5;
      tooltip = false;
    };

    # --- memory ------------------------------------------------------------
    memory = {
      format = " {percentage}%";
      interval = 10;
      tooltip-format = "{used:0.1f}G / {total:0.1f}G";
    };

    # --- disk --------------------------------------------------------------
    disk = {
      format = " {percentage_used}%";
      path = "/";
      interval = 30;
      tooltip-format = "{used} / {total}";
    };

    # --- network -----------------------------------------------------------
    network = {
      format-wifi = " {essid}";
      format-ethernet = " {ipaddr}";
      format-disconnected = "󰤭 ";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
      tooltip-format-wifi = "{signalStrength}% {frequency}GHz";
      interval = 10;
    };

    # --- custom/language ---------------------------------------------------
    "custom/language" = {
      exec = lib.getExe niriKeyboardLayout;
      interval = 2;
      format = "  {}";
      tooltip = false;
    };
  };

  # ---------------------------------------------------------------------------
  # CSS — segmented floating pills, transparent bar background
  # Each module group widget gets its own pill via child selector.
  # ---------------------------------------------------------------------------
  barStyle = ''
    * {
      font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free", sans-serif;
      font-size: 12px;
      min-height: 0;
      border: none;
      border-radius: 0;
    }

    /* Transparent bar — only the pill segments are visible */
    window#waybar {
      background-color: transparent;
      color: ${colors.fg};
    }

    /* ── Pill segments ─────────────────────────────────────────────────────
       Each direct child widget of the three module boxes gets its own pill.
       border-radius clips the pill shape; margin creates the gap between pills. */
    .modules-left > widget,
    .modules-center > widget,
    .modules-right > widget {
      background-color: ${colors.bg};
      border-radius: 8px;
      margin: 0 4px;
      padding: 0 14px;
    }

    /* ── Workspaces ──────────────────────────────────────────────────────── */
    #workspaces {
      padding: 0 4px;
    }

    #workspaces button {
      background-color: transparent;
      color: ${colors.fg};
      padding: 0 8px;
      border-radius: 6px;
      min-width: 24px;
      font-weight: bold;
    }

    #workspaces button:hover {
      background-color: ${colors.surface};
      color: ${colors.fg};
    }

    #workspaces button.active {
      background-color: ${colors.blue};
      color: ${colors.bg};
      border-radius: 6px;
    }

    #workspaces button.focused {
      color: ${colors.cyan};
    }

    #workspaces button.urgent {
      background-color: ${colors.pink};
      color: ${colors.bg};
    }

    /* ── Window title ────────────────────────────────────────────────────── */
    #window {
      color: ${colors.fg};
      font-style: italic;
    }

    /* ── Clock ───────────────────────────────────────────────────────────── */
    #clock {
      color: ${colors.green};
      font-weight: bold;
      letter-spacing: 1px;
    }

    /* ── System stats ────────────────────────────────────────────────────── */
    #cpu    { color: ${colors.cyan};   }
    #memory { color: ${colors.purple}; }
    #disk   { color: ${colors.teal};   }

    /* ── Network ─────────────────────────────────────────────────────────── */
    #network              { color: ${colors.blue}; }
    #network.disconnected { color: ${colors.pink}; }

    /* ── Keyboard layout ─────────────────────────────────────────────────── */
    #custom-language {
      color: ${colors.pink};
      font-weight: bold;
      letter-spacing: 1px;
    }
  '';

in
{
  home.packages = [
    pkgs.jq
    niriKeyboardLayout
  ];

  programs.waybar = {
    enable = true;
    settings = [ barSettings ];
    style = barStyle;
  };
}
