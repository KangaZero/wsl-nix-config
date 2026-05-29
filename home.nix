{ config, pkgs, ... };

{
 home.username = "root";
 home.homeDirectory = "/home/root";
 home.stateVersion = "26.05";

 home.packages = with pkgs: [
   neovim
   git
   zellij
   fzf
   zoxide
   ripgrep
   bat
   exa
   curl
   wget
 ];

 programs.zsh = { 
   enable = true;
   defaultEditor = "nvim";

   oh-my-zsh = {
    enable = true;
    plugins = [
"git"
"fzf"
"colorize"
"z"
"history"
    ];
   };

  history = {
   size = 10000;
   path = "$HOME/.cache/zsh/history";
  };

 };

 programs.neovim = {
 enable = true;
 };

 programs.home-manager.enable = true;
};
