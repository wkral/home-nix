# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let ids = import ../ids.nix;
in
{
  imports = [
    ./syncthing.nix
  ];
  #  nixpkgs.overlays = [
  #    (final: prev: {
  #      virglrenderer = pkgs.callPackage ./virglrenderer-0_9_1.nix { };
  #    })
  #  ];
  # Use the systemd-boot EFI boot loader.
  boot = {
    initrd.systemd.enable = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = true;
  };

  console = {
    #earlySetup = true;
    #font = "ter-powerline-v24b";
    keyMap = "us";
    #packages = [
    #  pkgs.terminus_font
    #  pkgs.powerline-fonts
    #];
    #colors = [
    #  "282a36"
    #  "6272a4"
    #  "ff5555"
    #  "ff7777"
    #  "50fa7b"
    #  "70fa9b"
    #  "f1fa8c"
    #  "ffb86c"
    #  "bd93f9"
    #  "cfa9ff"
    #  "ff79c6"
    #  "ff88e8"
    #  "8be9fd"
    #  "97e2ff"
    #  "f8f8f2"
    #  "ffffff"
    #];
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
    firewall.allowedUDPPorts = [ 51820 51821 ];
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
          PublicKey = ids.deck.wg-pubkey;
          AllowedIPs = [ ids.deck.wg-ip ];
          Endpoint = "deck.lan:51820";
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
        ListenPort = 51821;
        RouteMetric = 500;
      };
      wireguardPeers = [
        {
          PublicKey = ids.deck.wg-pubkey;
          AllowedIPs = [ ids.deck.wg-wan-ip ];
        }
        {
          PublicKey = ids.framework.wg-pubkey;
          AllowedIPs = [ ids.framework.wg-wan-ip ];
        }
      ];
    };
    networks.wg-lan = {
      matchConfig.Name = "wg-lan";
      address = [ "10.100.0.1/24" ];
    };
    networks.wg-wan = {
      matchConfig.Name = "wg-wan";
      address = [ "10.100.0.101/24" ];
    };
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
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  programs.wireshark.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

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

  services.udisks2.enable = true;

  # Make USB webcam writeable for others allows passthrough with QEMU
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="58b0*", MODE="0666"
    #ThinkPad TrackPoint Keyboard I & II USB fnlock off
    SUBSYSTEM=="hid", DRIVER=="lenovo", ATTRS{idVendor}=="17ef", ATTRS{idProduct}=="6047|60ee", ATTR{fn_lock}="0"
    # Make phone user readable for syncing
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2717", ATTRS{idProduct}=="ff40*", MODE="0666"
  '';

  # Enable Steam
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages32 = [ pkgs.pkgsi686Linux.libva ];
  };
  nixpkgs.config.allowUnfree = true;
  hardware.steam-hardware.enable = true;
  services.pipewire.alsa.support32Bit = true; # required for steam

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

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
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = false;
    users.wkral = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.wkral_password.path;
      shell = pkgs.bashInteractive;
      extraGroups = [
        "wheel"
        "audio"
        "networkmanager"
        "wireshark"
      ];
      openssh.authorizedKeys.keys = [
        ids.framework.ssh.wkral
        ids.macbook.ssh.wkral
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
