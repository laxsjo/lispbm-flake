{ src }:

final: prev: rec {
  lbm = prev.callPackage ./pkgs/lbm { inherit src; };
  lbm64 = lbm.override {
    build32 = false;
  };
}