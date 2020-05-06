{ config, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      dynamic_title = true;
      mouse = {
        hide_when_typeing = true;
      };
      key_bindings = [
        {
          mods = "Control";
          key = "N";
          action = "SpawnNewInstance";
        }
      ];
      background_opacity = 0.9;
      font = {
        normal = {
          family = "Noto Sans Mono Condensed";
        };
        bold = {
          family = "Noto Sans Mono Condensed SemiBold";
        };
        italic = {
          family = "Noto Sans Mono Condensed Italic";
        };
        size = config.gui.base-font-size;
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
        normal = {
          black = "0x282a2e";
          red = "0xa54242";
          green = "0x6b9440";
          yellow = "0xde935f";
          blue = "0x5f819d";
          magenta = "0x85678f";
          cyan = "0x5e8d87";
          white = "0x707880";
        };
        bright = {
          black = "0x373b41";
          red = "0xcc6666";
          green = "0x9cbd68";
          yellow = "0xf0c674";
          blue = "0x81a2be";
          magenta = "0xb294bb";
          cyan = "0x8abeb7";
          white = "0xc5c8c6";
        };
      };
    };
  };
}
