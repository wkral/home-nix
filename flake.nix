{
  description = "Host configurations";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    sops-nix = {
      url = github:Mic92/sops-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = github:Jovian-Experiments/Jovian-NixOS;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dracula-alacritty = {
      url = github:dracula/alacritty;
      flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      nixosConfigurations = import ./hosts inputs;
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.sops
          pkgs.wireguard-tools
          pkgs.ssh-to-age
        ];
      };
    };
}
