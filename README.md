# Fish Shell Configuration

This repository contains Fish shell configurations for multiple operating systems.

## Branches

- **main** - CachyOS/Arch Linux configuration
- **macos-config** - macOS configuration (with Homebrew support)

## macOS Setup (macos-config branch)

This branch provides a Fish shell configuration optimized for macOS with Homebrew.

### Prerequisites

1. **Fish Shell** installed via Homebrew:
   ```bash
   brew install fish
   ```

2. **Optional but recommended packages**:
   ```bash
   brew install eza bat fastfetch
   ```

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/cachyos/cachyos-fish-config.git ~/.config/fish
   cd ~/.config/fish
   ```

2. Check out the macOS branch:
   ```bash
   git checkout macos-config
   ```

3. Create the `conf.d` directory if it doesn't exist:
   ```bash
   mkdir -p ~/.config/fish/conf.d
   ```

4. Ensure the main `config.fish` is set as your shell configuration.

5. Start a new Fish shell session or source the config:
   ```bash
   source ~/.config/fish/config.fish
   ```

### Configuration Features

- **Cross-platform functions**: Works with both macOS and Linux
- **Homebrew support**: Aliases for `brewup`, `brewclean`, `brewdoc`
- **Smart history tracking**: Enhanced history with timestamps via `done.fish` plugin
- **Shell shortcuts**: `!!` (last command) and `!$` (last argument)
- **macOS utilities**: 
  - `showfiles`/`hidefiles` - Toggle hidden files in Finder
  - `emptytrash` - Empty Trash
  - `myip` - Show public IP address
  - `myips` - Show all local IP addresses
  - `sysinfo` - System information
  - `chrome`, `safari`, `vscode` - Quick app launchers

- **Better defaults**: 
  - Uses `eza` instead of `ls` (if installed)
  - Enhanced man page viewing with `bat`
  - Fastfetch greeting (optional)

### Customization

Edit `macos-config.fish` to customize:
- Aliases and functions
- Man page pager
- Greeting message (comment out `fish_greeting` if you prefer default)
- Added PATH directories

### Troubleshooting

**Command not found errors for Linux aliases?**
- You're on the wrong branch. This config sources OS-specific files automatically.
- If on macOS, ensure you're on the `macos-config` branch.

**Missing commands?**
- Install optional tools: `brew install eza bat fastfetch`
- The config gracefully falls back if tools are missing

**PATH issues?**
- Check that Homebrew paths are in your PATH:
  ```fish
  echo $PATH
  ```
- For Apple Silicon Macs, Homebrew installs to `/opt/homebrew/bin`
- For Intel Macs, Homebrew installs to `/usr/local/bin`

### Linux (CachyOS) Setup

Switch to the main branch for CachyOS/Arch Linux:
```bash
git checkout main
```

