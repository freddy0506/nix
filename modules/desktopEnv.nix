{self,inputs,  ...}: {
  flake.nixosModules.desktopEnv = {pkgs, lib, ...}: {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    # services.displayManager.gdm.enable = true;
    # services.desktopManager.gnome.enable = true;

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        # Add additional package names here
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
        "spotify"
        "claude-code"
      ];

    fonts.enableDefaultPackages = true;
    fonts.packages =  with pkgs; [
      newcomputermodern
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      texlivePackages.libertine
      libertine-g
      inconsolata
    ]; 

    # my greeter
    services.displayManager.ly.enable = true;

    # my hyprland installation
    # want to change because homophobic owners
    /*
    programs.hyprland = {
      # Install the packages from nixpkgs
      enable = true;
      # Whether to enable XWayland
      xwayland.enable = true;
    };*/

    # install cosmic
    # services.desktopManager.cosmic.enable = true;

    services.power-profiles-daemon.enable = false; # needed because of conflict

    # install swayfx
    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
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

    # Install firefox.
    programs.firefox.enable = true;

    # Install Steam (Unfree)
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    environment.systemPackages = with pkgs; [
      st # terminal that supports tmux
      ghostty # termial that does not support tmux
      logseq # For note taking
      wdisplays # mutlidisplayeasymaker
      pavucontrol # Volume control
      kdePackages.dolphin # when you need a ui

      keepassxc # passwords go ************
      qbittorrent # piracy brrrrrr

      spotify # musik go bum-bum-bum
      thunderbird # email go swish
      signal-desktop # message go "hello" -> ****** -> "hello"
      flare-signal
      mattermost-desktop

      mpv # movie go "Do I love him?" ---- 5 hours ----> "yes"
      gimp# make pictures change
      loupe # picture go show
      pdfpc# Present pdfs
      zathura # pdf go show
      inkscape # svg go sg
      grimblast # screen go blink -> picture
      zed-editor # file go exists (with text!)
      libreoffice # wordfile go exits

      filen-desktop # sync homefolder to cloud

      organicmaps # maps go: McDonalds there 
      prismlauncher # minecraft go ■

      reloc8 # Download go in right folder

      mumble
      # for hyperland to work
      eww # PC go pretty (powerbar and workspaces)
      fuzzel # app go open
      swayidle # PC go Zzzzzz
      # hyprlock # PC go 🔒
      # hyprpaper # Background go pretty
      # iio-hyprland # screen go | =>  __
      brightnessctl # brighness go AAAAAAHHHHH (with buttons!)

      inputs.nixpkgs-old.legacyPackages.x86_64-linux.inlyne

      # AI (Sprinkels)
      claude-code

      self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia

      # to send notifications
      libnotify

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
  };
}
