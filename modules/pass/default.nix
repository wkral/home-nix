{ pkgs, ... }:
with pkgs;
let
  passpkg = pass-wayland.withExtensions (exts: [ exts.pass-otp ]);
in
{
  config = {
    home.packages = [
      passpkg
    ];
  };
}
