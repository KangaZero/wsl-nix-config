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
    height = 40;
    # No full-width background — pills handle their own bg via CSS

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
    "niri/workspaces" = {
      format = "{icon}";
      format-icons = {
        active = ""; # nf-md-circle
        focused = ""; # nf-md-circle_outline (focused but not active)
        default = ""; # nf-md-circle_small
      };
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
      font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free", "Material Design Icons", sans-serif;
      font-size: 13px;
      min-height: 0;
      border: none;
      border-radius: 0;
    }

    /* Transparent bar window so only pills are visible */
    window#waybar {
      background-color: transparent;
      color: ${colors.fg};
    }

    /* Each top-level module box becomes a pill segment */
    .modules-left > widget,
    .modules-center > widget,
    .modules-right > widget {
      background-color: ${colors.bg};
      border-radius: 6px;
      margin: 4px 2px;
      padding: 0 12px;
    }

    /* --- niri/workspaces ------------------------------------------------- */
    #workspaces {
      padding: 0 6px;
    }

    #workspaces button {
      background-color: transparent;
      color: ${colors.fg};
      padding: 0 4px;
      border-radius: 4px;
      min-width: 18px;
    }

    #workspaces button:hover {
      background-color: ${colors.surface};
    }

    #workspaces button.active {
      color: ${colors.blue};
    }

    #workspaces button.focused {
      color: ${colors.cyan};
    }

    #workspaces button.urgent {
      color: ${colors.pink};
    }

    /* --- niri/window ----------------------------------------------------- */
    #window {
      color: ${colors.fg};
      font-style: italic;
    }

    /* --- clock ----------------------------------------------------------- */
    #clock {
      color: ${colors.green};
      font-weight: bold;
    }

    /* --- cpu ------------------------------------------------------------- */
    #cpu {
      color: ${colors.cyan};
    }

    /* --- memory ---------------------------------------------------------- */
    #memory {
      color: ${colors.purple};
    }

    /* --- disk ------------------------------------------------------------ */
    #disk {
      color: ${colors.teal};
    }

    /* --- network --------------------------------------------------------- */
    #network {
      color: ${colors.blue};
    }

    #network.disconnected {
      color: ${colors.pink};
    }

    /* --- custom/language ------------------------------------------------- */
    #custom-language {
      color: ${colors.pink};
      font-weight: bold;
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
