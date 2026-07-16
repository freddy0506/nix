{inputs, ...}: {
  flake.nixosModules.hardware = {pkgs, ...}: {
    
    services.printing.enable = true;
    services.printing.drivers = [
      pkgs.brlaser
      pkgs.gutenprint
      pkgs.foomatic-db-ppds
    ];
    services.avahi = {
      enable = true;
      nssmdns4 = true;
    };
    # use newest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;
    imports =
      [ # Include the results of the hardware scan.
      ];


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
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "balanced";
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 81;
      };
    };

    networking.wireless.iwd.settings = {
      Scan = {
        DisablePeriodicScan = true;
      };
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
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # Uncomment the following line if you want to use JACK applications
      # jack.enable = true;
    };

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
