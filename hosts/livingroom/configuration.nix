# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{

  nixpkgs.overlays = [
    (final: prev: {
      virglrenderer = pkgs.callPackage ./virglrenderer-0_9_1.nix { };
    })
  ];
  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "1";
      };
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
  };

  console = {
    #earlySetup = true;
    font = "ter-powerline-v24b";
    keyMap = "us";
    packages = [
      pkgs.terminus_font
      pkgs.powerline-fonts
    ];
    colors = [
      "282a36"
      "6272a4"
      "ff5555"
      "ff7777"
      "50fa7b"
      "70fa9b"
      "f1fa8c"
      "ffb86c"
      "bd93f9"
      "cfa9ff"
      "ff79c6"
      "ff88e8"
      "8be9fd"
      "97e2ff"
      "f8f8f2"
      "ffffff"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  services.fwupd.enable = true;


  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    hostName = "livingroom";
    useDHCP = false;
    interfaces.enp4s0.useDHCP = true;
    interfaces.wlp5s0.useDHCP = true;
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  environment.systemPackages = with pkgs; [
    lm_sensors
    qemu_kvm
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services = {
    printing = {
      enable = true;
      startWhenNeeded = true;
    };
    avahi = {
      enable = true;
      nssmdns = true;
    };
  };

  services.udisks2.enable = true;

  # Make USB webcam writeable for others allows passthrough with QEMU
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="58b0*", MODE="0666"
  '';

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet -c sway'';
        user = "greeter";
      };
    };
  };

  # Enable Steam
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [ pkgs.pkgsi686Linux.libva ];
  };
  nixpkgs.config.allowUnfree = true;
  hardware.steam-hardware.enable = true;

  # Pipewire sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # required for steam
    pulse.enable = true;
    wireplumber.enable = true;
    media-session.enable = false;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  hardware.bluetooth = {
    enable = false; # bluetooth controller on MB isn't so great
    powerOnBoot = true;
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets.wkral_password.neededForUsers = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = false;
    users.wkral = {
      isNormalUser = true;
      passwordFile = config.sops.secrets.wkral_password.path;
      shell = pkgs.bashInteractive;
      extraGroups = [
        "wheel"
        "sway"
        "audio"
        "networkmanager"
        "wireshark"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSsYbuCFzk+qWYhj1C+bPkcfUKQQw9J51bt6FszVZaD"
      ];
    };
    users.greeter.group = "greeter";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
