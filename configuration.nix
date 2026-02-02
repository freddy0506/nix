# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{

  # use newest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./nixvim.nix
    ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Add additional package names here
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "spotify"
      "obsidian"
    ];

  # create Swap file
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 32*1024; # 32 GB
  }];

  # Hibernation
  boot.kernelParams = ["button.lid_init_state=open" "resume_offset=12339200" "mem_sleep_default=deep"];
  boot.resumeDevice = "/dev/disk/by-uuid/e3d3f73a-879f-44e9-a066-c6fec6023e70";
  powerManagement.enable = true;

  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";

  # Hibernate on power button pressed
  services.logind.settings.Login.HandlePowerKey = "poweroff";
  services.logind.settings.Login.HandlePowerKeyLongPress = "poweroff";

  systemd.sleep.extraConfig = ''
    #SuspendState=mem
    #HibernateMode=shutdown
    HibernateDelaySec=10m
  '';

  # disable litswitch as wakeup
  systemd.services.deactivate-lidswitch = {
    script = ''
      echo LID > /proc/acpi/wakeup
    '';
    wantedBy = [ "multi-user.target" ];
    before = [ "getty.target" ];
  };

  # Set alias for updating command
  programs.bash.shellAliases = {
    sysRebuild = "nixos-rebuild switch --flake ~/dev/sys/.# --sudo";
    open = "setsid xdg-open";
    cat = "bat";
    zq = "zoxide query";
    zathf = pkgs.writeShellScript "openAndClose" ''
      zathura --fork "$@"
    '';
  };

  programs.bash.enable = true;
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

  fonts.packages =  with pkgs; [ nerd-fonts.fira-code nerd-fonts.droid-sans-mono ]; #[] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);networking.nameserver

  # enable mullvad-vpn
  # for some reason resolved is needed
  # [ ];
  networking.nameservers = ["8.8.8.8" "8.8.4.4"];# [ "141.83.100.100" "141.83.99.99" "1.1.1.1" ];
  /*
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  */

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;

  services.displayManager.ly.enable = true;
  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "de";
      variant = "neo_qwertz";
    };
  };

  # Configure console keymap
  console.keyMap = "neoqwertz";

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

  # Install firefox.
  programs.firefox.enable = true;

  # for controller support (Xbox)
  hardware.steam-hardware.enable = true;
  programs.gamemode.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

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
        "Phone" = { id = "V6OAANU-VIJ44MM-D4DUAT5-HYU5FQO-4F6UKOQ-7OTVZYJ-I76GRAF-LMULVQI"; };
        "Server" = { id = "5I4DE3X-NXSBTJY-TRTYCTR-32HZSEL-WTJASPC-P4Y2A4H-65LHRJA-YY5OHQ3"; };
      };
      folders = {
        "Passwords" = {
          path = "/home/freddy/Documents/.secret/";
          devices = [ "Phone" "Server" ];
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
  /*
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };*/

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  users.defaultUserShell = pkgs.bash;
  programs.zoxide.enableBashIntegration = true;
  #programs.zoxide.enableFishIntegration = true;
  environment.systemPackages = with pkgs; [
    #kdePackages.networkmanager-qt
    obsidian
    fprintd # For fingerprint scanner
    bat
    prismlauncher
    st
    kitty
    zathura
    inkscape
    loupe
    organicmaps
    kdePackages.dolphin
    qbittorrent

    signal-desktop
    thunderbird

    keepassxc
    z-lua
    spotify

    grimblast

    cargo
    rustc
    python3
    gcc

    mpv

    vim
    onlyoffice-desktopeditors
    zed-editor
    typst
    sqlite
    teamtype

    fzf
    zoxide
    wget
    git
    bacon
    ripgrep
    rusty-man
    wiki-tui
    dragon-drop
    sl
    jq
    libqalculate
    tmux
    reloc8
    unzip
    yt-dlp
    dua

    networkmanager-openconnect
    openconnect_openssl
    openconnect
    gpclient
    wl-clipboard # copy from vim
    wdisplays
    brightnessctl

    #gnomeExtensions.caffeine
    #gnomeExtensions.lockscreen-extension
    #gnome-tweaks
    hyprpaper
    hyprlock
    iio-hyprland
    fuzzel
    waybar
    swayidle
    eww
    alsa-utils
    pavucontrol
    starship
    libimobiledevice
    helix

    (let pkgs2 = pkgs.extend (final: prev: {
                              gtk4 = prev.gtk4.overrideAttrs (origAttrs: rec {
                                  version = "4.21.4";
                                  src = fetchurl {
                                    url = "mirror://gnome/sources/gtk/${lib.versions.majorMinor version}/gtk-${version}.tar.xz";
                                    hash = "sha256-l9FXD+fekSyFiO85GxhZNm+bOJSlMqjytQnt28fyKIA=";
                                  };
                                  nativeBuildInputs = origAttrs.nativeBuildInputs ++ [ shared-mime-info ];
                                  });
                              });
     in pkgs2.rnote
    )
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  /*
  services.openssh = {
    enable = true;
    ports = [ 5432 ];
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "freddy" ];
    };
  };*/

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
