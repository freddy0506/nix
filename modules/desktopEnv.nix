{
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
        "obsidian"
      ];

    fonts.packages =  with pkgs; [ nerd-fonts.fira-code nerd-fonts.droid-sans-mono ]; 

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
      kitty # termial that does not support tmux
      obsidian # not opensource note taking
      wdisplays # mutlidisplayeasymaker
      pavucontrol # Volume control
      kdePackages.dolphin # when you need a ui

      keepassxc # passwords go ************
      qbittorrent # piracy brrrrrr

      spotify # musik go bum-bum-bum
      thunderbird # email go swish
      signal-desktop # message go "hello" -> ****** -> "hello"

      mpv # movie go "Do I love him?" ---- 5 hours ----> "yes"
      loupe # picture go show
      rnote # pen go /\/\/\/
      zathura # pdf go show
      inkscape # svg go sg
      grimblast # screen go blink -> picture
      zed-editor # file go exists (with text!)
      onlyoffice-desktopeditors # wordfile go exits

      organicmaps # maps go: McDonalds there 
      prismlauncher # minecraft go ■

      reloc8 # Download go in right folder

      # for hyperland to work
      eww # PC go pretty (powerbar and workspaces)
      fuzzel # app go open
      swayidle # PC go Zzzzzz
      hyprlock # PC go 🔒
      hyprpaper # Background go pretty
      iio-hyprland # screen go | =>  __
      brightnessctl # brighness go AAAAAAHHHHH (with buttons!)
    ];
  };
}
