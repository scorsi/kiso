{
  description = "kiso (基礎, the foundation) — common base for nix-darwin, NixOS and home-manager, as a flake-parts module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Auto-loads every .nix file under ./modules as a flake-parts module.
    import-tree.url = "github:vic/import-tree";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Installs and pins Homebrew itself (the lists stay with nix-darwin's `homebrew.*`).
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Catppuccin theme applied to every supported tool (bat, delta, fish, tmux…).
    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Encrypted secrets, decrypted at activation with the host's SSH key.
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim and its config (the `kanna` feature). The owner's own flakes are prefixed `scorsi-`
    # among the inputs, to tell them apart from external ones at a glance.
    scorsi-kanna = {
      url = "github:scorsi/kanna";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.flakeModules
        # kiso checks itself the way a consumer uses it, on the example hosts below.
        (import ./flake-module.nix inputs)
        ./example.nix
      ];

      flake.flakeModules.default = import ./flake-module.nix inputs;
    };
}
