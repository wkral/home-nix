{ pkgs, ... }:
let newpkgs =
  {
    quickcmd = pkgs.callPackage ./quickcmd {};
  };
in
{
  nixpkgs.overlays = [
    (self: super: {
      wkral = newpkgs;
    })
  ];
}
