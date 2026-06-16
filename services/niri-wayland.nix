{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # XWayland for X11 app compatibility; xwayland-satellite is the bridge
  # niri uses to integrate XWayland windows into its Wayland session.
  programs.xwayland.enable = true;
  environment.systemPackages = [ pkgs.xwayland-satellite ];
}
