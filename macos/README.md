# macOS Installation

Upon launching macOS for the first time, your experience may be unique from mine.
Updates to the operating system from Apple and specific hardware configurations
could present minor variations from the steps outlined here.

- Select desired language and click the right arrow.
- Select country and click "Continue".
- Click "Customized Settings".
- Confirm preferred language.
- Confirm location.
- Confirm dictation (required).
- Click "Not Now" for Accessibility options.
- If prompted, choose "My computer does not connect to the internet".
- Click "Continue" and "Continue" again if requested to connect to the internet.
- Click "Continue" for Data & Privacy notification.
- Click "Not Now" for the Migration Assistant.
- Click "Set Up Later" to bypass the Apple ID requirement.
- Confirm by clicking "Skip".
- Click "Agree" to the Terms and Conditions.
- Confirm by clicking "Agree".
- Create a local computer account. This should be a generic name, such as
  "Parham", and should include a very strong password which
  you can remember. I **never provide any password hint** to this screen. Click
  "Continue" when finished.
- Do not enable "Location Service" and click "Continue".
- Confirm choice by clicking "Don't Use".
- Select your desired time zone and click "Continue".
- Deselect all analytics options and click "Continue".
- Click "Set Up Later" to bypass "Screen Time" settings.
- Disable Siri and click "Continue".
- Choose your desired screen mode and click "Continue".

Since you have no internet connectivity, there should be no notifications of pending updates.

- Launch "System Settings" from the Dock.
- Select "Wi-Fi" from the left menu and disable it.
- Disable both "Ask to join networks" and "Ask to join hotspots".
- Select Bluetooth from the left menu and disable it.

I want to configure the operating system's firewall, This is only responsible for the way the
operating system treats incoming connections.

- Select "Network" from the left menu and select "Firewall".
- Enable the Firewall and click "Options".
- Disable "Automatically allow built-in software to receive...".
- Disable "Automatically allow downloaded signed software to receive...".
- Enable "Stealth mode".
- Click "OK".

I like to disable all notifications possible. I do not want sensitive applications,
which will be installed later, to display content on the screen when I am not around or
when someone is over my shoulder.

- Select "Notifications" from the left menu.
- Change "Show previews" to "Never".
- Disable "Allow notifications when the device is sleeping".
- Disable "Allow notifications when the screen is locked".
- Disable "Allow notifications when mirroring or sharing the display".
- Open each application, disable notifications, and click the arrow to return.

I also prefer to disable any unnecessary sounds with the following steps.

- Select "Sound" from the left menu.
- Change "Alert volume" to the minimum setting.
- Disable "Play sound on startup".
- Disable "Play user interface sound effects".
- Disable "Play feedback when volume is changed".

The following should already be disabled by default, but let's make sure.

- Select "General" from the left menu.
- Select "AirDrop & Handoff".
- Disable "Allow Handoff between this Mac and your iCloud devices".
- Confirm AirDrop is set to "No One".
- Select "General" from the left menu.
- Select "Sharing".
- Confirm all options are disabled.
- Select "Siri & Spotlight" from the left menu.
- Confirm "Ask Siri" is disabled.

If you want to truly ensure that Siri is not listening in on your activity, you can conduct
the following, which may be redundant.

- Select "Siri & Spotlight" from the left menu.
- Click "Siri Suggestions & Privacy".
- Click each option and disable all toggles, then click "Done".

I do not like Apple searching through and
indexing my documents. I do not want macOS to possess a database with my sensitive
content.

- Select "Siri & Spotlight" from the left menu.
- Disable all options within the Spotlight area.
- Click "Spotlight Privacy".
- Click the "+" in the lower-left.
- Change the dropdown field to "Macintosh HD".
- Click "Choose", confirm with "OK", and click "Done".
- `sudo mdutil -i off /`
- `sudo mdutil -E /`

Let's conduct a few more configurations within System Settings.

- Select "Privacy & Security" from the left menu.
- Select "Analytics & Improvements" and verify all are disabled.
- Select "Privacy & Security" from the left menu.
- Select "Apple Advertising" and disable "Personalized Ads".
- Select "General" from the left menu.
- Select "Software Update".
- Click the "i" in the circle and deselect everything.

Apply full-disk encryption through Apple's FileVault with
the following steps

- Select "Privacy & Security" from the left menu.
- Click "Turn On..." next to "FileVault".
- Enter your system password and click "Unlock".
- Choose "Create a recovery key and do not use my iCloud account".
- Document this recovery key somewhere safe and click "Continue".

Customize shortcuts through System Settings:

- Select "Keyboard" from the left menu.
- Click the "Keyboard Shortcuts...".
- Disable all "Input Sources" shortcuts.
- Disable all "Spotlight" shortcuts.
- Change "Mission Control → Mission Control → Move left a space" to "CMD + h"
- Change "Mission Control → Mission Control → Move left a space" to "CMD + l"
