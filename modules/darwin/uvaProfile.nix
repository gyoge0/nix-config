{ ... }:
{
  flake.modules.darwin.uvaProfile =
    { config, ... }:
    {
      # Configure agenix secret
      age.secrets.uva-profile = {
        file = ../../secrets/uva-profile.mobileconfig.age;
        mode = "0600";
        owner = "root";
        group = "wheel";
      };

      # System activation scripts
      system.activationScripts.extraActivation.text = ''
        # Check if secret is available (agenix puts it in /run/agenix by default)  
        if [[ -f "${config.age.secrets.uva-profile.path}" ]]; then
          echo "UVA Profile secret is available at ${config.age.secrets.uva-profile.path}"
          
          # Copy to user-owned location with correct extension
          mkdir -p /Users/gyoge/.config/profiles
          cp "${config.age.secrets.uva-profile.path}" /Users/gyoge/.config/profiles/uva-profile.mobileconfig
          chown gyoge /Users/gyoge/.config/profiles/uva-profile.mobileconfig
          # todo: fix the profile
          # open /System/Library/PreferencePanes/Profiles.prefPane /Users/gyoge/.config/profiles/uva-profile.mobileconfig
        else
          echo "Warning: UVA Profile secret not found at ${config.age.secrets.uva-profile.path}"
        fi
      '';
    };
}
