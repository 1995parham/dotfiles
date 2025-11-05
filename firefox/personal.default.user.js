// Personal Profile Configuration
user_pref("browser.startup.homepage", "about:home");
user_pref("services.sync.username", "1995parham@gmail.com");
user_pref("identity.fxaccounts.account.device.name", "Personal Profile");

// Search Engine Configuration
user_pref("browser.search.defaultenginename", "DuckDuckGo");
user_pref("browser.search.order.1", "DuckDuckGo");

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

