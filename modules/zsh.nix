{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#ac62de,bg=#134d4d,bold,underline";
    };
    syntaxHighlighting.enable = true;

    sessionVariables = {
      CATPPUCCIN_FLAVOR = "mocha"; # Options: mocha, frappe, macchiato, latte
      CATPPUCCIN_SHOW_TIME = "true";
      CATPPUCCIN_SHOW_HOSTNAME = "always"; # Options: never, always, ssh
    };
    initContent = ''
      	    nix-gc() {
      		    nix-collect-garbage --delete-older-than "$1" && nix store gc; 
      		    }
      kill-port() {
        local port="$1"
        [ -z "$port" ] && { echo "usage: kill-port <port>" >&2; return 1; }
        local lpids
        lpids=$(ss -ltnp "sport = :$port" 2>/dev/null | grep -oP 'pid=\K[0-9]+' | sort -u)
        [ -z "$lpids" ] && { echo "kill-port: nothing listening on :$port" >&2; return 1; }
        local targets="" pid ppid
        for pid in $lpids; do
          targets="$targets $pid"
          ppid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
          [ -n "$ppid" ] && [ "$ppid" -gt 1 ] && [ "$ppid" != "$$" ] && targets="$targets $ppid"
        done
        targets=$(echo "$targets" | tr ' ' '\n' | grep -v '^$' | sort -u)
        echo "kill-port: killing $(echo $targets | tr '\n' ' ')on :$port" >&2
        echo "$targets" | xargs -r kill -9
      }
    '';
    shellAliases = {
      # INFO: Unrelated but use "ss -tlnp" along with an optional pipe to ripgrep to list running port
      # To kill a port and its parents
      # ss -ltnp 'sport = :8000' | grep -oP 'pid=\K[0-9]+' | sort -u | xargs -r kill -9
      edit-nix = "z /etc/nixos && sudoedit flake.nix";
      home-switch = "home-manager switch --flake /etc/nixos#KangaZero";
      nix-switch = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      # Start niri Wayland session (sets up DBus, activates graphical-session.target, then runs niri).
      # WSLg provides WAYLAND_DISPLAY=wayland-0; niri runs nested under the WSLg compositor.
      niri-session = "niri-session";
      # Launch Firefox detached from the shell (survives terminal close, no output spam)
      ff = "setsid firefox-devedition >/dev/null 2>&1 < /dev/null &";
      # Show an in-progress/stuck activation (transient unit + related procs)
      nixRebuildStatus = "systemctl --no-pager status nixos-rebuild-switch-to-configuration.service 2>/dev/null; pgrep -af 'nixos-rebuild|switch-to-configuration' || echo 'no rebuild running'";
      # Abort a stuck activation: stop the transient unit and free its name
      nixRebuildKill = "sudo systemctl stop nixos-rebuild-switch-to-configuration.service 2>/dev/null; sudo systemctl reset-failed nixos-rebuild-switch-to-configuration.service 2>/dev/null; echo 'cleared stale activation unit'";
      weston = "weston --fullscreen -- niri";
      ez = "eza -laF --icons=always --group-directories-first --git-repos-no-status --octal-permissions --modified --numeric";
      cheatsheet-az = ''
        cat <<'EOF' | bat --language=md --style=plain
        # Azure DevOps CLI cheatsheet

        ## One-time setup
        az devops configure --defaults \
          organization=https://dev.azure.com/<org> \
          project=<project>

        ## PR — create
        az repos pr create \
          --repository <repo> \
          --source-branch <branch> \
          --target-branch main \
          --title "feat: my change" \
          --description "## Summary"

        ## PR — list active
        az repos pr list --repository <repo> --status active

        ## PR — show
        az repos pr show --id <id>

        ## PR — abandon
        az repos pr update --id <id> --status abandoned

        ## PR — approve
        az repos pr set-vote --id <id> --vote approve

        ## PR — reactivate
        az repos pr update --id <id> --status active

        ## Comments (REST only — az repos pr has no threads command)
        TOKEN=$(az account get-access-token \
          --resource 499b84ac-1321-427f-aa17-267ca6975798 \
          --query accessToken -o tsv)

        ## Git push via az token (no PAT needed)
        TOKEN=$(az account get-access-token \
          --resource 499b84ac-1321-427f-aa17-267ca6975798 \
          --query accessToken -o tsv)
        git -c http.extraHeader="Authorization: Bearer $TOKEN" push origin <branch>
        EOF'';
    };

    oh-my-zsh = {
      enable = true;
      theme = "catppuccin";
      plugins = [
        "git"
        "fzf"
        "colorize"
        "z"
        "history"
      ];
      custom = "${pkgs.fetchFromGitHub {
        owner = "JannoTjarks";
        repo = "catppuccin-zsh";
        rev = "main";
        sha256 = "sha256-w6uw8q54kQV2lwVSK3JjQ93slPt0OCvQMeZClyEFdwY=";
      }}";
    };

    history = {
      size = 10000;
      ignoreAllDups = true;
      path = "$HOME/.cache/zsh/history";
    };
  };
}
