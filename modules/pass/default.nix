{ pkgs, ... }:
with pkgs;
let
  passpkg = pass.withExtensions (exts: [ exts.pass-otp ]);
in
{
  config = {
    home.packages = [
      passpkg
    ];
  };
}
