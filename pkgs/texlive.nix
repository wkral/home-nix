{ texlive }:
texlive.combine {
  inherit (texlive)
    scheme-small
    collection-fontsextra
    collection-latexextra
    collection-fontsrecommended
    cm-super
    ;
}
