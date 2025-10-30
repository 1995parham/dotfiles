# Firefox Configuration

This directory contains Firefox configuration files that are automatically deployed by the `scripts/firefox.sh` script.

## Files

- `profiles.ini` - Defines Firefox profiles (main and personal)
- `main.default.user.js` - Configuration for main profile (parham.alvani@gmail.com)
- `personal.default.user.js` - Configuration for personal profile (1995parham@gmail.com)
- `foxyproxy-settings.json` - FoxyProxy extension configuration

## Profiles

### Main Profile (Default)
- **Email**: parham.alvani@gmail.com
- **Path**: `~/.mozilla/firefox/main.default`

### Personal Profile
- **Email**: 1995parham@gmail.com
- **Path**: `~/.mozilla/firefox/personal.default`

## Switching Profiles

```bash
# Launch specific profile
firefox -P main
firefox -P personal

# Open profile manager
firefox -ProfileManager
```

## FoxyProxy Configuration

The FoxyProxy configuration includes two profiles with automatic URL-based switching:

### Proxies
1. **Direct (No Proxy)** - For direct connections
2. **Local Proxy** - HTTP proxy on 127.0.0.1:2081

### Automatic Switching Rules

Rules are evaluated in order:

1. **Iranian Websites** → Direct (No Proxy)
   - Pattern: `.*\.ir$|.*\.ir/.*`
   - All `.ir` domains bypass the proxy

2. **Local Networks** → Direct (No Proxy)
   - Patterns: `localhost`, `127.0.0.1`, `192.168.*`, `10.*`, `172.16.*`, `*.local`

3. **Everything Else** → Local Proxy
   - Pattern: `*`
   - All other websites use 127.0.0.1:2081

### Installation

1. Install FoxyProxy Standard from: https://addons.mozilla.org/firefox/addon/foxyproxy-standard/

2. Click the FoxyProxy icon → Options

3. Click "Import Settings"

4. Select the configuration file:
   - For main profile: `~/.mozilla/firefox/main.default/foxyproxy-settings.json`
   - For personal profile: `~/.mozilla/firefox/personal.default/foxyproxy-settings.json`

5. The extension will automatically switch between proxy and direct based on the URL

### Testing

To verify the configuration is working:

1. Visit an Iranian website (e.g., `*.ir`) - should go direct
2. Visit an international website - should use proxy
3. Check current mode in FoxyProxy icon (should show pattern mode)

## Configuration Features

- **DuckDuckGo** set as default search engine
- **Two profiles** for different accounts (main and personal)
- **FoxyProxy** automatic proxy switching based on URL patterns
- **Idempotent deployment** - safe to run multiple times

## Deployment

Run the installation script:

```bash
# Using the start.sh script
./start.sh firefox

# Or directly
./scripts/firefox.sh
```

This will:
- Copy all configuration files to the Firefox directory
- Set up both profiles with DuckDuckGo as default search
- Configure FoxyProxy settings
- Display installation instructions
- **Idempotent**: Running multiple times is safe and will only update changed files
