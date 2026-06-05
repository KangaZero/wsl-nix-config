{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    sessionVariables = {
      CATPPUCCIN_FLAVOR = "mocha"; # Options: mocha, frappe, macchiato, latte
      CATPPUCCIN_SHOW_TIME = "true";
      CATPPUCCIN_SHOW_HOSTNAME = "always"; # Options: never, always, ssh
    };

    shellAliases = {
      editNix = "z /etc/nixos && sudo nvim flake.nix";
      nixRebuild = "(z ~/etc/nixos && sudo nixos-rebuild switch --flake .)";
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
