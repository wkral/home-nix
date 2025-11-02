{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      pass = super.pass.override { waylandSupport = true; };
      waybar = super.waybar.override { pulseSupport = true; };
      tela-circle-icon-theme = super.tela-circle-icon-theme.override
        { colorVariants = [ "dracula" ]; };
    })
  ];

  environment.systemPackages = [
    # Theme packages
    pkgs.dracula-theme
    pkgs.simp1e-cursors
    pkgs.tela-circle-icon-theme
    pkgs.pulseaudio
  ];

  fonts = {
    fontconfig.defaultFonts = {
      monospace = [ "NotoSansM Nerd Font" ];
      sansSerif = [ "NotoSans Nerd Font" ];
      serif = [ "NotoSerif Nerd Font" ];
    };
    packages = [
      pkgs.fira
      pkgs.fira-code
      pkgs.font-awesome_5
      pkgs.font-awesome
      pkgs.ibm-plex
      pkgs.nerd-fonts.blex-mono
      pkgs.nerd-fonts.noto
      pkgs.unifont
      pkgs.unifont_upper
      pkgs.noto-fonts
      pkgs.noto-fonts-color-emoji
      pkgs.material-icons
      pkgs.roboto
      pkgs.roboto-mono
    ];
  };

  environment.variables.TERMINAL = "alacritty";
  programs.niri.enable = true;
  services.gnome.at-spi2-core.enable = true;
  programs.dconf.enable = true;

  # Pipewire sound.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    audio.enable = true;
  };
}
