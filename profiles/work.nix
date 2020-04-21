{ pkgs, ... }:
let
  scripts = import ../scripts {
    inherit pkgs;
    inherit builtins;
  };

  node-tools = import ../modules/node-tools {
    inherit pkgs;
  };
in
{
  imports = [
    ../modules/python
    ../modules/clojure
    ../modules/teams
    ../modules/docs
  ];

  nixpkgs.config.allowUnfree = true; # required by zoom-us

  home.packages = with pkgs; [
    awscli
    packer
    terraform_0_12
    vagrant

    node-tools.ajv-cli
    node-tools.swagger-cli

    nodePackages.node2nix

    zoom-us # video conference

    openconnect
    gnome3.networkmanager-openconnect

    scripts.last-commit-id
    scripts.newbranch
    scripts.release-notes
    scripts.vagrant-halt-all
    scripts.vsh
  ];

  programs.gpg.settings = {
    default-key = "3213F8D26AD65DF98B62C43BC733A26D1B5DE28D";
  };
}
