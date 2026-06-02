{ pkgs, ... }:

{
  systemd.user.services.nix-gc = {
    Unit.Description = "Nix garbage collection";
    Service.ExecStart = pkgs.writeShellScript "nix-gc" ''
      ${pkgs.nix}/bin/nix-env --delete-generations +30 \
        --profile ~/.local/state/home-manager/profiles/home-manager
      ${pkgs.nix}/bin/nix-collect-garbage
    '';
  };

  # Verify activation: systemctl --user status nix-gc.timer
  systemd.user.timers.nix-gc = {
    Unit.Description = "Nix GC timer";
    Timer = {
      OnCalendar = "weekly";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
