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
          ];
        }

        {
          networking.hosts = {
            "46.224.101.220" = [ "vps" ];
          };
        }
      ];
    };
  };
}
