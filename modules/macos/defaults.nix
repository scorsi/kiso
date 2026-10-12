# macOS settings (System Settings equivalents), applied on every switch.
# What nix-darwin doesn't cover: `system.defaults.CustomUserPreferences`.
{ config, ... }:
let
  owner = config.kiso.owner.name;
in
{
  flake.modules.darwin.defaults = {
    # Ctrl+Space is the tmux prefix: free it from "previous input source" (symbolic hotkey 60).
    # Done with PlistBuddy because CustomUserPreferences would replace the whole
    # AppleSymbolicHotKeys dict, wiping every other shortcut.
    system.activationScripts.postActivation.text = ''
      plist=/Users/${owner}/Library/Preferences/com.apple.symbolichotkeys.plist
      if [ "$(sudo -u ${owner} /usr/libexec/PlistBuddy -c 'Print :AppleSymbolicHotKeys:60:enabled' "$plist" 2>/dev/null)" = true ]; then
        echo "kiso: raccourci Ctrl+Espace (source de saisie) désactivé"
        sudo -u ${owner} /usr/libexec/PlistBuddy -c 'Set :AppleSymbolicHotKeys:60:enabled false' "$plist"
        sudo -u ${owner} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      fi
    '';

    system.defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false; # key repeat instead of accent picker
        NSDocumentSaveNewDocumentsToCloud = false;
      };

      finder = {
        AppleShowAllFiles = true;
        ShowPathbar = true;
        FXPreferredViewStyle = "Nlsv"; # list view
        FXEnableExtensionChangeWarning = false;
      };

      dock = {
        autohide = true;
        show-recents = false;
      };

      # Server: macOS updates are done by hand, after a test switch.
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

      # No .DS_Store files on network and USB volumes (external drive).
      CustomUserPreferences."com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };
  };
}
