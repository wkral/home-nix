{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.wk.work;
in
with lib;
{
  options.wk.work.enable = mkEnableOption "tools for work";

  config = mkIf cfg.enable {
    wk.clojure.enable = true;
    wk.python.enable = true;

    nixpkgs.config.allowUnfree = true; # required by zoom-us, teams

    home.packages = with pkgs; [
      awscli
      packer
      terraform_0_12
      vagrant

      nodePackages.node2nix

      zoom-us # video conference
      teams

      openconnect
      gnome3.networkmanager-openconnect

      pandoc
      graphviz
      plantuml
      librsvg
      wk.texlive

      wk.mkpdf

      wk.last-commit-id
      wk.newbranch
      wk.vagrant-halt-all
      wk.vsh

      wk.node-tools.ajv-cli
      wk.node-tools.swagger-cli

    ];

    programs.gpg.settings = {
      default-key = "3213F8D26AD65DF98B62C43BC733A26D1B5DE28D";
    };

    systemd.user.services."ssh-tunnel@" = {
      Unit = {
        Description = "Setup a secure tunnel to %I";
        After = "network.target";
      };

      Service = {
        EnvironmentFile = "%h/.ssh/systemd-tunnels/%i";
        ExecStart = ''${pkgs.openssh}/bin/ssh -NT -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -L ''${LOCAL_ADDR}:''${LOCAL_PORT}:''${REMOTE_ADDR}:''${REMOTE_PORT} ''${TARGET}'';

        # Restart every >2 seconds to avoid StartLimitInterval failure
        RestartSec = 5;
        Restart = "always";
      };

      Install = { WantedBy = [ "multi-user.target" ]; };
    };
  };
}
