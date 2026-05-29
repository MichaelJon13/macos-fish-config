## macOS Fish Shell Configuration
## Optimized for macOS with Homebrew (no admin rights required)

## Source conf.d plugins before main config
source ~/.config/fish/conf.d/done.fish

## Set values
## Run fastfetch as welcome message (or disable this if you prefer default greeting)
function fish_greeting
    if type -q fastfetch
        fastfetch
    else
        echo "Welcome to Fish Shell on macOS!"
    end
end

# Format man pages
set -x MANROFFOPT "-c"
if type -q bat
    set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
  source ~/.fish_profile
end

# Append common directories for executable files to $PATH
# Homebrew paths for macOS (no sudo needed)
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
end
if test -d /usr/local/bin
    fish_add_path /usr/local/bin
end

## Functions
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T ' $argv
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

## Useful aliases for macOS

# Replace ls with eza (if installed)
if type -q eza
    alias ls='eza -al --color=always --group-directories-first --icons=auto'
    alias la='eza -a --color=always --group-directories-first --icons=auto'
    alias ll='eza -l --color=always --group-directories-first --icons=auto'
    alias lt='eza -aT --color=always --group-directories-first --icons=auto'
    alias l.="eza -a | grep -e '^\.'"
else
    alias ls='ls -Al'
    alias la='ls -A'
    alias ll='ls -l'
    alias l.='ls -d .*'
end

# Navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Grep with color
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# macOS-specific utilities
alias showfiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
alias emptytrash='rm -rfv ~/.Trash/*'

# Homebrew aliases
if type -q brew
    alias brewup='brew update && brew upgrade'
    alias brewclean='brew cleanup'
    alias brewdoc='brew doctor'
    alias brewopts='brew options'
end

# Common tools
alias wget='wget -c'
alias tarnow='tar -acf'
alias untar='tar -zxvf'

# IP address
alias myip='curl -s https://icanhazip.com'
alias myips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\([0-9]\+\.\)\{3\}[0-9]\+\|[a-fA-F0-9:]\+\)' | awk '{print \$NF}' | tr '\n' ' '; echo"

# System info
alias sysinfo='system_profiler SPSoftwareDataType SPHardwareDataType'

# Network diagnostics
alias flush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias openports='netstat -tulpn | grep LISTEN'

# Applications
alias chrome='open -a "Google Chrome"'
alias safari='open -a "Safari"'
alias vscode='open -a "Visual Studio Code"'
