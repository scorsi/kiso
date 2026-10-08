# Homebrew, fully declarative.
#  - nix-homebrew installs and pins Homebrew itself.
#  - nix-darwin (`homebrew.*`) manages what it installs.
#  - `cleanup = "zap"`: any cask/formula absent from the list is uninstalled on switch,
#    including its config files. Removing an app = removing its line.
#  - The lists themselves (`homebrew.casks`, `.brews`, `.masApps`) are per host: set them in the
#    consuming flake, e.g. `homebrew.casks = [ "utm" ];`.
{ config, kisoInputs, ... }:
let
  owner = config.kiso.owner.name;
in
{
  flake.modules.darwin.homebrew = {
    imports = [ kisoInputs.nix-homebrew.darwinModules.nix-homebrew ];

    nix-homebrew = {
      enable = true;
      user = owner;
      # Adopts an existing Homebrew install instead of failing.
      autoMigrate = true;
      # Only declared taps (`brew tap` by hand is rejected).
      # homebrew/core and homebrew/cask go through Homebrew's JSON API: no need to clone them.
      mutableTaps = false;
      taps = { };
    };

    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
        # No implicit updates: versions move when decided explicitly.
        autoUpdate = false;
        upgrade = false;
      };
    };
  };
}
