# Full i3 desktop over xrdp — keyboard-driven X11 tiling WM.
# mstsc (Windows Remote Desktop, port 3390) -> xrdp -> its own Xorg -> i3.
# i3 is X11-native, so none of the GL / Wayland-nesting issues niri had.
_: {
  services = {
    xserver.enable = true; # Xorg + xorgxrdp backend
    xserver.windowManager.i3.enable = true; # installs i3 (+ i3status, dmenu)

    xrdp = {
      enable = true;
      defaultWindowManager = "i3";
      # 3389 is Windows' OWN RDP port -> mstsc localhost:3389 hits Windows
      # (error 0x708, console-session clash). Use 3390 for WSL's xrdp.
      port = 3390;
      openFirewall = true; # TCP 3390
    };
  };
}
