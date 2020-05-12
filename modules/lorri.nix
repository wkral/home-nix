{ pkgs, ... }:
{
  home.packages = with pkgs; [
    direnv
  ];

  services.lorri.enable = true;

  programs.bash.initExtra = ''
    eval "$(direnv hook bash)"
  '';
}
