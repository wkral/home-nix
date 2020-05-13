{ pkgs, ... }:
with pkgs;
{
  nixpkgs.overlays = [
    (self: super: {
      pass = super.pass.override {
        waylandSupport = true;
      };
    })
  ];
  home.packages = [
    (pass.withExtensions (exts: [ exts.pass-otp ]))
  ];
}
