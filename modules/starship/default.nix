{pkgs, ...}:
{
  home.packages = [
    pkgs.starship
  ];

  xdg.configFile."starship.toml".source = ./starship.toml;

  programs.bash.initExtra = ''
    source <("${pkgs.starship}/bin/starship" init bash --print-full-init)
  '';
}
