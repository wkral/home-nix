{ stdenv, fetchFromGitHub, librsvg, graphviz, plantuml }:
stdenv.mkDerivation rec {
  pname = "lua-filters";
  version = "2020-11-30";
  src = fetchFromGitHub {
    owner = "pandoc";
    repo = pname;
    rev = "v${version}";
    sha256 = "00yv65yia6cqq5f9hvagrp3d7193h1rrkm2s8nhf891faad6aq0x";
  };
  buildInputs = [
    librsvg
    graphviz
    plantuml
  ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    find . -iname '*.lua' -execdir cp {} $out \;
  '';
}
