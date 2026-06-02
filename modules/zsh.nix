{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    sessionVariables = {
      CATPPUCCIN_FLAVOR = "mocha"; # Options: mocha, frappe, macchiato, latte
      CATPPUCCIN_SHOW_TIME = "true";
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
}
