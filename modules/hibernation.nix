{
  flake.nixosModules.hibernation = {
    # create Swap file
    swapDevices = [{
      device = "/var/lib/swapfile";
      size = 32*1024; # 32 GB
    }];

    # Hibernation
    boot.kernelParams = ["button.lid_init_state=open" "resume_offset=12339200" "mem_sleep_default=deep"];
    boot.resumeDevice = "/dev/disk/by-uuid/e3d3f73a-879f-44e9-a066-c6fec6023e70";

    # disbable lidswitch
    services.logind.settings.Login.HandleLidSwitch = "ignore";

    services.upower = {
      enable = true;
      ignoreLid = true;
    };

    # Hibernate on power button pressed
    services.logind.settings.Login.HandlePowerKey = "suspend-then-hibernate";
    services.logind.settings.Login.HandlePowerKeyLongPress = "poweroff";

    systemd.sleep.settings.Sleep = {
      HibernateDelaySec = "35m";
    };

    # disable litswitch as wakeup
    systemd.services.deactivate-lidswitch = {
      script = ''
        echo LID > /proc/acpi/wakeup
      '';
      wantedBy = [ "multi-user.target" ];
      before = [ "getty.target" ];
    };
  };
}
