{ pkgs, ... }:

with pkgs;
let
  tex = texlive.combine {
    inherit (texlive)
      scheme-small
      collection-fontsextra
      collection-latexextra
      collection-fontsrecommended
      cm-super
      ;
  };
  lua-filters = stdenv.mkDerivation rec {
    pname = "lua-filters";
    version = "2020-02-25";
    src = pkgs.fetchFromGitHub {
      owner = "pandoc";
      repo = "lua-filters";
      rev = "b5543537c7a389425476c2e1dd6a1bd84f914c8b";
      sha256 = "1whlzsyndi82z64m80ybc3cjd2v50jw1d17ihq6a9s7k01n0vfhf";
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      find . -iname '*.lua' -execdir cp {} $out \;
    '';
  };
  newdoc = writeShellScriptBin "newdoc" (builtins.readFile ./newdoc);
  templates = ./templates;
  local-lua = ./lua-filters;
  mkpdf = writeShellScriptBin "mkpdf" ''
    __usage="
    Usage:
      $(basename $0) (-t | --template) TEMPLATE INFILE

    INFILE    Source file to make into a PDF
    TEMPLATE  An available template, use (-l | --list-templates) see available

    Options:
      -l | --list-templates     Lists available templates
      -o | --out FILE           Specify an output file
      -t | --template TEMPLATE  Select which template to use
    "

    function error {
      echo "$(basename $0): $1" >&2;
      echo "$__usage" >&2;
      exit 1;
    }

    opts=$(getopt -n mkpdf -o 'lt:o:' -l 'list-templates,template:,out:' -- "$@")
    [ $? == 0 ] || error "error parsing options" >&2;
    set -- $opts;

    template=""
    outfile=""

    while [ $# -gt 0 ]
    do
      case "$1" in
      (-l | --list-templates) ls -1 ${templates}; exit 0;;
      (-t | --template) template=$(eval "echo $2"); shift 2;;
      (-o | --out) outfile=$(eval "echo $2"); shift 2;;
      (--) shift; break;;
      (*)  break;;
      esac
    done

    [ $# -gt 0 ] || error "Must specify source markdown file";

    infile=$(eval "echo $1");
    shift;

    [ -f $infile ] || error "$infile must be a markdown file";

    [ "$template" != "" ] || error "Missing template argument";

    [ -d "${templates}/$template" ] || error "'$template' is not an available template";

    [ "$outfile" != "" ] || outfile="''${infile%%.*}.pdf";

    ${pkgs.pandoc}/bin/pandoc $infile \
      --lua-filter=${local-lua}/include.lua \
      --lua-filter=${lua-filters}/diagram-generator.lua \
      --highlight-style ${templates}/$template/code-style.theme \
      --output $outfile --pdf-engine=pdflatex \
      --metadata=template-dir=${templates}/$template/ \
      --template=${templates}/$template/template.tex
  '';
in
{
  home.packages = [
    newdoc
    librsvg
    graphviz
    pandoc
    plantuml
    tex
    mkpdf
  ];
}
