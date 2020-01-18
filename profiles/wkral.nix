{pkgs, ...}:
{
  imports = [
    ../modules/inputrc
    ../modules/vim
    ../modules/fzf
    ../modules/git
    ../modules/htop
    ../modules/starship
  ];

  home.packages = with pkgs; [
    file
    gnumake
    pass
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
}
