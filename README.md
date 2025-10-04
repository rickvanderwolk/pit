# pit

Simple one-liner scripts to configure your Raspberry Pi directly, without downloads.

## 📖 Table of Contents

- [Usage](#-usage)
- [Available Configurations](#-available-configurations)

## 🚀 Usage

Run directly from GitHub without cloning:

```bash
# Run a single configuration:
curl -sSL https://raw.githubusercontent.com/rickvanderwolk/pit/main/run.sh | bash -s wifi-powersave-off

# Run multiple configurations:
curl -sSL https://raw.githubusercontent.com/rickvanderwolk/pit/main/run.sh | bash -s wifi-powersave-off ssh-boost

# Run all available configurations:
curl -sSL https://raw.githubusercontent.com/rickvanderwolk/pit/main/run.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/rickvanderwolk/pit.git
cd pit
./run.sh wifi-powersave-off ssh-boost
```

## 📋 Available Configurations

- **`ssh-boost`** - Boost SSH service priority (improves SSH responsiveness)
- **`wifi-powersave-off`** - Disable WiFi power saving (prevents connection dropouts)
