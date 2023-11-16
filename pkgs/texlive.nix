{ texlive }:
texlive.combine {
  inherit (texlive)
    scheme-small
    collection-fontsextra
    collection-latexextra
    collection-fontsrecommended
    lualatex-math
    selnolig
    cm-super
    ;
}
