{ writeShellScriptBin }:
writeShellScriptBin "last-commit-id" ''
  id=$(git rev-parse --short HEAD)
  echo -n "Fixed in $id." | wl-copy
''
