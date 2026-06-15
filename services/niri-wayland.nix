{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
  programs.xwayland.enable = true;

  environment.systemPackages = [ pkgs.xwayland-satellite ];
}
