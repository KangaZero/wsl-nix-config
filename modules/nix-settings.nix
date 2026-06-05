{ lib, pkgs, ... }:

{
  nix.package = lib.mkForce pkgs.nix;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    allow-dirty-locks = false;
  };
}
