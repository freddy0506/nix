{self, inputs, ...}: {
  flake.nixosModules.server = {

      # Create a mumble Server as a chat alternative
      services.murmur = {
        enable = true;
        password = "Bildungsweg3004";
        openFirewall = true;
      };
  };

  flake.nixosModules.serverHardware = {modulesPath, lib, ...}: {
    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
      inputs.pferdehofWeb.nixosModules.pferdehofWeb
    ];

    services.pferdehofWebsite.enable = true;

    nix.settings = {
      experimental-features = "nix-command flakes";
    };

    

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "ext4";
    };

    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "neoqwertz";


    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";
    boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "ext4" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    users.users = {
      root.hashedPassword = "!"; # Disable root login
      freddy = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvq9MAgQSDBRNJcahIyhtlMo8LKvOHOMToQPMv3Tyz6XouHYxdjNsssz/WI+nKwJlZa631Inj2dBDjxDo5FAoG5z4L+3t+5DL8r17gtYYapvZbZSG9dVN8nfs8LaRLLZWiezmyv6l5dRew49yhGB8Cn5qnMzC61xdDjgtbdMmaMHBmFpmd9D7I98Xm2jLhEnnubTK41b+HL5Ul/bhrI1VPX2ocr3imjyqdCrJiz6JTcc5K+eQnjIGXHC5hf6hY24BKW8Z1+PWto60q+ZV5Jqnd+QAU5174IVlpWDhbWFaYqfIowuqujvtmSJ3ZbY12baBeVtaLkqDnnVmHLG5kJJ2+acW8Fjncvbmud+LszMGQDoiJdmzGTVsRypKQ88F+zHxzNx8qS0PNt/fLV2l1atG8OVc6PaOXebjp4XKfNnr8aI3SaLPc2/Q9XCOzQcd+lx2QEEIfyjAbvin4E7jZxwj9DoOaQLK1tSmC05rwvpBUUrxN38JS7LofAjYT5CMONws= freddy@freddyThinkpad"
        ];
      };

      leon = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvq9MAgQSDBRNJcahIyhtlMo8LKvOHOMToQPMv3Tyz6XouHYxdjNsssz/WI+nKwJlZa631Inj2dBDjxDo5FAoG5z4L+3t+5DL8r17gtYYapvZbZSG9dVN8nfs8LaRLLZWiezmyv6l5dRew49yhGB8Cn5qnMzC61xdDjgtbdMmaMHBmFpmd9D7I98Xm2jLhEnnubTK41b+HL5Ul/bhrI1VPX2ocr3imjyqdCrJiz6JTcc5K+eQnjIGXHC5hf6hY24BKW8Z1+PWto60q+ZV5Jqnd+QAU5174IVlpWDhbWFaYqfIowuqujvtmSJ3ZbY12baBeVtaLkqDnnVmHLG5kJJ2+acW8Fjncvbmud+LszMGQDoiJdmzGTVsRypKQ88F+zHxzNx8qS0PNt/fLV2l1atG8OVc6PaOXebjp4XKfNnr8aI3SaLPc2/Q9XCOzQcd+lx2QEEIfyjAbvin4E7jZxwj9DoOaQLK1tSmC05rwvpBUUrxN38JS7LofAjYT5CMONws= freddy@freddyThinkpad"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnQ0QEWih6LIC2HyJ5+ji+TEHHAj9qXWkftubiwlG9eRK8SHadp4yRgPuetnqDB5NbdwuvI0n6xhXc+09invGigE53CWVTpXNMkpAzKXde/EoAZXYXxG3v7+I33J8flh6iV4dPHlqI0zuvQCV70XEKFNFMGAlfyc5f7I9hhAWU2snfFMMyi0L/lLihH/MyiUyR0DMWrlTC8PD9PH+LZBzQ6pndFHfqmZgBUyACUoA/e066qlgxowNs9SsGCLWBz2GBY380aicz8VpZLqJ+No8rpWJwrgHNV51AjATfIN1XtvWUuL/WyNyXON5s5+VLZQFSx6Jii3b9h/W1rNCjiUggcMzPqJ4cud+8G/d43LZKFAUiFrRYqBJu897U12dzI7+MGL4ntKz/4v7UX0J6UcUhOrZcqPdNN4/TXQvCN2G6XkCXPfSe+W1qIBiWNZ4p5KOQjSGu7KP3UfUsQMgGI9QB70GdP4QuD9WuTePQy0yF+fG2sNGyLyX0NyKHuo95T2c= Leon@LeonMBP-Ci7.local"
        ];
      };
    };

    nix.settings.trusted-users = [ "freddy" "leon" ];

    security.sudo.wheelNeedsPassword = false;

    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    networking.firewall.allowedTCPPorts = [ 22 ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    system.stateVersion = "25.11";
  };

  flake.nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      consoleEnv
      server
      serverHardware
    ];
  };
}
