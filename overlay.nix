{ src, supportedSystems }:

final: prev: rec {
  lbm = prev.callPackage ./pkgs/lbm { inherit src; inherit supportedSystems; };
  lbm64 = lbm.override {
    build32 = false;
  };
}