{ writeShellScriptBin, wofi, bash }:
writeShellScriptBin "quickcmd" ''
  cache=''${XDG_CACHE_HOME:=~/.cache}/wofi-quickcmd
  woficmd="${wofi}/bin/wofi --cache-file=$cache --show dmenu"
  cmd=$(ls -1 ${./cmds} | $woficmd)
  ${bash}/bin/bash ${./cmds}/$cmd >/dev/null
''
