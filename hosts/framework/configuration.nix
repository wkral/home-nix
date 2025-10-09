{ config, pkgs, ... }:

let
  ids = import ../ids.nix;
in
{
  imports = [
    ./syncthing.nix
    ./openvpn.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  networking = {
    hostName = "framework"; # Define your hostname.
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    firewall.allowedUDPPorts = [ 51820 ];
  };

  systemd.network = {
    enable = true;
    netdevs."10-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets.wireguard_key.path;
        ListenPort = 51820;
      };
      wireguardPeers = [
        {
          PublicKey = ids.livingroom.wg-pubkey;
          AllowedIPs = [ ids.livingroom.wg-ip ];
          Endpoint = ids.wireguard-endpoint;
          PersistentKeepalive = 25;
        }
        {
          PublicKey = ids.deck.wg-pubkey;
          AllowedIPs = [ ids.deck.wg-ip ];
        }
      ];
    };
    networks.wg0 = {
      matchConfig.Name = "wg0";
      address = [ "10.100.0.3/24" ];
    };
  };
  # Set your time zone.
  time.timeZone = "America/Vancouver";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  services.pipewire.alsa.support32Bit = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  programs.wireshark.enable = true;

  security.sudo.wheelNeedsPassword = false;

  services.fwupd.enable = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      wkral_password.neededForUsers = true;
      wireguard_key = {
        mode = "0440";
        owner = config.users.users.systemd-network.name;
        group = config.users.users.systemd-network.group;
      };
      syncthing_cert.mode = "0400";
      syncthing_key.mode = "0400";
      vpn_dev_us_west_1_config.mode = "0400";
      vpn_dev_us_west_1_auth.mode = "0400";
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
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "wireshark"
      ];
      openssh.authorizedKeys.keys = [
        ids.livingroom.ssh.wkral
        ids.macbook.ssh.wkral
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable CUPS to print documents.
  services = {
    printing = {
      enable = true;
      startWhenNeeded = true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
  };

  services.udev.extraRules = ''
    # Make phone user readable for syncing
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2717", ATTRS{idProduct}=="ff40*", MODE="0666"
  '';

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    lm_sensors
    qemu_kvm
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
