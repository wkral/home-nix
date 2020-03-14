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
    ../modules/work-gpg
    ../modules/python
    ../modules/clojure
    ../modules/teams
    ../modules/docs
  ];


  home.packages = with pkgs; [
    awscli
    packer
    terraform_0_12
    vagrant

    node-tools.ajv-cli
    node-tools.swagger-cli

    nodePackages.node2nix

    scripts.last-commit-id
    scripts.newbranch
    scripts.release-notes
    scripts.vagrant-halt-all
    scripts.vsh
  ];
}
