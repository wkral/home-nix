{ writeShellScriptBin, jq, sway }:
let
  jq_cmd = "${jq}/bin/jq";
  swaymsg_cmd = "${sway}/bin/swaymsg";
in
writeShellScriptBin "sway-dropdown-term" ''
  if [[ $# -eq 0 ]]; then
      echo "$(basename $0): Alacritty config file path must be passed" >&2
      exit 1
  fi

  app_id="__sway_dropdown_term"
  quoted="\"$app_id\""

  selector="[app_id=$quoted]"

  function move_term() {
      read ws_width ws_height <<<$(${swaymsg_cmd} -t get_workspaces |
          ${jq_cmd} -r '.[] | select(.focused).rect | [.width, .height] | join(" ")')

      let width=$ws_width/10*6
      let height=$ws_height/3
      let xpos=$ws_width/5

      ${swaymsg_cmd} "$selector, \
          resize set $width px $height px,\
          move position $xpos 0, \
          move container to workspace current, \
          focus"
  }

  focused=$(${swaymsg_cmd} -t get_tree |
      ${jq_cmd} -r ".. | select(.app_id? == $quoted).focused")

  if [[ $focused == 'true' ]]; then
      ${swaymsg_cmd} "$selector, move container to scratchpad; focus child"
  elif [[ $focused == 'false' ]]; then
      move_term

  else
      ${swaymsg_cmd} "exec alacritty --class $app_id --config-file $1"

      _=$(${swaymsg_cmd} -t subscribe '["window"]')

      move_term
  fi
''
