{ config, pkgs, ... }:
let
  dracula = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "alacritty";
    rev = "05faff15c0158712be87d200081633d9f4850a7d";
    sha256 = "sha256-Pb6KLNq90P1s8M08avKlf6D7DHbuNOsp9k6mZmpA+Fg=";
  };
in
{
  programs.alacritty = {
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
          mods = "Control";
          key = "N";
          action = "SpawnNewInstance";
        }
      ];
      font = {
        normal.family = "IBM Plex Mono";
        bold.style = "SemiBold";
        italic.style = "Light Italic";
        size = config.wk.font.base-size;
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
