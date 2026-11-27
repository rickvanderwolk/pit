# pit

Simple one-liner scripts to configure your Raspberry Pi directly, without downloads.

## 📖 Table of Contents

- [Usage](#-usage)
- [Available Configurations](#-available-configurations)
- [Read-only (overlay)](#-read-only-overlay)

## 🚀 Usage

Run directly from GitHub without cloning:

```bash
# Run a single configuration:
curl -sSL https://raw.githubusercontent.com/rickvanderwolk/pit/main/run.sh | bash -s disable-wifi-powersave

# Run multiple configurations:
curl -sSL https://raw.githubusercontent.com/rickvanderwolk/pit/main/run.sh | bash -s disable-wifi-powersave enable-ssh-boost
```

Run the base set (firewall, fail2ban, auto security updates, auto cleanup):

```bash
curl -sSL https://raw.githubusercontent.com/rickvanderwolk/pit/main/run.sh | bash -s base
```

Without arguments, `run.sh` only shows the usage and the available scripts; it does not run anything. Name each configuration explicitly.

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
- **`enable-firewall`** - Setup UFW firewall (SSH only, add other ports manually)

### Performance
- **`disable-bluetooth`** - Disable bluetooth service to save resources
- **`disable-wifi-powersave`** - Disable WiFi power saving (prevents connection dropouts; skipped without wifi)
- **`enable-ssh-boost`** - Boost SSH service priority (improves SSH responsiveness)

### Maintenance
- **`enable-auto-cleanup`** - Setup automatic cleanup of packages and logs (weekly)
- **`fix-locale`** - Fix locale warnings (generate en_US.UTF-8)

### Read-only (overlay)
- **`enable-overlay`** - Enable the Overlay File System (root fs in RAM, boot partition read-only)
- **`disable-overlay`** - Disable the Overlay File System
- **`overlay-status`** - Show overlay and boot partition state (now and after reboot)

## 🔒 Read-only (overlay)

The Overlay File System from `raspi-config` protects the SD card against corruption when the power is cut. All writes to the root fs go to RAM and are lost on reboot; the boot partition is mounted read-only. Requires Raspberry Pi OS (Bookworm or later) with more than 256 MB RAM.

```bash
./run.sh enable-overlay    # enable, then: sudo reboot
./run.sh disable-overlay   # disable, then: sudo reboot
./run.sh overlay-status    # show current state
```

Run `enable-overlay` as the last configuration, after all other scripts.

Workflow for changes:

1. `./run.sh disable-overlay`, then `sudo reboot`
2. Make the changes
3. `./run.sh enable-overlay`, then `sudo reboot`

While the overlay is active, `raspi-config` cannot change `/etc/fstab`, so after the first reboot the boot partition is still read-only. Run `disable-overlay` again if `/boot/firmware` must be writable (e.g. for kernel updates via apt). To make it writable temporarily: `sudo mount -o remount,rw /boot/firmware`.

`run.sh` shows a warning when another script is run while the overlay is active.

Automatic updates make little sense with the overlay enabled: installed updates are lost on reboot and fill up RAM in the meantime. `enable-overlay` therefore disables the apt timers (`apt-daily`, `apt-daily-upgrade`); `disable-overlay` re-enables them once the overlay is no longer active. Plan a regular update round instead (overlay off, reboot, `sudo apt full-upgrade`, overlay on, reboot), more often for devices that run a browser.
