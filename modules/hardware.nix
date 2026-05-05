{inputs, ...}: {
  flake.nixosModules.hardware = {pkgs, ...}: {
    
    services.printing.enable = true;
    # use newest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;
    imports =
      [ # Include the results of the hardware scan.
      ];

    # create Swap file
    swapDevices = [{
      device = "/var/lib/swapfile";
      size = 32*1024; # 32 GB
    }];

    # Hibernation
    boot.kernelParams = ["button.lid_init_state=open" "resume_offset=12339200" "mem_sleep_default=deep"];
    boot.resumeDevice = "/dev/disk/by-uuid/e3d3f73a-879f-44e9-a066-c6fec6023e70";
    services.system76-scheduler.enable = true;
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };
    services.tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 1;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 1;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "balanced";
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 81;
      };
    };

    services.logind.settings.Login.HandleLidSwitch = "ignore";
    services.upower = {
      enable = true;
      ignoreLid = true;
    };

    networking.wireless.iwd.settings = {
      Scan = {
        DisablePeriodicScan = true;
      };
    };

    # Hibernate on power button pressed
    services.logind.settings.Login.HandlePowerKey = "suspend-then-hibernate";
    services.logind.settings.Login.HandlePowerKeyLongPress = "poweroff";

    systemd.sleep.settings.Sleep = {
      HibernateDelaySec = "10m";
    };

    # disable litswitch as wakeup
    systemd.services.deactivate-lidswitch = {
      script = ''
        echo LID > /proc/acpi/wakeup
      '';
      wantedBy = [ "multi-user.target" ];
      before = [ "getty.target" ];
    };

    /*
    programs.fish.enable = true;
    programs.bash = {
        interactiveShellInit = ''
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        '';
      };
     */

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nix.settings.auto-optimise-store = true;
    boot.supportedFilesystems = [ "ntfs" ];


    networking.nameservers = ["8.8.8.8" "8.8.4.4"];# [ "141.83.100.100" "141.83.99.99" "1.1.1.1" ];

    services.mullvad-vpn.enable = true;
    services.mullvad-vpn.package = pkgs.mullvad-vpn;

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 5;
    boot.loader.efi.canTouchEfiVariables = true;

    # Garbage collector
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-generations +10";
    };

    networking.hostName = "Thinkpad"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openconnect ];
    };

    # Set your time zone.
    time.timeZone = "Europe/Berlin";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    hardware.sensor.iio.enable = true;

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };


    # Enable sound with pipewire.
    # services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.freddy = {
      isNormalUser = true;
      shell = pkgs.bash;
      description = "freddy";
      extraGroups = [ "docker" "audio" "networkmanager" "wheel" "wireshark" ];
    };


    # for controller support (Xbox)
    hardware.steam-hardware.enable = true;
    programs.gamemode.enable = true;
    services.blueman.enable = true;
    hardware.bluetooth.enable = true;

    environment.systemPackages = with pkgs; [
      #kdePackages.networkmanager-qt
      fprintd # For fingerprint scanner

      networkmanager-openconnect
      openconnect_openssl
      openconnect
      gpclient
    ];
    
    system.stateVersion = "24.05"; # Did you read the comment?
  };
}
