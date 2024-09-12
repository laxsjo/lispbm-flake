{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    lispbm-src = {
      url = "github:svenssonjoel/lispBM/master";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, lispbm-src }: let
    supportedSystems = with flake-utils.lib.system; [
      x86_64-linux
      x86_64-darwin
    ];
  in {
    overlays.default = import ./overlay.nix { src = lispbm-src; inherit supportedSystems; };
  } // flake-utils.lib.eachSystem supportedSystems (system: let
    pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };
  in {
    packages = with pkgs; {
      inherit lbm;
      inherit lbm64;
      default = lbm;
    };
  });
}
