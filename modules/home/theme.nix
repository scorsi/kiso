# Catppuccin Mocha everywhere: every tool enabled and supported by catppuccin/nix
# (bat, delta, fish, starship, tmux, btop, fzf…) gets the theme.
{ kisoInputs, ... }:
{
  flake.modules.homeManager.theme =
    { pkgs, ... }:
    let
      ports = (import kisoInputs.catppuccin { inherit pkgs; }).packages;
    in
    {
      imports = [ kisoInputs.catppuccin.homeModules.catppuccin ];

      catppuccin = {
        enable = true;
        flavor = "mocha";
        # Neovim keeps its own catppuccin plugin (kanna, lua/plugins/catppuccin.lua).
        nvim.enable = false;
        # These modules import files from a built port (IFD): evaluating a Linux host from the
        # Mac would need a Linux builder. Upstream commits the same files in the port sources.
        sources = {
          palette = ports.palette.src;
          starship = "${ports.starship.src}/themes";
        };
      };
    };
}
