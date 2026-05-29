# Source OS-specific configuration
if test (uname) = Darwin
    source ~/.config/fish/macos-config.fish
else
    # Fallback for Linux systems (e.g., CachyOS)
    if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
        source /usr/share/cachyos-fish-config/cachyos-config.fish
    else
        source ~/.config/fish/macos-config.fish
    end
end

# Uncomment to override greeting
# function fish_greeting
#     # custom greeting
# end
