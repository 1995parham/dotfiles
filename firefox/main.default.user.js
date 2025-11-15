// Main Profile Configuration
user_pref("browser.startup.homepage", "about:home");
user_pref("services.sync.username", "parham.alvani@gmail.com");
user_pref("identity.fxaccounts.account.device.name", "Main Profile");
user_pref("browser.ml.chat.provider", "https://gemini.google.com");
user_pref("browser.translations.neverTranslateLanguages", "fa");
user_pref("sidebar.main.tools", "syncedtabs,history,bookmarks");
user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
user_pref("browser.profiles.created", true);
user_pref("browser.profiles.enabled", true);
user_pref("browser.profiles.profile-name.updated", true);

// Search Engine Configuration
user_pref("browser.search.defaultenginename", "DuckDuckGo");
user_pref("browser.search.order.1", "DuckDuckGo");
user_pref("browser.urlbar.placeholderName", "DuckDuckGo");
user_pref("browser.urlbar.placeholderName.private", "DuckDuckGo");

// Modern Privacy and Security Settings
// Based on recommendations from Arkenfox and other privacy guides

// Privacy Settings
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.firstparty.isolate", true);
user_pref("privacy.donottrackheader.enabled", true);

// Security Settings
user_pref("security.mixed_content.block_active_content", true);
user_pref("security.insecure_connection_icon.enabled", true);
user_pref("security.ssl.errorReporting.enabled", false);

// Telemetry Settings
user_pref("toolkit.telemetry.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);

// Dark Mode Settings
user_pref("ui.systemUsesDarkTheme", 1); // Force dark mode
user_pref("browser.theme.dark-private-windows", true); // Dark mode for private windows
user_pref("layout.css.prefers-color-scheme.content-override", 0); // 0 = dark, 1 = light, 2 = system
user_pref("browser.in-content.dark-mode", true); // Dark mode for about: pages
