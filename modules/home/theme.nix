# Catppuccin Mocha everywhere: every tool enabled and supported by catppuccin/nix
# (bat, delta, fish, starship, tmux, btop, fzf…) gets the theme.
{ kisoInputs, ... }:
{
  flake.modules.homeManager.theme = {
    imports = [ kisoInputs.catppuccin.homeModules.catppuccin ];

    catppuccin = {
      enable = true;
      flavor = "mocha";
      # Neovim keeps its own catppuccin plugin (kanna, lua/plugins/catppuccin.lua).
      nvim.enable = false;
    };
  };
}
