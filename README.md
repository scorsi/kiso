# kiso (基礎)

The foundation: a common base for nix-darwin, NixOS and home-manager machines, shipped as a
[flake-parts](https://flake.parts/) module in the
[dendritic pattern](https://github.com/mightyiam/dendritic). It brings options (`kiso.*`) and
features (`flake.modules.<darwin|nixos|homeManager>.<name>`); the consuming flake brings the
values and the hosts.

## Using it

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    flake-parts.url = "github:hercules-ci/flake-parts";
    kiso = {
      url = "github:scorsi/kiso";
      inputs.nixpkgs.follows = "nixpkgs"; # and any other input you share with it
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.kiso.flakeModules.default
        ./modules # your own features, values and hosts
      ];
    };
}
```

Then set the values (`kiso.owner`, `kiso.configDir`, `kiso.stateVersions`) and declare hosts that
import features by name: `config.flake.modules.darwin.fish`, `homeManager.git`… See
[`example.nix`](example.nix), which kiso's own `nix flake check` builds.

## Options

| Option               | What it is                                                                  |
| -------------------- | --------------------------------------------------------------------------- |
| `kiso.owner`         | the primary user: name, full name, email, FIDO2 SSH keys (login and commit signing) |
| `kiso.configDir`     | where the consuming flake is cloned, relative to home (`drs` rebuilds from there) |
| `kiso.reposDir`      | where clones of other repos live (`repositories` by default; kanna's live clone) |
| `kiso.stateVersions` | `darwin`, `nixos`, `homeManager` state versions                             |

## Features

| Class       | Features                                                                         |
| ----------- | -------------------------------------------------------------------------------- |
| darwin      | `nix`, `owner`, `home-manager`, `fish`, `secrets`, `defaults`, `homebrew` (mechanism; lists per host) |
| nixos       | `nix`, `owner`, `home-manager`, `fish`, `secrets`                                |
| homeManager | `fish`, `nushell`, `git`, `ssh`, `cli`, `tmux`, `theme`, `pay-respects`, `kanna`, `kanna-dev` |

`secrets` is only the sops-nix wiring (decrypt with the host's SSH key); the secrets and their
`.sops.yaml` belong to the consumer. Per-host SSH settings (agent forwarding, shared connections)
too: add `programs.ssh.settings."<hosts>"` blocks in a feature of your own.

Flake plumbing: supported systems, the `darwinConfigurations` option, `nix fmt`, `nix develop`
(Nix linters, sops, age), checks that build every host of the current system, and the apps
`switch` (darwin-rebuild + nvd diff), `check`, `fmt`.

## Developing it

From a consuming flake, without pushing:

```bash
nix run .#switch -- --override-input kiso path:$HOME/repositories/kiso
```

Then push kiso, `nix flake update kiso` in the consumer, switch, commit its `flake.lock`. Here:
`nix fmt`, `nix flake check`.

## Rules

Nothing about a specific machine, network or person lives here: no host names, domains, IPs,
personal paths or secrets. Those are the consumer's values.
