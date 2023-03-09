{ stdenv, wofi, writeShellScriptBin}:

writeShellScriptBin "quickcmd" ''
  cache=''${XDG_CACHE_HOME:=~/.cache}/wofi-quickcmd
  woficmd="wofi --cache-file=$cache --show dmenu"
  cmddir=''${XDG_CONFIG_HOME:=~/.config}/quickcmds
  cmd=$(ls -1 $cmddir | $woficmd)
  $cmddir/$cmd >/dev/null
''
