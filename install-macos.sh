#!/bin/bash

################################################################################
# macOS Fish Shell Configuration Installation Script
# Author: Auto-generated setup script
# Description: Installs and configures Fish shell with macOS optimizations
################################################################################

set -e

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

# Configuration paths
readonly FISH_CONFIG_DIR="${HOME}/.config/fish"
readonly REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BACKUP_DIR="${FISH_CONFIG_DIR}/backups"
readonly TIMESTAMP=$(date +%Y%m%d_%H%M%S)

################################################################################
# UI Functions
################################################################################

print_header() {
    echo -e "\n${BOLD}${CYAN}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
    echo -e "${BOLD}${CYAN}  $1${NC}"
    echo -e "${BOLD}${CYAN}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}\n"
}

print_section() {
    echo -e "\n${BOLD}${BLUE}➜ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

print_divider() {
    echo -e "${CYAN}─────────────────────────────────────────────────────${NC}"
}

# Simple menu selection
menu_select() {
    local prompt="$1"
    shift
    local options=("$@")
    local selected=0
    
    echo -e "\n${BOLD}$prompt${NC}"
    for i in "${!options[@]}"; do
        echo "  $(($i + 1))) ${options[$i]}"
    done
    
    while true; do
        read -p "Choose option (1-${#options[@]}): " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#options[@]} )); then
            selected=$(($choice - 1))
            break
        fi
        print_error "Invalid selection. Please try again."
    done
    
    echo "$selected"
}

################################################################################
# Dependency Management Functions
################################################################################

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

check_homebrew() {
    print_section "Checking Homebrew installation"
    
    if check_command brew; then
        local brew_version=$(brew --version | head -n1)
        print_success "Homebrew is installed: $brew_version"
        return 0
    else
        print_error "Homebrew is not installed"
        echo -e "\n${YELLOW}To install Homebrew without admin rights:${NC}"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        echo -e "\n${YELLOW}Then add Homebrew to your PATH in ~/.fish_profile:${NC}"
        echo "  export PATH=\"/opt/homebrew/bin:\$PATH\"  # For Apple Silicon"
        echo "  # or"
        echo "  export PATH=\"/usr/local/bin:\$PATH\"    # For Intel"
        return 1
    fi
}

check_fish() {
    print_section "Checking Fish Shell installation"
    
    if check_command fish; then
        local fish_version=$(fish --version)
        print_success "Fish Shell is installed: $fish_version"
        return 0
    else
        print_error "Fish Shell is not installed"
        return 1
    fi
}

check_dependency() {
    local dep=$1
    local description=$2
    
    if check_command "$dep"; then
        local version=""
        if [ "$dep" = "eza" ]; then
            version=$(eza --version 2>&1 | head -n1)
        elif [ "$dep" = "bat" ]; then
            version=$(bat --version 2>&1 | head -n1)
        elif [ "$dep" = "fastfetch" ]; then
            version=$(fastfetch --version 2>&1 | head -n1)
        else
            version="installed"
        fi
        print_success "$description: $version"
        return 0
    else
        print_warning "$description: not installed (optional)"
        return 1
    fi
}

install_dependency() {
    local dep=$1
    local description=$2
    
    print_info "Installing $description..."
    
    if brew install "$dep"; then
        print_success "$description installed successfully"
        return 0
    else
        print_error "Failed to install $description"
        return 1
    fi
}

check_all_dependencies() {
    print_header "Dependency Check"
    
    # Check required dependencies
    if ! check_homebrew; then
        print_error "Homebrew is required. Please install it first."
        return 1
    fi
    
    if ! check_fish; then
        print_error "Fish Shell is required. Installing..."
        if ! install_dependency fish "Fish Shell"; then
            print_error "Failed to install Fish Shell. Exiting."
            return 1
        fi
    fi
    
    print_divider
    
    # Check optional dependencies
    local missing_deps=()
    
    if ! check_dependency eza "File lister (eza)"; then
        missing_deps+=(eza)
    fi
    
    if ! check_dependency bat "Syntax highlighter (bat)"; then
        missing_deps+=(bat)
    fi
    
    if ! check_dependency fastfetch "System info (fastfetch)"; then
        missing_deps+=(fastfetch)
    fi
    
    print_divider
    
    # Ask to install missing dependencies
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "\n${YELLOW}Missing optional tools:${NC} ${missing_deps[*]}"
        read -p "Install missing dependencies? (y/n): " -n 1 -r install_choice
        echo
        
        if [[ $install_choice =~ ^[Yy]$ ]]; then
            for dep in "${missing_deps[@]}"; do
                install_dependency "$dep" "$dep"
            done
        else
            print_warning "Skipping optional dependencies. Config will degrade gracefully."
        fi
    fi
    
    print_success "Dependency check complete"
    return 0
}

################################################################################
# File Management Functions
################################################################################

create_backup() {
    print_section "Creating backup of current Fish configuration"
    
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        print_success "Created backup directory: $BACKUP_DIR"
    fi
    
    if [ -f "$FISH_CONFIG_DIR/config.fish" ]; then
        local backup_file="$BACKUP_DIR/config.fish.${TIMESTAMP}.bak"
        cp "$FISH_CONFIG_DIR/config.fish" "$backup_file"
        print_success "Backed up config.fish to: $backup_file"
    fi
    
    if [ -d "$FISH_CONFIG_DIR/conf.d" ] && [ "$(ls -A $FISH_CONFIG_DIR/conf.d)" ]; then
        local backup_dir="$BACKUP_DIR/conf.d.${TIMESTAMP}"
        cp -r "$FISH_CONFIG_DIR/conf.d" "$backup_dir"
        print_success "Backed up conf.d to: $backup_dir"
    fi
}

create_fish_config_dir() {
    print_section "Setting up Fish configuration directory"
    
    if [ ! -d "$FISH_CONFIG_DIR" ]; then
        mkdir -p "$FISH_CONFIG_DIR"
        print_success "Created Fish config directory: $FISH_CONFIG_DIR"
    fi
    
    if [ ! -d "$FISH_CONFIG_DIR/conf.d" ]; then
        mkdir -p "$FISH_CONFIG_DIR/conf.d"
        print_success "Created conf.d directory"
    fi
    
    if [ ! -d "$FISH_CONFIG_DIR/functions" ]; then
        mkdir -p "$FISH_CONFIG_DIR/functions"
        print_success "Created functions directory"
    fi
}

install_config() {
    print_section "Installing macOS Fish configuration"
    
    # Check if repo files exist
    if [ ! -f "$REPO_DIR/config.fish" ]; then
        print_error "config.fish not found in repo. Make sure you're in the correct directory."
        return 1
    fi
    
    if [ ! -f "$REPO_DIR/macos-config.fish" ]; then
        print_error "macos-config.fish not found in repo."
        return 1
    fi
    
    # Install main config
    cp "$REPO_DIR/config.fish" "$FISH_CONFIG_DIR/config.fish"
    print_success "Installed config.fish"
    
    # Install macOS config
    cp "$REPO_DIR/macos-config.fish" "$FISH_CONFIG_DIR/macos-config.fish"
    print_success "Installed macos-config.fish"
    
    # Install done.fish plugin if it exists
    if [ -f "$REPO_DIR/conf.d/done.fish" ]; then
        cp "$REPO_DIR/conf.d/done.fish" "$FISH_CONFIG_DIR/conf.d/done.fish"
        print_success "Installed done.fish plugin"
    fi
    
    print_success "Configuration files installed successfully"
}

verify_installation() {
    print_section "Verifying installation"
    
    local issues=0
    
    if [ ! -f "$FISH_CONFIG_DIR/config.fish" ]; then
        print_error "config.fish is missing"
        ((issues++))
    else
        print_success "config.fish is present"
    fi
    
    if [ ! -f "$FISH_CONFIG_DIR/macos-config.fish" ]; then
        print_error "macos-config.fish is missing"
        ((issues++))
    else
        print_success "macos-config.fish is present"
    fi
    
    if [ ! -f "$FISH_CONFIG_DIR/conf.d/done.fish" ]; then
        print_warning "done.fish plugin is missing (optional)"
    else
        print_success "done.fish plugin is present"
    fi
    
    if [ $issues -eq 0 ]; then
        print_success "All required files are in place"
        return 0
    else
        print_error "Installation verification failed ($issues issues)"
        return 1
    fi
}

################################################################################
# Main Menu Functions
################################################################################

show_status() {
    print_header "Current Installation Status"
    
    echo -e "${BOLD}System Information:${NC}"
    echo "  macOS Version: $(sw_vers -productVersion)"
    echo "  Shell: $SHELL"
    print_divider
    
    echo -e "\n${BOLD}Required Tools:${NC}"
    if check_command brew; then
        print_success "Homebrew: $(brew --version | head -n1)"
    else
        print_error "Homebrew: not installed"
    fi
    
    if check_command fish; then
        print_success "Fish Shell: $(fish --version)"
    else
        print_error "Fish Shell: not installed"
    fi
    
    print_divider
    
    echo -e "\n${BOLD}Optional Tools:${NC}"
    check_dependency eza "eza" || true
    check_dependency bat "bat" || true
    check_dependency fastfetch "fastfetch" || true
    
    print_divider
    
    echo -e "\n${BOLD}Configuration:${NC}"
    if [ -f "$FISH_CONFIG_DIR/config.fish" ]; then
        print_success "Fish config directory: $FISH_CONFIG_DIR"
    else
        print_warning "Fish config not yet installed"
    fi
}

show_main_menu() {
    while true; do
        print_header "macOS Fish Shell Configuration Installer"
        
        echo -e "${BOLD}What would you like to do?${NC}\n"
        echo "  1) Check system status"
        echo "  2) Check and install dependencies"
        echo "  3) Backup current configuration"
        echo "  4) Install new Fish configuration"
        echo "  5) Full installation (backup + install + verify)"
        echo "  6) View installation guide"
        echo "  7) Exit"
        
        read -p "Choose option (1-7): " choice
        
        case $choice in
            1) show_status ;;
            2) check_all_dependencies ;;
            3) create_backup ;;
            4)
                create_fish_config_dir
                install_config
                ;;
            5)
                create_fish_config_dir
                check_all_dependencies
                create_backup
                install_config
                verify_installation
                show_next_steps
                ;;
            6) show_guide ;;
            7)
                print_success "Exiting. Goodbye!"
                exit 0
                ;;
            *) print_error "Invalid selection. Please try again." ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

