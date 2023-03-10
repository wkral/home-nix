{ config, pkgs, ... }:
let
  dracula = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "alacritty";
    rev = "77aff04b9f2651eac10e5cfa80a3d85ce43e7985";
    sha256 = "sha256-eJkVxcaDiIbTrI1Js5j+Nl88gawTE/mfVjstjqQOOdU=";
  };
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      import = ["${dracula}/dracula.yml"];
      env = {
        TERM = "xterm-256color";
      };
      window = {
        dynamic_title = true;
        opacity = 0.85;
      };
      mouse.hide_when_typeing = true;
      key_bindings = [
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
