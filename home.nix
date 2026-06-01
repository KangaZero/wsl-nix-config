{ config, pkgs, ... }:

{
 home.username = "root";
 home.homeDirectory = "/root";
 home.stateVersion = "26.05";

 home.packages = with pkgs; [
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
# Font
   nerd-fonts.jetbrains-mono
# Package managers
   nodejs_26
   pnpm
   rustup
   python3
   mise
   ffmpeg-full
 ];

 programs.home-manager.enable = true;
  programs.zsh = { 
   enable = true;
   enableCompletion = true;
   autosuggestion.enable = true;
   syntaxHighlighting.enable = true;

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
   ignoreAllDups = true;
   path = "$HOME/.cache/zsh/history";
  };

 };

programs.neovim = {
 enable = true;
 defaultEditor = true;
 #This is needed to use the default .config/nvim/init.lua way to configure nvim
 sideloadInitLua = true;
 };
# home.file.".config/nvim" = {
# source = "${dofiles-mac}/nvim-min";
#   recursive = true;
# };

}
