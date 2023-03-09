{ config, lib, ... }:
with lib;
{
  xdg.configFile."wofi/config".text = ''
    width=600
    lines=7
    allow_images=true
  '';
  xdg.configFile."wofi/style.css".text = ''
    * {
        font-family: "Noto Sans SemiBold";
        font-size: ${toString (config.wk.gui.font.base-size + 1)}pt;
    }
  '' + strings.fileContents ./style.css;
}
