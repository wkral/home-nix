{ pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    settings = {
      default-key = "3213F8D26AD65DF98B62C43BC733A26D1B5DE28D";
    };
  };
}
