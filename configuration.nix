# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  lib,
  pkgs,
  ...
}:

{
  wsl.enable = true;
  wsl.defaultUser = "KangaZero";

  users.users.KangaZero = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    allow-dirty-locks = false;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-generations +30";
  };

  # Make `sudo nvim` (root) use KangaZero's neovim config.
  # nvim reads $HOME/.config/nvim; root's HOME is /root, so point it at the
  # same dotfiles the user's HM symlink uses. Runs on every activation.
  system.activationScripts.rootNvimConfig = ''
    mkdir -p /root/.config
    ln -sfn /home/KangaZero/Documents/dotfiles-mac/nvim-min /root/.config/nvim
  '';

  # Default editor for all users (root included)
  environment.variables.EDITOR = "nvim";

  environment.systemPackages = [
    pkgs.git
    pkgs.vim
    pkgs.neovim
  ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.11"; # Did you read the comment?
}
