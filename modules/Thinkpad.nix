{self, inputs, ...}:
{
  flake = {
    nixosConfigurations.Thinkpad = inputs.nixpkgs.lib.nixosSystem {
      modules = with self.nixosModules; [
        helix
        hardware
        consoleEnv
        desktopEnv
        syncthing
        
        # overlay for reloc8
        {
          nixpkgs.overlays = [
            (final: prev: {inherit (inputs.reloc8.packages.${prev.stdenv.system}) reloc8; })
          ];
        }
      ];
    };
  };
}
