# 🐟 Fish Shell Configuration for macOS

A modern, user-friendly Fish shell configuration optimized for **macOS 10.12+** with Homebrew support.

> **Note:** This is the **macOS-optimized branch**. For CachyOS/Arch Linux, see the [main branch](https://github.com/cachyos/cachyos-fish-config/tree/main).

---

## 📋 System Requirements

- **macOS:** 10.12 (Sierra) or later
- **Current tested version:** macOS 14.x (Sonoma) and 15.x (Sequoia)
- **Fish Shell:** 4.0 or later (recommend 4.4+)
- **Bash:** 3.2+ (pre-installed on macOS)
- **Homebrew:** Latest (no admin rights required)

> ⚠️ **Intel vs Apple Silicon:** Both architectures are fully supported. The installer auto-detects and configures paths appropriately.

---

## 🚀 Quick Start

### Option 1: Automated Installation (Recommended)

```bash
# Clone the repository
git clone https://github.com/cachyos/cachyos-fish-config.git
cd cachyos-fish-config

# Checkout the macOS branch
git checkout macos-config

# Run the interactive installer
./install-macos.sh
```

Then select option **5** for "Full installation".

### Option 2: Preview Changes (Dry-Run Mode)

Before making any changes, see exactly what will be installed:

```bash
./install-macos.sh --dry-run
```

This shows all file copies and installations **without modifying your system**.

### Option 3: Manual Installation

```bash
# 1. Install Fish if not already installed
brew install fish

# 2. Install recommended optional tools
brew install eza bat fastfetch

# 3. Create config directory
mkdir -p ~/.config/fish/conf.d

# 4. Copy configuration files
cp macos-config.fish ~/.config/fish/
cp config.fish ~/.config/fish/
cp conf.d/done.fish ~/.config/fish/conf.d/

# 5. Set Fish as default shell
chsh -s $(which fish)

# 6. Start new Fish session
fish
```

---

## 📦 What Gets Installed

### Core Configuration Files
- `config.fish` - Main configuration (OS-aware)
- `macos-config.fish` - macOS-specific settings and aliases
- `conf.d/done.fish` - Notification plugin for long-running commands

### Optional Tools (Auto-Installed)
| Tool | Purpose | Alternative |
|------|---------|-------------|
| **eza** | Modern file lister (replaces `ls`) | Fallback to standard `ls` |
| **bat** | Syntax highlighter for man pages | Fallback to plain `man` |
| **fastfetch** | System information display | Skipped if not installed |

### Nerd Font (for eza icons)
eza uses `--icons=auto` to show file type icons. These display correctly when your terminal font supports them. If you see `?` placeholder characters, install a Nerd Font:

```bash
# Install via Homebrew
brew install --cask font-jetbrains-mono-nerd-font

# Then set it in your terminal:
# Terminal.app → Settings → Profiles → Font → JetBrains Mono Nerd Font
# iTerm2 → Preferences → Profiles → Text → Font → JetBrains Mono Nerd Font
# Warp → Preferences → Font → JetBrains Mono Nerd Font
```

Other Nerd Font options: `font-meslo-lg-nerd-font`, `font-fira-code-nerd-font`, `font-firamono-nerd-font`.

---

## ✨ Features

### 🎯 Smart Aliases
```fish
# File listing with colors and icons
ls          # Modern listing with eza
la          # Show all files including dotfiles
ll          # Long format listing
lt          # Tree view
l.          # Show only dotfiles

# Navigation
..          # cd ..
...         # cd ../..
....        # cd ../../..

# Color grep
grep, fgrep, egrep
```

### 🍺 Homebrew Management
```fish
brewup      # Update Homebrew and upgrade packages
brewclean   # Remove old versions and cached files
brewdoc     # Run Homebrew doctor for diagnostics
```

### 🔧 macOS Utilities
```fish
# Finder utilities
showfiles   # Show hidden files in Finder
hidefiles   # Hide hidden files in Finder

# System utilities
myip        # Show your public IP address
myips       # Show all local IP addresses
sysinfo     # Display system information
flush       # Flush DNS cache
emptytrash  # Empty Trash
openports   # Show listening network ports

# Quick app launchers
chrome      # Open Google Chrome
safari      # Open Safari
vscode      # Open Visual Studio Code
```

### ⚡ Shell Productivity
```fish
# History with timestamps
history     # Show command history with dates/times

# Bang shortcuts
!!          # Repeat last command
!$          # Use last argument from previous command

# Backup utilities
backup <file>           # Create filename.bak
copy <src> <dst>        # Recursive directory copy
```

### 🔔 Smart Notifications
- Long-running commands trigger notifications when complete
- Only shows notification if terminal window is unfocused
- Configurable minimum duration threshold (default: 10 seconds)
- Works with Kitty, Terminal.app, iTerm2, and more

---

## 🛠️ Installation Script Features

### Interactive Menu System
The `install-macos.sh` script provides an easy-to-use menu:

```
What would you like to do?

  1) Check system status      - View current setup
  2) Check and install deps   - Install missing tools
  3) Backup configuration     - Create timestamped backup
  4) Install new config       - Copy config files
  5) Full installation        - Do everything (recommended)
  6) View installation guide  - Show detailed guide
  7) Exit
```

### Safety Features
- ✅ **Automatic backups** - Previous configs saved to `~/.config/fish/backups/`
- ✅ **Timestamped backups** - Easy to recover specific versions
- ✅ **Installation verification** - Checks that all files installed correctly
- ✅ **Dry-run mode** - Preview changes without modifying system
- ✅ **User prompts** - Asks before installing optional dependencies

### System Status Check
```bash
./install-macos.sh
# Choose option 1 to see:
# - macOS version
# - Fish Shell version
# - Homebrew status
# - Optional tool versions
# - Current configuration paths
```

---

## 📚 Configuration

### Main Files

#### `config.fish` (OS-aware entry point)
```fish
# Automatically loads macos-config.fish on macOS
# Falls back to Linux config if on Linux system
```

#### `macos-config.fish` (Main customization file)
Edit this file to:
- Add custom aliases
- Modify PATH settings
- Disable fastfetch greeting
- Add custom functions
- Configure man page display

### Custom Configuration

Create `~/.fish_profile` to add environment variables:
```bash
# ~/.fish_profile (optional)
export MY_VAR="value"
export PATH="$PATH:~/my/bin"
```

---

## 🔍 Troubleshooting

### Fish Shell Not Found
```bash
# If fish command not found:
/Users/michael/homebrew/bin/fish

# Or check installation:
brew list | grep fish
brew reinstall fish
```

### Command Not Found (eza, bat, etc.)
```fish
# Install individual tools:
brew install eza
brew install bat
brew install fastfetch

# Or let the installer do it:
./install-macos.sh
# Choose option 2
```

### PATH Issues
```fish
# Check current PATH:
echo $PATH

# Verify Homebrew is in PATH:
which brew

# Expected paths:
# Apple Silicon: /opt/homebrew/bin
# Intel: /usr/local/bin
```

### Reset to Default
```bash
# Restore backup
cp ~/.config/fish/backups/config.fish.*.bak ~/.config/fish/config.fish

# Or start fresh
rm -rf ~/.config/fish
fish  # This will recreate with defaults
```

### Shell Won't Start
```bash
# Check for syntax errors:
fish -n

# Run with verbose output:
fish -v

# Test specific config:
fish -c "source ~/.config/fish/config.fish"
```

---

## 📖 Usage Examples

### Custom Functions

#### Backup function
```fish
backup myfile.txt
# Creates: myfile.txt.bak
```

#### Copy directories recursively
```fish
copy ~/old_project ~/new_project
# Copies entire directory structure
```

#### History with filtering
```fish
history | grep docker
# Shows command history with timestamps
```

---

## 🚪 Switching Between Branches

### Go to macOS version
```bash
git checkout macos-config
```

### Go to Linux version (CachyOS/Arch)
```bash
git checkout main
```

The configuration automatically uses the correct settings for your OS.

---

## 🔄 Updating Configuration

### Keep your customizations when updating
```bash
# Make a backup
cp ~/.config/fish/macos-config.fish ~/.config/fish/macos-config.fish.backup

# Update from repo
cd ~/cachyos-fish-config
git pull

# Copy updates
cp macos-config.fish ~/.config/fish/

# Restore customizations
# (manually merge your backup if needed)
```

---

## 🐛 Reporting Issues

- **GitHub Issues:** [Report a bug](https://github.com/cachyos/cachyos-fish-config/issues)
- **Feature Requests:** Open a discussion
- **macOS-specific:** Mention macOS version and Intel/Apple Silicon

---

## 📝 Environment Details

This configuration has been tested on:
- macOS 12.x (Monterey)
- macOS 13.x (Ventura)
- macOS 14.x (Sonoma)
- macOS 15.x (Sequoia)
- Apple Silicon (M1, M2, M3, M4)
- Intel processors

Fish Shell versions: 4.0 - 4.7+

---

## 🔗 Related Resources

- 🐟 **Fish Documentation:** https://fishshell.com/docs/current/
- 🍺 **Homebrew:** https://brew.sh
- 📦 **eza (ls replacement):** https://github.com/eza-community/eza
- 🎨 **bat (cat with syntax highlighting):** https://github.com/sharkdp/bat
- 🖥️ **fastfetch:** https://github.com/fastfetch-cli/fastfetch
- 🔔 **done (notifications):** https://github.com/franciscolourenco/done

---

## 📄 License

Licensed under the [MIT License](LICENSE.md). See LICENSE.md for full terms.

---

## 💡 Tips & Tricks

### Add to PATH
```fish
# In ~/.config/fish/macos-config.fish or ~/.fish_profile:
fish_add_path ~/my/custom/bin
```

### Disable Fastfetch Greeting
```fish
# Comment out in macos-config.fish:
# function fish_greeting
#     if type -q fastfetch
#         fastfetch
#     end
# end
```

### Use vi Key Bindings
```fish
# In ~/.config/fish/conf.d/custom.fish:
fish_vi_key_bindings
```

### Custom Aliases
```fish
# In ~/.config/fish/macos-config.fish:
alias docs='cd ~/Documents'
alias projects='cd ~/Projects'
```

---

**Happy fishing! 🐠**
