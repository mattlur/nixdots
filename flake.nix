{
  description = "nixdoots";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

   ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
    };

   niri = {
     url = "github:sodiboo/niri-flake";
     inputs.nixpkgs.follows = "nixpkgs";
   };
  };

  outputs = { nixpkgs, ghostty, niri, home-manager, ... }@inputs: 
    let
      system = "86_64-linux";
    in {
    nixpkgs.overlays = [ niri.overlays.niri ];
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem 
    {
      inherit system; 
      specialArgs = { inherit inputs; };
      modules = [ 
        ./configuration.nix 
        home-manager.nixosModules.home-manager 
	{
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ishan = { 
	    imports = [ 
	      ./modules/home.nix 
	      niri.homeModules.niri
	    ]; 
	  }; 
        }
      ];
    };
  };
}