show_next_steps() {
    print_header "Installation Complete!"
    
    echo -e "${GREEN}✓${NC} ${BOLD}Your Fish configuration has been installed.${NC}\n"
    
    echo -e "${BOLD}Next Steps:${NC}\n"
    
    echo "1) ${BOLD}Set Fish as your default shell:${NC}"
    echo "   ${CYAN}chsh -s $(which fish)${NC}\n"
    
    echo "2) ${BOLD}Start a new Fish shell:${NC}"
    echo "   ${CYAN}fish${NC}\n"
    
    echo "3) ${BOLD}Reload your configuration:${NC}"
    echo "   ${CYAN}source ~/.config/fish/config.fish${NC}\n"
    
    echo -e "${BOLD}Test the installation:${NC}"
    echo "   ${CYAN}ll${NC}              (list files with eza)"
    echo "   ${CYAN}history${NC}         (show command history with timestamps)"
    echo "   ${CYAN}brewup${NC}          (update Homebrew packages)"
    echo "   ${CYAN}myip${NC}            (show your public IP address)"
    echo "   ${CYAN}showfiles${NC}       (show hidden files in Finder)\n"
    
    echo -e "${BOLD}Configuration files:${NC}"
    echo "   Main config: ${CYAN}~/.config/fish/config.fish${NC}"
    echo "   macOS config: ${CYAN}~/.config/fish/macos-config.fish${NC}"
    echo "   Backups: ${CYAN}${BACKUP_DIR}${NC}\n"
    
    print_divider
}

