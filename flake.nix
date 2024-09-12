{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    lispbm-src = {
      url = "github:svenssonjoel/lispBM/master";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, lispbm-src }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };
  in {
    overlays.default = import ./overlay.nix { src = lispbm-src; };
    
    packages.${system} = with pkgs; {
      inherit lbm;
      inherit lbm64;
      default = lbm;
    };
    
    inherit inputs;
  };
}
