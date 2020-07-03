{ pkgs, ... }:
{
  home.file.".projectM/config.inp".text = ''
    Aspect Correction = 1
    Easter Egg Parameter = 1
    FPS = 60
    Fullscreen = true
    Hard Cut Sensitivity = 10
    Menu Font = ${pkgs.noto-fonts}/share/fonts/truetype/noto/NotoSansMono-Regular.ttf
    Mesh X = 220
    Mesh Y = 125
    Preset Duration = 45
    Preset Path = ${pkgs.projectm}/share/projectM/presets
    Shuffle Enabled = 1
    Smooth Preset Duration = 5
    Smooth Transition Duration = 5
    Soft Cut Ratings Enabled = 0
    Texture Size = 512
    Title Font = ${pkgs.noto-fonts}/share/fonts/truetype/noto/NotoSans-Regular.ttf
    Window Height = 512
    Window Width = 512
  '';
}
