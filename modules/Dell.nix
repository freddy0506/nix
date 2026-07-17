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

          # ssh to copy data
          services.openssh = {
            enable = true;
            openFirewall = true;
            settings = {
              PasswordAuthentication = false;
              KbdInteractiveAuthentication = false;
              PermitRootLogin = "no";
              AllowUsers = [ "freddy" ];
              MaxAuthTries = 3;
              PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
            };
          };

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
