{ pkgs, ... }:
let
  # Helpers for policy preferences.
  #   lock-*    : set the value AND grey it out (user can't change)
  #   setDefault: set as the default, but user CAN change in about:config
  lock-false = {
    Value = false;
    Status = "locked";
  };
  # Kept for convenience — use for any pref you want force-ON: `= lock-true;`.
  # deadnix: skip
  lock-true = {
    Value = true;
    Status = "locked";
  };
  setDefault = v: {
    Value = v;
    Status = "default";
  };
in
{
  # Firefox Developer Edition, policies-only. We do NOT manage a profile here:
  # Dev Edition insists on its own `dev-edition-default` profile, and a
  # home-manager-managed named profile breaks its profile resolution ("Your
  # Firefox profile cannot be loaded"). Everything is done via enterprise
  # policies instead, which apply to whatever profile Firefox uses.
  #
  # Caveat: default search engine can't be set this way — the SearchEngines
  # policy is Firefox ESR only, not Dev Edition. Set it once in Settings.
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      SearchBar = "unified";

      # Home + startup page. StartPage = "homepage" shows it on launch.
      # Locked = true forces it (overrides any homepage already in your
      # profile's prefs.js); set false to allow changing it in Settings.
      Homepage = {
        URL = "https://search.nixos.org";
        StartPage = "homepage";
        Locked = true;
      };

      Preferences = {
        # --- privacy / no-sponsored (locked) ---
        "extensions.pocket.enabled" = lock-false;
        "browser.newtabpage.pinned" = {
          Value = "";
          Status = "locked";
        };
        "browser.topsites.contile.enabled" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;

        # --- moved here from the old managed profile (set as defaults) ---
        "browser.aboutConfig.showWarning" = setDefault false;
        "browser.compactmode.show" = setDefault true;
        "widget.use-xdg-desktop-portal.file-picker" = setDefault 1;
        # opinionated (from the thread) — flip/remove to taste:
        "signon.rememberSignons" = setDefault false; # no password saving
        "browser.cache.disk.enable" = setDefault false; # RAM-only cache
        "widget.disable-workspace-management" = setDefault true; # macOS no-op
        # mousewheel.* may be ignored by the Preferences policy allowlist;
        # kept for when/if it's honored (aggressive 20x scroll):
        "mousewheel.default.delta_multiplier_x" = setDefault 20;
        "mousewheel.default.delta_multiplier_y" = setDefault 20;
        "mousewheel.default.delta_multiplier_z" = setDefault 20;
      };

      # Extension keys are the add-on GUID (AMO API: .../addon/<slug>/ -> .guid).
      # GUID must match the XPI or Firefox refuses the install.
      ExtensionSettings = {
        # Vimium — vim-style keyboard navigation
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
