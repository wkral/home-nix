{ nixpkgs, sops-nix, home-manager, jovian, ... } @ inputs:
let
  host = { name, system, extraModules ? [ ] }: (nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      nixpkgs.nixosModules.notDetected
      sops-nix.nixosModules.sops
      ./common.nix
      ./${name}/configuration.nix
      ./${name}/hardware-configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.wkral = import ./${name}/wkral.nix;
      }
    ] ++ extraModules;
  });
in
{
  livingroom = host {
    name = "livingroom";
    system = "x86_64-linux";
    extraModules = [ ./common-gui.nix ./regreet.nix];
  };
  framework = host {
    name = "framework";
    system = "x86_64-linux";
    extraModules = [ ./common-gui.nix ./regreet.nix ./docker.nix ];
  };
  deck = host {
    name = "deck";
    system = "x86_64-linux";
    extraModules = [
      ./common-gui.nix
      jovian.nixosModules.jovian
    ];
 };
}
