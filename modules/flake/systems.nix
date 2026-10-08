# Supported systems. (`flake.modules.<class>.<name>`, the option the dendritic pattern relies on,
# is enabled by flake-module.nix.)
{
  systems = [
    "aarch64-darwin" # Apple Silicon Macs
    "aarch64-linux" # NixOS VMs on Apple Silicon
    "x86_64-linux" # PCs, CI
  ];
}
