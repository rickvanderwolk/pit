# pit

Simple one-liner scripts to configure your Raspberry Pi directly, without downloads.

## 📖 Table of Contents

- [Usage](#-usage)
- [Available Configurations](#-available-configurations)

## 🚀 Usage

Run directly from GitHub without cloning:

```bash
# Run a single configuration:
curl -sSL https://raw.githubusercontent.com/rickvanderwolk/pit/main/run.sh | bash -s disable-wifi-powersave

# Run multiple configurations:
curl -sSL https://raw.githubusercontent.com/rickvanderwolk/pit/main/run.sh | bash -s disable-wifi-powersave enable-ssh-boost

# Run all available configurations:
curl -sSL https://raw.githubusercontent.com/rickvanderwolk/pit/main/run.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/rickvanderwolk/pit.git
cd pit
./run.sh disable-wifi-powersave enable-ssh-boost
```

## 📋 Available Configurations

### Security
- **`enable-auto-security-updates`** - Enable automatic security updates (auto-reboot at 03:00 if needed)
- **`enable-fail2ban`** - Install & configure fail2ban for SSH protection
- **`enable-firewall`** - Setup UFW firewall (SSH + web ports: 80, 443, 3000, 5000, 8000, 8080)

### Performance
- **`disable-bluetooth`** - Disable bluetooth service to save resources
- **`disable-wifi-powersave`** - Disable WiFi power saving (prevents connection dropouts)
- **`enable-ssh-boost`** - Boost SSH service priority (improves SSH responsiveness)

### Maintenance
- **`enable-auto-cleanup`** - Setup automatic cleanup of packages and logs (weekly)
- **`fix-locale`** - Fix locale warnings (generate en_US.UTF-8)
