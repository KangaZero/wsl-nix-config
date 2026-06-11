{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;

    # Steam's bwrap FHS sandbox chdir's into $PWD; if $PWD isn't inside the
    # sandbox (e.g. /etc/nixos) bwrap fails and Steam dies instantly with no
    # window. Force-launch from $HOME so CWD is always valid.
    package = pkgs.steam.override {
      extraProfile = ''cd "$HOME"'';
    };
  };
}
