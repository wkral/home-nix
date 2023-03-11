{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      pass = super.pass.override { waylandSupport = true; };
      waybar = super.waybar.override { pulseSupport = true; };
      nerdfonts = super.nerdfonts.override {
        fonts = [
          "IBMPlexMono"
          "Noto"
        ];
      };
    })
  ];

  fonts = {
    fontconfig.defaultFonts = {
      monospace = [ "Noto Sans Mono" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
    fonts = with pkgs; [
      fira
      fira-code
      font-awesome_5
      font-awesome
      ibm-plex
      nerdfonts
      unifont
      unifont_upper
      noto-fonts
      noto-fonts-extra
      noto-fonts-emoji
      material-icons
      roboto
      roboto-mono
    ];
  };

  environment.variables.TERMINAL = "alacritty";
  programs.sway.enable = true;

  # Pipewire sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    media-session.enable = false;
  };
}
