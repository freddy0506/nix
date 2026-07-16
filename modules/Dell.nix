{self, inputs, ...}:
{
  flake = {
    nixosConfigurations.Dell= inputs.nixpkgs.lib.nixosSystem {
      modules = with self.nixosModules; [
        helix
        dell-disko
        dell-hardware
        hardware
        consoleEnv
        desktopEnv
        inputs.disko.nixosModules.disko
        
        {
          nixpkgs.overlays = [
            (final: prev: {inherit (inputs.reloc8.packages.${prev.stdenv.system}) reloc8; })
          ];
        }

        {
          networking.hosts = {
            "116.203.157.119" = [ "vps" ];
          };
        }
      ];
    };
  };
}
