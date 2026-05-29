{
description = "Arch Home Manager";

inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};

 outputs = { self, nixpkgs, home-manager }:
 let 
    system = "x86_64-linux";
    username = "root";
    hostname = "KangaZero";
    in
    {
	homeConfigurations."${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
	pkgs = import nixpkgs { inherit system; };

	modules = [./home.nix];
	};
    };
}

