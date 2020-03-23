{ pkgs, ... }:
{
  imports = [
    ../modules/inputrc
    ../modules/vim
    ../modules/fzf
    ../modules/git
    ../modules/htop
    ../modules/starship
    ../modules/pass
  ];

  home.packages = with pkgs; [
    file
    gnumake
    broot
    nnn
    unzip
    openssl
    dnsutils
    zip
    qrencode
  ];

  programs.bash.enable = true;
  programs.jq.enable = true;
  programs.taskwarrior.enable = true;
}
