{
  description = "Freddy's flake for everything";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs-old.url = "github:nixos/nixpkgs?ref=nixos-25.11";

    # my own tooling to simplyfy downloads
    reloc8 = {
      url = "github:freddy0506/reloc8";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my own dictionary tool
    dictui = {
      url = "git+file:///home/freddy/dev/dictui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # restructuring my flake
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
  };

  outputs = { flake-parts, import-tree, ...} @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        (import-tree ./modules)
      ];
    };
}
