{ pkgs, lib, ... }:

{
  imports = [
    ./modules/packages.nix
    ./modules/bash.nix
    ./modules/zsh.nix
    ./modules/direnv.nix
    ./modules/neovim.nix
    ./modules/git.nix
    ./modules/kitty.nix
    ./modules/firefox.nix
    ./modules/i3/default.nix
  ];

  # INFO: see https://nlewo.github.io/nixos-manual-sphinx/development/assertions.xml.html
  config = lib.mkMerge [
    {
      home = {
        username = "KangaZero";
        homeDirectory = "/home/KangaZero";
        stateVersion = "26.11";

        keyboard = {
          layout = "us";
        };

        # WSL has no GPU DRM node (/dev/dri absent), so Mesa cannot get a
        # hardware GL context (libEGL/ZINK/dri2 errors). Force software
        # rendering (llvmpipe) session-wide for every GL app (kitty, steam,
        # etc). Harmless on WSL where hardware GL is unavailable anyway.
        sessionVariables.LIBGL_ALWAYS_SOFTWARE = "1";
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
