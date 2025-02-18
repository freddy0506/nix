{
  description = "Freddy's system Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    ethersync = {
      url = "github:ethersync/ethersync";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    reloc8 = {
      url = "github:freddy0506/reloc8";
      inputs.nixpkgs.follows = "nixpkgs";
    }; /*
    emotionAPI = {
      url = "git+ssh://git@github.com/Hydra-Technologies/emotionAPI";
      inputs.nixpkgs.follows = "nixpkgs";
    };*/
  };

  outputs = { self, nixpkgs, nixvim, ethersync, reloc8, /* emotionAPI */ }@inputs: {
    nixosConfigurations = {
      Thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./configuration.nix

          nixvim.nixosModules.nixvim

          {
            nixpkgs.overlays = [
              (final: prev: {inherit (ethersync.packages.${prev.stdenv.system}) ethersync;}) 
              (final: prev: {inherit (reloc8.packages.${prev.stdenv.system}) reloc8; })
              # (final: prev: {inherit (emotionAPI.packages.${prev.stdenv.system}) emotiondayAPI; })
            ];
          }
        ];
      };
    };
  };
}
