{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rofi # app launcher (Alt+d)
  ];

  xdg.configFile."rofi/config.rasi".text = ''
    configuration {
        modi: "drun,run";
        show-icons: true;
        drun-display-format: "{name}";
    }

    * {
        font: "JetBrainsMono Nerd Font 12";

        base:     #1e1e2e;
        surface0: #313244;
        text:     #cdd6f4;
        subtext0: #a6adc8;
        mauve:    #cba6f7;

        background-color: transparent;
        text-color: @text;
    }

    window {
        background-color: @base;
        border: 2px;
        border-color: @mauve;
        border-radius: 10px;
        width: 600px;
        padding: 0;
    }

    mainbox {
        padding: 12px;
        children: [ inputbar, listview ];
    }

    inputbar {
        background-color: @surface0;
        border-radius: 8px;
        padding: 10px 12px;
        spacing: 10px;
        children: [ prompt, entry ];
    }

    prompt {
        text-color: @mauve;
    }

    entry {
        placeholder: "Search...";
        placeholder-color: @subtext0;
    }

    listview {
        margin: 12px 0 0 0;
        lines: 8;
        scrollbar: false;
    }

    element {
        padding: 8px 10px;
        border-radius: 8px;
        spacing: 10px;
    }

    element selected {
        background-color: @mauve;
        text-color: @base;
    }

    element-icon {
        size: 1.2em;
        vertical-align: 0.5;
    }

    element-text {
        vertical-align: 0.5;
    }
  '';
}
