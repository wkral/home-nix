{ stdenv, pandoc, writeShellScriptBin, wk }:
writeShellScriptBin "mkpdf" ''
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
    (-l | --list-templates) ls -1 ${./templates}; exit 0;;
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

  [ -d "${./templates}/$template" ] || error "'$template' is not an available template";

  [ "$outfile" != "" ] || outfile="''${infile%%.*}.pdf";

  ${pandoc}/bin/pandoc $infile \
    --lua-filter=${./lua-filters}/include.lua \
    --lua-filter=${wk.lua-filters}/diagram-generator.lua \
    --pdf-engine=${wk.texlive}/bin/pdflatex
    --highlight-style ${./templates}/$template/code-style.theme \
    --output $outfile --pdf-engine=pdflatex \
    --metadata=template-dir=${./templates}/$template/ \
    --template=${./templates}/$template/template.tex
''
