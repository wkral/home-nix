{pkgs, ... }:
let
  scripts = import ../scripts {
    inherit pkgs;
    inherit builtins;
  };
in
{
  imports = [
    ../modules/work-gpg
    ../modules/python
    ../modules/clojure
    # ./modules/ajv TODO Fix this
  ];


  home.packages = with pkgs; [
    awscli
    packer
    terraform_0_12
    vagrant

    scripts.last-commit-id
    scripts.newbranch
    scripts.release-notes
    scripts.vagrant-halt-all
    scripts.vsh
  ];
}
