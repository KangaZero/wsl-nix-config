{ pkgs, ... }:
{
  home.packages = [ pkgs.mako ];

  systemd.user.services.mako = {
    Unit = {
      Description = "Mako notification daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecStart = "${pkgs.mako}/bin/mako";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  home.file.".config/mako/config".text = ''
    font=JetBrainsMono Nerd Font 10
    background-color=#2f354b
    text-color=#FDFDFD
    border-size=2
    border-color=#8897F4
    border-radius=10
    width=320
    height=300
    anchor=top-right
    margin=12
    padding=12
    max-icon-size=48
    icon-location=left
    max-history=20
    sort=-time

    [urgency=low]
    border-color=#8897F4
    default-timeout=5000

    [urgency=normal]
    border-color=#C574DD
    default-timeout=8000

    [urgency=critical]
    border-color=#F37F97
    default-timeout=0
  '';
}
