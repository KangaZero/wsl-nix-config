{ config, pkgs, ... }:

{
 home.username = "root";
 home.homeDirectory = "/root";
 home.stateVersion = "26.05";

 home.packages = with pkgs; [
   git
   zellij
   fzf
   zoxide
   ripgrep
   bat
   eza
   curl
   wget
 ];

 programs.zsh = { 
   enable = true;
   enableCompletion = true;
   autosuggestion.enable = true;

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
}
