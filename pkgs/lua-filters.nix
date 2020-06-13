{ stdenv, fetchFromGitHub, librsvg, graphviz, plantuml }:
stdenv.mkDerivation {
  pname = "lua-filters";
  version = "2020-02-25";
  src = fetchFromGitHub {
    owner = "pandoc";
    repo = "lua-filters";
    rev = "b5543537c7a389425476c2e1dd6a1bd84f914c8b";
    sha256 = "1whlzsyndi82z64m80ybc3cjd2v50jw1d17ihq6a9s7k01n0vfhf";
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
