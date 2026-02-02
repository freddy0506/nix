{
  flake.nixosModules.syncthing = {
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
  };
}
