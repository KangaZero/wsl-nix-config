{

  description = "WSL - NixOS + Home-manager by KangaZero";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #TODO add in nvim config repo when ready
    # dotfiles-mac = {
    #
    #   url = "github:KangaZero/dotfiles-mac";
    #
    #   flake = false;
    #
    # };
    #
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      git-hooks,
      nixos-wsl,
    }:

    let

      system = "x86_64-linux";
      username = "KangaZero";
      # Commented as it is an unused declaration/variable
      # hostname = "KangaZero";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "claude-code" ];
        # config.allowUnfree = true;
      };

    in

    {

      checks.${system}.pre-commit-check = git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          nixfmt.enable = true;
          statix.enable = true;
          deadnix.enable = true;

          # Build the home-manager config so a broken module (rofi/dunst/polybar
          # rasi/ini, missing ';', shellcheck failures in writeShellApplication)
          # fails locally instead of slipping through. Runs only when *.nix
          # changes. Cached, so it's near-instant when nothing relevant moved.
          #
          # Scoped to the pre-push stage on purpose: this hook shells out to
          # `nix build`, which cannot run inside the `nix flake check` sandbox
          # (no `nix` binary / daemon there -> "Executable `nix` not found").
          # `pre-commit run --all-files`, which the flake check uses, only fires
          # pre-commit-stage hooks, so keeping this on pre-push lets CI's flake
          # check pass while still guarding pushes locally. CI builds the same
          # activationPackage directly in its own step (see .github/workflows).
          home-build = {
            enable = true;
            name = "home-manager activationPackage builds";
            entry = "nix build --no-link --print-build-logs .#homeConfigurations.${username}.activationPackage";
            language = "system";
            files = "\\.nix$";
            pass_filenames = false;
            stages = [ "pre-push" ];
          };
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        packages = [ pkgs.nixfmt-tree ];
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
      };

      formatter.${system} = pkgs.nixfmt-tree;

      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit (self) inputs;
        };
        modules = [
          nixos-wsl.nixosModules.wsl
          ./configuration.nix
          ./services/niri-wayland.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."${username}" = import ./home.nix;
            };
          }
        ];
      };

      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {

        inherit pkgs;

        modules = [

          {
            imports = [ ./home.nix ];
            #add in nvim repo when ready
            # _module.args.dotfiles-mac = dotfiles-mac;

          }

        ];

      };

    };

}
