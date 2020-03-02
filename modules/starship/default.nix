{pkgs, ...}:
{
  home.packages = [
    pkgs.starship
  ];

  xdg.configFile."starship.toml".source = ./starship.toml;

  programs.bash.initExtra = ''
    function set_win_title(){
      echo -ne "\033]0; $USER@$HOSTNAME:$PWD \007"
    }
    starship_precmd_user_func="set_win_title"
    source <("${pkgs.starship}/bin/starship" init bash --print-full-init)
  '';
}
