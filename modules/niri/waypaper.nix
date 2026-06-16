{ pkgs, ... }:
let
  # Wallpaper pinned from dharmx/walls (reproducible, no blob in repo).
  # Refresh hash: nix store prefetch-file --json <url>
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/dharmx/walls/main/outrun/a_street_with_buildings_and_signs.png";
    hash = "sha256-J3hVCXKFxIJPftHrvxMZ3fG6lwA2SjOLaHD96BxExUs=";
  };

  # swww was renamed upstream to awww; nixpkgs#swww is a deprecated alias.
  # pkgs.awww ships binaries `awww` and `awww-daemon`.
  inherit (pkgs) awww;
in
{
  home = {
    packages = [
      pkgs.waypaper
      awww
    ];

    # Placed in ~/Wallpapers/ so waypaper discovers it from its configured folder.
    file = {
      "Wallpapers/a_street_with_buildings_and_signs.png".source = wallpaper;

      # Reference: https://github.com/anufrievroman/waypaper#configuration
      ".config/waypaper/config.ini".text = ''
        [Settings]
        language = en
        folder = ~/Wallpapers
        wallpaper = ~/Wallpapers/a_street_with_buildings_and_signs.png
        backend = awww
        monitors = All
        fill = fill
        sort = name
        color = #000000
        subfolders = False
        show_hidden = False
        show_keywords = False
        fills_per_monitor = False
        number_of_columns = 3
        post_command =
      '';
    };
  };

  # awww-daemon must be running before waypaper sets a wallpaper.
  # graphical-session.target guarantees the Wayland compositor is up first.
  systemd.user.services.awww-daemon = {
    Unit = {
      Description = "awww wallpaper daemon (Wayland)";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${awww}/bin/awww-daemon";
      Restart = "on-failure";
      RestartSec = "3s";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
