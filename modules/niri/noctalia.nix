{ pkgs, ... }:
{
  home.packages = [ pkgs.noctalia-shell ];

  home.file.".config/noctalia/config.toml".text = ''
    [compositor]
    type = "niri"

    [bar]
    enabled = true

    [notifications]
    enabled = true

    [wallpaper]
    enabled = true
    folder = "~/Wallpapers"

    [clipboard]
    enabled = true
  '';

  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia desktop shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.noctalia-shell}/bin/noctalia-shell";
      Restart = "on-failure";
      RestartSec = "3s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
