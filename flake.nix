{
  description = "Freddy's flake for everything";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";

    # my own tooling to simplyfy downloads
    reloc8 = {
      url = "github:freddy0506/reloc8";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # restructuring my flake
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
  };

  outputs = { flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        ./modules/Thinkpad.nix
        ./modules/helix.nix
        ./modules/nixvim.nix
        ./modules/desktopEnv.nix
        ./modules/consoleEnv.nix
        ./modules/syncthing.nix
        ./modules/hardware.nix
      ];
    };
}
