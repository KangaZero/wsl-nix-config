{ pkgs, lib, ... }:

{
  # INFO: see https://nlewo.github.io/nixos-manual-sphinx/development/assertions.xml.html
  config = lib.mkIf (!pkgs.stdenv.hostPlatform.isx86_64 || !pkgs.stdenv.hostPlatform.isLinux) {
    assertions = [
      {
        assertion = false;
        message = "This config only supports x86_64-linux, got: ${pkgs.stdenv.hostPlatform.system}";
      }
    ];
  };

  imports = [
    ./modules/packages.nix
    ./modules/bash.nix
    ./modules/zsh.nix
    ./modules/neovim.nix
    ./modules/nix-settings.nix
    ./modules/gc.nix
    ./modules/git.nix
  ];

  home = {
    username = "root";
    homeDirectory = "/root";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
