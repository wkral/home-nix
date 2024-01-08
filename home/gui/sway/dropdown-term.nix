{ config, lib, pkgs, ... }:
let
  ddterm = "${pkgs.wk.sway-dropdown-term}/bin/sway-dropdown-term";
  overrides = {
    window.title = "Dropdown Term";
    colors.primary.background = "0x0d1f21";
    window.padding.x = 8;
  };
  ddconfig = lib.recursiveUpdate config.programs.alacritty.settings overrides;
  tomlFormat = pkgs.formats.toml { };
  config-pkg = tomlFormat.generate "config.toml" ddconfig;
  modifier = config.wayland.windowManager.sway.config.modifier;
in
{
  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
    "${modifier}+space" = "exec ${ddterm} ${config-pkg}";
  };
  xdg.configFile."sway/config.d/dropdown.conf".text = ''
    for_window [app_id="__sway_dropdown_term"] floating enable
  '';
}
