# Example hosts, only for kiso's own `nix flake check` (never exported): every feature, on a darwin
# and a NixOS machine, with placeholder values. A consuming flake does the same with its own.
{ config, kisoInputs, ... }:
let
  inherit (config.flake.modules) darwin nixos homeManager;
  user = config.kiso.owner.name;
  home = [
    homeManager.fish
    homeManager.nushell
    homeManager.ssh
    homeManager.git
    homeManager.cli
    homeManager.pay-respects
    homeManager.tmux
    homeManager.theme
    homeManager.kanna
  ];
in
{
  kiso = {
    owner = {
      name = "example";
      fullName = "Example User";
      email = "example@example.org";
    };
    configDir = "nix-config";
    stateVersions = {
      darwin = 6;
      nixos = "26.05";
      homeManager = "26.05";
    };
  };

  flake.darwinConfigurations.example-mac = kisoInputs.nix-darwin.lib.darwinSystem {
    modules = [
      darwin.nix
      darwin.owner
      darwin.home-manager
      darwin.fish
      darwin.homebrew
      darwin.defaults
      darwin.secrets
      {
        home-manager.users.${user}.imports = home ++ [ homeManager.kanna-dev ];
        nixpkgs.hostPlatform = "aarch64-darwin";
        system.stateVersion = config.kiso.stateVersions.darwin;
      }
    ];
  };

  flake.nixosConfigurations.example-linux = kisoInputs.nixpkgs.lib.nixosSystem {
    modules = [
      nixos.nix
      nixos.owner
      nixos.home-manager
      nixos.fish
      nixos.secrets
      {
        home-manager.users.${user}.imports = home;
        nixpkgs.hostPlatform = "aarch64-linux";
        boot.loader.grub.devices = [ "nodev" ];
        fileSystems."/" = {
          device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
        };
        system.stateVersion = config.kiso.stateVersions.nixos;
      }
    ];
  };
}
