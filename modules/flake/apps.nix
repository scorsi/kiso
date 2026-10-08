# Flake apps, via `nix run .#<name>` in the consuming flake:
#   switch [flags] → rebuild this Mac (its host name) + diff generations (sudo asked by darwin-rebuild)
#   check [flags]  → nix flake check
# Extra flags (e.g. `--override-input <input> path:…`) are passed to the Nix commands.
#   fmt    → nix fmt
{ lib, kisoInputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    lib.optionalAttrs (lib.hasSuffix "darwin" system) {
      apps = {
        switch = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "switch" ''
              set -euo pipefail
              repo=$(${pkgs.git}/bin/git rev-parse --show-toplevel)
              host=$(/bin/hostname -s)
              before=$(readlink -f /run/current-system)

              # Fetch the inputs as the user first: darwin-rebuild evaluates as root, without the
              # user's SSH agent (private inputs over git+ssh), and then finds them in the store.
              nix flake archive "$repo" "$@" >/dev/null

              log=$(mktemp -t darwin-switch-XXXXXX.log)
              echo "Journal : $log"

              sudo ${
                kisoInputs.nix-darwin.packages.${system}.darwin-rebuild
              }/bin/darwin-rebuild switch --flake "$repo#$host" "$@" 2>&1 | tee "$log"

              after=$(readlink -f /run/current-system)
              if [ "$before" != "$after" ]; then
                echo "--- nvd diff ---"
                ${pkgs.nvd}/bin/nvd diff "$before" "$after"
              else
                echo "Pas de changement de génération."
              fi
            ''
          );
        };

        check = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "check" ''
              set -euo pipefail
              repo=$(${pkgs.git}/bin/git rev-parse --show-toplevel)
              exec nix flake check "$repo" "$@"
            ''
          );
        };

        fmt = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "fmt" ''
              set -euo pipefail
              repo=$(${pkgs.git}/bin/git rev-parse --show-toplevel)
              exec nix fmt "$repo"
            ''
          );
        };
      };
    };
}
