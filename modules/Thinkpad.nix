{self, inputs, ...}:
{
  flake = {
    nixosConfigurations.Thinkpad = inputs.nixpkgs.lib.nixosSystem {
      modules = with self.nixosModules; [
        helix
        nixvim
        hardware
        hardware-config
        consoleEnv
        desktopEnv
        syncthing
        
        # overlay for reloc8
        {
          nixpkgs.overlays = [
            (final: prev: {inherit (inputs.reloc8.packages.${prev.stdenv.system}) reloc8; })
            (final: prev: {teamtype-lsp = inputs.teamtype-lsp.packages.${prev.stdenv.system}.default; })
          ];
        }
      ];
    };
  };
}
