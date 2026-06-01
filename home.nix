# { config, pkgs, ... }:
{ pkgs, ... }:

{
  home = {
    username = "root";
    homeDirectory = "/root";
    stateVersion = "26.05";

    packages = with pkgs; [
      git
      zellij
      fzf
      yazi
      zoxide
      ripgrep
      bat
      eza
      curl
      wget
      openssh
      tldr
      ffmpeg-full
      unzip
      # Font
      nerd-fonts.jetbrains-mono
      # Package managers
      nodejs_26
      pnpm
      rustup
      python3
      mise
      uv
      just
      # The forbidden fruit
      claude-code
    ];
  };

  programs = {
    home-manager.enable = true;

    # Safety net: if WSL/terminal launches bash, hop to zsh.
    # Pair with `chsh -s "$(command -v zsh)"` (see README) for $SHELL correctness.
    bash = {
      enable = true;
      initExtra = ''
        if [[ $- == *i* ]] && [[ -z "$ZSH_VERSION" ]] && command -v zsh >/dev/null; then
          exec zsh -l
        fi
      '';
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      sessionVariables = {
        CATPPUCCIN_FLAVOR = "mocha"; # Options: mocha, frappe, macchiato, latte
        CATPPUCCIN_SHOW_TIME = "true"; # Adds current time to the prompt
        CATPPUCCIN_SHOW_HOSTNAME = "always"; # Options: never, always, ssh
      };

      shellAliases = {
        editNix = "z ~/.config/home-manager && nvim flake.nix";
        nixRebuild = "(z ~/.config/home-manager && home-manager switch)";
      };

      oh-my-zsh = {
        enable = true;
        theme = "catppuccin";
        plugins = [
          "git"
          "fzf"
          "colorize"
          "z"
          "history"
        ];
        custom = "${pkgs.fetchFromGitHub {
          owner = "JannoTjarks";
          repo = "catppuccin-zsh";
          rev = "main";
          sha256 = "sha256-w6uw8q54kQV2lwVSK3JjQ93slPt0OCvQMeZClyEFdwY=";
        }}";
      };
      history = {
        size = 10000;
        ignoreAllDups = true;
        path = "$HOME/.cache/zsh/history";
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      #This is needed to use the default .config/nvim/init.lua way to configure nvim
      sideloadInitLua = true;
    };
  };
  # home.file.".config/nvim" = {
  # source = "${dofiles-mac}/nvim-min";
  #   recursive = true;
  # };

}
