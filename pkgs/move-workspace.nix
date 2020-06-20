{ writeShellScriptBin, wofi, jq, sway }:
let
  swaymsg = "${sway}/bin/swaymsg";
  jqcmd = "${jq}/bin/jq -r";
  woficmd = "${wofi}/bin/wofi --cache-file=/dev/null --show dmenu";
  outputscmd = "${swaymsg} -t get_outputs | ${jqcmd} '.[] | .name'";
  current-workspace = "${swaymsg} -t get_workspaces | ${jqcmd} '.[] | select(.focused) | .name'";
in
writeShellScriptBin "move-workspace" ''
  set -e
  output=$(${outputscmd} | ${woficmd})
  ${swaymsg} workspace $(${current-workspace}) output $output
''
