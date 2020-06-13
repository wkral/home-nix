{ writeShellScriptBin, fd }:
writeShellScriptBin "random-hourly-bg" ''
# vim: filetype=bash
set -e

function _term() {
  kill -HUP "$sleep_pid" 2>/dev/null
}

trap _term SIGHUP

papers_dir="$HOME/.config/wallpapers/"

function setbg () {
  local bg=$(${fd}/bin/fd . -e png -e jpg $papers_dir | shuf -n 1)
  swaymsg --socket $SWAYSOCK output '*' bg $bg fill
  sleep 1h &
  sleep_pid=$!
  wait "$sleep_pid"
  setbg
}
setbg
''