show_guide() {
    print_header "Installation Guide"
    
    cat << 'EOF'
MACOS FISH SHELL CONFIGURATION GUIDE

1. PREREQUISITES
   • macOS 10.12 or later
   • Homebrew installed (non-admin installation supported)
   • Bash 4.0+ (usually pre-installed)

2. INSTALLATION STEPS
   Step 1: Run this installer
   Step 2: Choose "Full installation (option 5)"
   Step 3: Follow the prompts
   Step 4: Set Fish as your default shell: chsh -s $(which fish)
   Step 5: Start a new shell and enjoy!

3. WHAT'S INSTALLED
   • Enhanced aliases (eza, grep with color, navigation)
   • Homebrew management (brewup, brewclean, brewdoc)
   • macOS utilities (showfiles, hidefiles, emptytrash)
   • Command history with timestamps
   • Shell shortcuts (!! and !$)
   • Notification plugin (done.fish)
   • SSH/GPG key loading

4. OPTIONAL TOOLS (auto-installed)
   • eza - Modern file lister (replaces ls)
   • bat - Syntax highlighter (for man pages)
   • fastfetch - System information display

5. TROUBLESHOOTING
   Q: "command not found" errors?
   A: You may need to reload your shell. Try: source ~/.config/fish/config.fish

   Q: Homebrew paths not working?
   A: Fish installs to /opt/homebrew/bin (Apple Silicon) or /usr/local/bin (Intel)
      These are automatically added to your PATH.

   Q: Need to uninstall?
   A: Your previous config is backed up in ~/.config/fish/backups/

6. CUSTOMIZATION
   Edit ~/.config/fish/macos-config.fish to:
   • Add custom aliases
   • Disable fastfetch greeting
   • Add custom functions
   • Modify PATH settings

7. GET HELP
   • GitHub: https://github.com/cachyos/cachyos-fish-config
   • Fish docs: https://fishshell.com/docs/current/
   • Homebrew: https://brew.sh

EOF
    
    print_divider
}

################################################################################
# Main Execution
################################################################################

main() {
    # Check if running from correct directory
    if [ ! -f "$REPO_DIR/config.fish" ] || [ ! -f "$REPO_DIR/macos-config.fish" ]; then
        print_error "Script must be run from the repository root directory"
        echo "Current directory: $(pwd)"
        exit 1
    fi
    
    print_header "macOS Fish Shell Setup"
    
    echo "This script will help you install and configure Fish Shell on macOS."
    echo "Homebrew must be installed before proceeding."
    echo ""
    print_info "Your current Fish configuration will be backed up before installation."
    echo ""
    
    # Start interactive menu
    show_main_menu
}

# Run main function
main "$@"
