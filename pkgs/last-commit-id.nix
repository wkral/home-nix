{ writeShellScriptBin }:
writeShellScriptBin "random-hourly-bg" ''
  id=$(git rev-parse --short HEAD)
  echo -n "Fixed in $id." | wl-copy
''