{self, inputs, ...}: {
  flake.nixosModules.server = {

      # Create a mumble Server as a chat alternative
      services.murmur = {
        enable = true;
        password = "Bildungsweg3004";
        openFirewall = true;
      };
  };

  flake.nixosModules.serverHardware = {modulePath, pkgs, ...}: {
    imports = [
      (modulePath + "/profiles/qemu-guest.nix")
    ];

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

    users.users = {
      root.hashedPassword = "!"; # Disable root login
      freddy = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvq9MAgQSDBRNJcahIyhtlMo8LKvOHOMToQPMv3Tyz6XouHYxdjNsssz/WI+nKwJlZa631Inj2dBDjxDo5FAoG5z4L+3t+5DL8r17gtYYapvZbZSG9dVN8nfs8LaRLLZWiezmyv6l5dRew49yhGB8Cn5qnMzC61xdDjgtbdMmaMHBmFpmd9D7I98Xm2jLhEnnubTK41b+HL5Ul/bhrI1VPX2ocr3imjyqdCrJiz6JTcc5K+eQnjIGXHC5hf6hY24BKW8Z1+PWto60q+ZV5Jqnd+QAU5174IVlpWDhbWFaYqfIowuqujvtmSJ3ZbY12baBeVtaLkqDnnVmHLG5kJJ2+acW8Fjncvbmud+LszMGQDoiJdmzGTVsRypKQ88F+zHxzNx8qS0PNt/fLV2l1atG8OVc6PaOXebjp4XKfNnr8aI3SaLPc2/Q9XCOzQcd+lx2QEEIfyjAbvin4E7jZxwj9DoOaQLK1tSmC05rwvpBUUrxN38JS7LofAjYT5CMONws= freddy@freddyThinkpad"
        ];
      };
    };

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
