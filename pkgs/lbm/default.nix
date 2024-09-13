{ src
, build32 ? true
, supportedSystems
, multiStdenv
, lib
, pkgs
, pkgsi686Linux
}:

let
  makeTarget = if build32 then "all" else "all64";
  name = if build32 then "lbm" else "lbm64";
  platformPkgs = if build32 then pkgsi686Linux else pkgs;
in multiStdenv.mkDerivation {
  pname = name;
  # IDK what pattern should be used to get ahold of the version number...
  version = src.rev or "unknown";
  
  meta = with lib; {
    description = "LispBM repl";
    platforms = supportedSystems;
  };
  
  inherit src;
  
  buildPhase = ''
    cd repl
    
    make ${makeTarget}
  '';
  installPhase = ''
    mkdir -p $out/bin
    
    cp repl $out/bin/${name}
  '';
  
  buildInputs = with platformPkgs; [
    readline
    libpng
  ];
  
  nativeBuildInputs = with pkgs; [
    gcc_multi
  ];
}