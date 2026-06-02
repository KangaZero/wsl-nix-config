{ ... }:

{
  imports = [
    ./modules/packages.nix
    ./modules/bash.nix
    ./modules/zsh.nix
    ./modules/neovim.nix
    ./modules/nix-settings.nix
    ./modules/gc.nix
  ];

  home = {
    username = "root";
    homeDirectory = "/root";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
