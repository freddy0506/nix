{
  description = "Freddy's flake for everything";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-old.url = "github:nixos/nixpkgs?ref=nixos-25.11";

    pferdehofAPI.url = "/home/freddy/dev/Pferdehof/pferdehofAPI";
    
    pferdehofWeb = {
      url =  "/home/freddy/dev/Pferdehof/PferdehofMachine";
      inputs.nixpgks.follows = "nixpkgs";
      inputs.pferdehofAPI.follows = "pferdehofAPI";
    };


    # my own tooling to simplyfy downloads
    reloc8 = {
      url = "github:freddy0506/reloc8";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # restructuring my flake
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    # restructuring my flake
    teamtype-lsp = {
      #url = "github:nonscalable/teamtype-lsp";
      url = "/home/freddy/dev/teamtype-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
    };

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
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
