{ pkgs, ... }:
{
  imports = [
    ../pkgs
  ];
  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      ripgrep
      vim
      fzf
      git
      curl

      usbutils
      pciutils
    ];
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.trusted-users = ["root" "@wheel"];
  };
}
