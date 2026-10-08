# SSH client + agent, with FIDO2 key support (ed25519-sk).
#
# macOS ships its own ssh/ssh-agent, built WITHOUT hardware key support:
# replaced here by nixpkgs'. The agent runs as a LaunchAgent (macOS) or a
# systemd user service (NixOS). An incoming SSH session with a forwarded agent
# (`ssh -A`) keeps the client's agent: home-manager doesn't override it.
#
# Per-host settings (agent forwarding, shared connections) belong to the consuming flake: it adds
# its own `programs.ssh.settings."<hosts>"` blocks next to this one.
{
  flake.modules.homeManager.ssh =
    { pkgs, ... }:
    {
      services.ssh-agent = {
        enable = true;
        package = pkgs.openssh;
      };

      programs.ssh = {
        enable = true;
        package = pkgs.openssh;
        enableDefaultConfig = false;
        # Raw OpenSSH directives (ssh_config(5)), one block per host pattern.
        settings = {
          "*" = {
            # The key used (hardware key handle) is added to the agent:
            # git can then sign with it, and `ssh -A` forwards it.
            AddKeysToAgent = "yes";
            # Avoids the "agent refused operation" noise when the agent tries the
            # FIDO2 identity whose device is absent before falling back to the plugged-in one.
            LogLevel = "ERROR";
          };
        };
      };
    };
}
