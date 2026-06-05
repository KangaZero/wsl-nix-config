{ pkgs, lib, ... }:

{
  imports = [
    ./modules/packages.nix
    ./modules/bash.nix
    ./modules/zsh.nix
    ./modules/direnv.nix
    ./modules/neovim.nix
    ./modules/nix-settings.nix
    ./modules/gc.nix
    ./modules/git.nix
  ];

  # INFO: see https://nlewo.github.io/nixos-manual-sphinx/development/assertions.xml.html
  config = lib.mkMerge [
    {
      home = {
        username = "KangaZero";
        homeDirectory = "/home/KangaZero";
        stateVersion = "26.11";
      };

      programs.home-manager.enable = true;
      # Won't do anything on WSL, but idk i just wanna pretend that I am using 100% linux
      fonts.fontconfig.enable = true;
    }

    (lib.mkIf (!pkgs.stdenv.hostPlatform.isx86_64 || !pkgs.stdenv.hostPlatform.isLinux) {
      assertions = [
        {
          assertion = false;
          message = "This config only supports x86_64-linux, got: ${pkgs.stdenv.hostPlatform.system}";
        }
      ];
    })
  ];
}
