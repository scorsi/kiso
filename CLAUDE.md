# CLAUDE.md

Guidance for Claude Code in this repo. See [README.md](README.md) for what it is.

- **Public repo.** No host names, domains, tailnet names, IPs, personal paths, identities or
  secrets, even in comments: those are values of the consuming flake. Check with
  `gitleaks dir .` and a read before pushing.
- **Dendritic pattern**: one feature = one file under `modules/` declaring
  `flake.modules.<class>.<name>`; options under `kiso.*` (`modules/meta/options.nix`). External
  modules come from `kisoInputs` (kiso's own inputs), not from the consumer's `inputs`.
- **Comments: English, why not what.** User-facing runtime strings stay in French.
- **Checks**: `nix fmt`, `nix flake check` (builds `example.nix`'s darwin host on macOS). A change
  meant for a consumer is tested there with `--override-input scorsi-kiso path:…` before pushing.
