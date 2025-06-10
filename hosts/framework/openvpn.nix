{ config, pkgs, ... }:
{
  services.openvpn.servers.dev-us-west-1 = {
    autoStart = false;
    config = ''
      config ${config.sops.secrets.vpn_dev_us_west_1_config.path}

      script-security 2

      auth-user-pass ${config.sops.secrets.vpn_dev_us_west_1_auth.path}

      up ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved
      up-restart
      down ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved
      down-pre
    '';
  };
}
