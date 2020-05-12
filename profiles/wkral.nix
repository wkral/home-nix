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
    yj
    nix-review
  ];

  programs = {
    bash.enable = true;
    jq.enable = true;
    taskwarrior.enable = true;
    gpg.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };
}
