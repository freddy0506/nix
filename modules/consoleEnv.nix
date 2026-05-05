{
  flake.nixosModules.consoleEnv = {pkgs, ...}: {
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

    environment.variables = {
      TERM="xterm-256color";
    };

    programs.bash.enable = true;

    # may change to zsh
    users.defaultUserShell = pkgs.bash;

    # still dont know wich one is used
    programs.zoxide.enableBashIntegration = true;

    environment.systemPackages = with pkgs; [
      # basics
      git
      bat # cat with wings
      wget
      delta # git diff but better
      unzip
      ripgrep # epic grep alternative (rg)
      powertop # make laptop go ....................... (very long)
      pywalfox-native# make firefox go color

      # helpfull tools
      jq # to format json
      fzf # search for files in a fuzzy way
      dua # analyse disk file size
      tree # to list deeper levels
      htop # to see laptop go wrrrrrrrr
      alsa-utils # for sound stuff (alsamixer)
      dragon-drop
      libqalculate # gives qalc to calculate stuff

      # not shure wich one of these is used
      # probably z-lua becaus it is infront in the list
      z-lua
      zoxide
      kanshi

      # not helpfull tools
      sl # train go chuuut chuuuuuuut
      yt-dlp # to download everything I want from the internet
      cmatrix # hacker go tip-tip-tip matrix go booom

      # language compilers/tools
      gcc
      typst
      python3

      # rust stuff
      cargo
      rustc
      bacon # keep rust compiled
      rusty-man # manual for rust functions

      # I dont have a editor that supports this :(
      teamtype # prev. ethersync (for typing together)

      filen-cli # to sync files the better way

      # stuff that may be important
      vim # for extreme cases, so I dont have to use nano
      wl-clipboard # for better clipboard integration
      libimobiledevice # connect to apple devices
      swi-prolog

    ];
  };
}
