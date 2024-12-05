{ config, inputs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = ["${inputs.dracula-alacritty}/dracula.toml"];
      env = {
        TERM = "xterm-256color";
      };
      window = {
        dynamic_title = true;
        opacity = 0.85;
      };
      mouse.hide_when_typing = true;
      keyboard.bindings = [
        {
          mods = "Control|Shift";
          key = "Return";
          action = "SpawnNewInstance";
        }
      ];
      font = {
        normal.family = "BlexMono Nerd Font";
        bold.style = "SemiBold";
        italic.style = "Light Italic";
        size = config.wk.gui.font.base-size;
      };
      colors = {
        primary = {
          background = "0x1d1f21";
          foreground = "0xc5c8c6";
        };
        cursor = {
          text = "0x000000";
          cursor = "0xc5c8c6";
        };
      };
    };
  };
}
