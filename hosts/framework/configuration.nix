{ config, pkgs, ... }:

let ids = import ../ids.nix;
in
{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  networking = {
    hostName = "framework"; # Define your hostname.
    networkmanager.enable = true;
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
          wireguardPeerConfig = {
            PublicKey = ids.livingroom.wg-pubkey;
            AllowedIPs = [ ids.livingroom.wg-ip ];
            Endpoint = ids.wireguard-endpoint;
            PersistentKeepalive = 25;
          };
        }
        {
          wireguardPeerConfig = {
            PublicKey = ids.deck.wg-pubkey;
            AllowedIPs = [ ids.deck.wg-ip ];
          };
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

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
    ];
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

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
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
      extraGroups = [ "networkmanager" "wheel" "sway" "audio" ];
      openssh.authorizedKeys.keys = [
        ids.livingroom.ssh.wkral
        ids.macbook.ssh.wkral
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
  ];

  programs.captive-browser = {
    enable = true;
    interface = "wlp1s0";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
