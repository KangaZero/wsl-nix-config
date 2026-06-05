{

  description = "WSL - Arch + Nix Flake by KangaZero";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      #NOTE: Currently at 26.11 for unstable creating a mismatch
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

  #add in nvim repo inputs when ready
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
          nixfmt-rfc-style.enable = true;
          statix.enable = true;
          deadnix.enable = true;
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
      };

      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixos-wsl.nixosModules.wsl
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = import ./home.nix;
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
