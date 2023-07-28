{ nixpkgs, sops-nix, home-manager, ... }:
{
  livingroom = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixpkgs.nixosModules.notDetected
      sops-nix.nixosModules.sops
      ./common.nix
      ./common-gui.nix
      ./livingroom/configuration.nix
      ./livingroom/hardware-configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.wkral = import ./livingroom/wkral.nix;
      }
    ];
  };
  deck = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixpkgs.nixosModules.notDetected
      sops-nix.nixosModules.sops
      ./common.nix
      ./common-gui.nix
      ./deck/configuration.nix
      ./deck/hardware-configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.wkral = import ./deck/wkral.nix;
      }
    ];
  };
  work-vm = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixpkgs.nixosModules.notDetected
      sops-nix.nixosModules.sops
      ./common.nix
      ./common-gui.nix
      ./work-vm/configuration.nix
      ./work-vm/hardware-configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.wkral = import ./work-vm/wkral.nix;
      }
    ];
  };
}
