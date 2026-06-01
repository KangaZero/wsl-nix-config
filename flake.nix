
{

  description = "WSL - Arch + Nix Flake by KangaZero";



  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {

      url = "github:nix-community/home-manager";

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
  outputs = { self, nixpkgs, home-manager}:

    let

      system = "x86_64-linux";

      username = "root";

      hostname = "KangaZero";

    in

    {

      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {

        pkgs = import nixpkgs { inherit system; };

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

