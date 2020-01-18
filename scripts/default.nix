{pkgs, builtins, ...}:
let
  pkgScript = name:
    let
      path = ./. + ("/" + name);
      src = builtins.readFile path;
    in
    pkgs.writeShellScriptBin name src;
in
{
  last-commit-id = pkgScript "last-commit-id";
  newbranch = pkgScript "newbranch";
  release-notes = pkgScript "release-notes";
  vagrant-halt-all = pkgScript "vagrant-halt-all";
  vsh = pkgScript "vsh";
}
