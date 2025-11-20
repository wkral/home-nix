# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let ids = import ../ids.nix;
in
{
  nixpkgs.overlays = [
    inputs.jovian.overlays.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  jovian.devices.steamdeck.enable = true;
  jovian.steam = {
    enable = true;
    autoStart = true;
    user = "wkral";
    desktopSession = "niri";
  };
  jovian.steamos.useSteamOSConfig = true;

  networking = {
    hostName = "deck"; # Define your hostname.
    networkmanager.enable = true;
    firewall.allowedUDPPorts = [ 51820 ];
  };

  systemd.network = {
    enable = true;
    netdevs."10-wg-lan" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-lan";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets.wireguard_key.path;
        ListenPort = 51820;
        RouteMetric = 100;
      };
      wireguardPeers = [
        {
          PublicKey = ids.livingroom.wg-pubkey;
          AllowedIPs = [ ids.livingroom.wg-ip ];
          Endpoint = "livingroom.lan:51820";
        }
        {
          PublicKey = ids.framework.wg-pubkey;
          AllowedIPs = [ ids.framework.wg-ip ];
          Endpoint = "framework.lan:51820";
        }
      ];
    };
    netdevs."11-wg-wan" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-wan";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets.wireguard_key.path;
        RouteMetric = 500;
      };
      wireguardPeers = [
        {
          PublicKey = ids.livingroom.wg-pubkey;
          AllowedIPs = [ "10.100.0.0/24" ];
          Endpoint = ids.wireguard-endpoint;
          PersistentKeepalive = 25;
        }
      ];
    };
    networks.wg-lan = {
      matchConfig.Name = "wg-lan";
      address = [ "10.100.0.2/24" ];
    };
    networks.wg-wan = {
      matchConfig.Name = "wg-wan";
      address = [ "10.100.0.102/24" ];
    };
  };
  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  services.pipewire.alsa.support32Bit = true;

  services.orca.enable = false;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  security.sudo.wheelNeedsPassword = false;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets.wkral_password.neededForUsers = true;
    secrets.wireguard_key = {
      mode = "0440";
      owner = config.users.users.systemd-network.name;
      group = config.users.users.systemd-network.group;
    };
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = false;
    users.wkral = {
      isNormalUser = true;
      description = "William Kral";
      hashedPasswordFile = config.sops.secrets.wkral_password.path;
      shell = pkgs.bashInteractive;
      extraGroups = [ "networkmanager" "wheel" "audio" ];
      openssh.authorizedKeys.keys = [
        ids.livingroom.ssh.wkral
        ids.framework.ssh.wkral
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile
  environment.systemPackages = [
  ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
