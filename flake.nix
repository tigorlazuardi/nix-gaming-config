{
  description = "SteamOS-like NixOS gaming system";

  inputs = {
    # Jovian supports nixos-unstable only. flake.lock keeps host updates deliberate.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      disko,
      jovian,
      nixpkgs,
      ...
    }:
    {
      nixosConfigurations.steamos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          jovian.nixosModules.default
          ./disko.nix
          ./configuration.nix
        ];
      };
    };
}
