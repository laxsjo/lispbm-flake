# lispbm-flake
A Nix flake that wraps around the LispBM repl that allows you to run LBM on your
desktop computer. This flake easily allows you to override the
[LispBM source](https://github.com/svenssonjoel/lispBM/) git commit used when
building the package.

## Outputs

This flake outputs the two packages `lbm` and `lbm64` under
`packages.<system>.<package>`. These are for the 32 bit and 64 bit versions of
LBM respectively. It also outputs these packages in a overlay, so that you can
access them directly from `pkgs.*`. 

## Usage

After you've installed it you can start the repl in the terminal by running
`lbm` or `lbm64` for the 32 and 64 bit versions respectively.

You can try it directly from your shell by running the command:
```shell
nix run github:laxsjo/lispbm-flake
```
Or if you want the 64 bit version:
```shell
nix run github:laxsjo/lispbm-flake#lbm64
```

Here is a sample flake.nix NixOS configuration that installs the LispBM repl as
a system package.

```nix
# flake.nix
{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    lispbm-flake = {
      url = "github:laxsjo/lispbm-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, lispbm-flake, ... }: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        {
          nixpkgs.overlays = [ lispbm-flake.overlay.default ];
        }
        ./configuration.lisp
      ];
    };
  };
}
```

```nix
# configuration.lisp

{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.lbm
    pkgs.lbm64
  ];
}
```

If you prefer, you can also avoid using the overlay by simply directly
referring to the packages in this flake's outputs like so (assuming that
`lispbm-flake` refers to this flake in this code's scope):
```nix
{
  environment.systemPackages = [
    lispbm-flake.packages.${system}.lbm
  ];
}
```

There are two ways that override which version of LispBM is built. You can
either override this flake's `lispbm-src` input:

```nix
{  
  lispbm-flake = {
    url = "github:laxsjo/lispbm-flake";
    inputs.vesc-tool-src.url = "github:svenssonjoel/lispBM/71d6ef61e852e14db3b1cd19f0bb3c786a01ed64";
  };
}
```

Or you can override the `src` argument on this flake's package derivations:
```nix
{
  environment.systemPackages = [
    (pkgs.lbm.override {
      src = pkgs.fetchFromGithub {
        owner = "svenssonjoel";
        repo = "lispBM";
        rev = "c03fbee51d65cc24c6e284dfed3607ad4953ef93";
        sha256 = "sha256-Ffna/rSsi8EePGQo6RN3Zvmzm10rYHlIISlxy1jUIiI=";
      };
    })
  ];
}
```
**OK, it seems like overrides are mega broken but I can't be asked to work more**
**on this right now ._.**
