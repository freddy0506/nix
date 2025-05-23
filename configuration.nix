# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nixvim.nix
    ];

  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Add additional package names here
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "spotify"
      "libsciter"
    ];

  # Set alias for updating command
  programs.bash.shellAliases = {
    sysRebuild = "nixos-rebuild switch --flake ~/dev/sys/.# --use-remote-sudo";
    open = "setsid xdg-open";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nix.settings.auto-optimise-store = true;
  boot.supportedFilesystems = [ "ntfs" ];

  fonts.packages = [] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # enable mullvad-vpn
  # for some reason resolved is needed
  /*
  networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    dnsovertls = "true";
  };
  services.mullvad-vpn.enable = true;*/


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Thinkpad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "neo_qwertz";
  };

  # Configure console keymap
  console.keyMap = "neoqwertz";

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };



  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.freddy = {
    isNormalUser = true;
    description = "freddy";
    extraGroups = [ "audio" "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # for controller support (Xbox)
  hardware.steam-hardware.enable = true;
  programs.gamemode.enable = true;
  services.blueman.enable = true;

  # protonGE
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # Install Steam (Unfree)
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Install Syncthing
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "freddy";

    dataDir = "/home/freddy";
    settings = {
      devices = {
        "Phone" = { id = "4LB72HT-MPF4W45-OXB6SLS-WTFCUMK-ZPBVMYC-S56OZMS-BZPEQ4P-TQGQ5AP"; };
      };
      folders = {
        "Passwords" = {
          path = "/home/freddy/Documents/.secret/";
          devices = [ "Phone" ];
        };
      };
      folders = {
        "Bilder" = {
          path = "/home/freddy/Pictures/Handy";
          id = "sm-g556b_jvq5-Bilder";
          devices = [ "Phone" ];
        };
      };
      gui = {
        user = "myuser";
        password = "mypassword";
      };
    };
  };

  # Histowiki test
  # systemd.services.nginx.serviceConfig.ProtectHome = "read-only";
  # systemd.services.nginx.serviceConfig.ReadWritePaths = [ "/home/freddy/dev/dezoom/Olympusscans" ];
  /*
  services.nginx = {
    enable = true;
    user = "freddy";
    virtualHosts."localhost" = {
      basicAuth = { admin = "anatuser"; };
      root = "/home/freddy/dev/dezoom/Olympusscans";
    };
  };*/

  # for emotionDeploy
  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fprintd # For fingerprint scanner
    prismlauncher

    signal-desktop
    thunderbird

    keepassxc
    z-lua
    spotify

    cargo
    rustup
    rustc
    python3

    mpv

    vim
    onlyoffice-desktopeditors
    rnote
    typst
    sqlite
    ethersync

    fzf
    wget
    git
    ripgrep
    sl
    libqalculate
    tmux
    reloc8
    unzip
    yt-dlp

    networkmanager-openconnect
    wl-clipboard # copy from vim

    emotiondayAPI
    gnomeExtensions.caffeine
  ];

  # For fingerprint scanner
  services.fprintd = {
    enable = true;
    /*
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-vfs0090;
    };*/
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
