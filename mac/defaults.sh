#!/usr/bin/env bash
set -euo pipefail

osascript -e 'tell application "System Preferences" to quit'

###############################################################################
# Dock                                                                        #
###############################################################################

# disable hot corners
defaults write com.apple.dock wvous-bl-corner -int 1
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-tl-corner -int 1
defaults write com.apple.dock wvous-tr-corner -int 1

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# less offensive minimisation effect than genie
defaults write com.apple.dock mineffect -string "scale"

# show dock on all monitors (sometimes works after some boots, but stopped for me)
defaults write com.apple.dock appswitcher-all-displays -bool true

# don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# show only open applications in the Dock
defaults write com.apple.dock static-only -bool true

###############################################################################
# accessibility
###############################################################################

defaults write com.apple.universalaccess reduceMotion -bool true
defaults write com.apple.universalaccess slowKey -bool false

###############################################################################
# locale                                                                      #
###############################################################################

defaults write NSGlobalDomain AppleLanguages -array "en-GB"
defaults write NSGlobalDomain AppleLocale -string "en_GB"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

###############################################################################
# Crash Reporter                                                              #
###############################################################################

defaults write com.apple.CrashReporter DialogType -string none


###############################################################################
# AdLib                                                                       #
###############################################################################

defaults write com.apple.AdLib forceLimitAdTracking -bool true
defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false
defaults write com.apple.AdLib allowIdentifierForAdvertising -bool false
defaults write com.apple.AdLib StocksEnabled -bool false

###############################################################################
# Apps                                                                       #
###############################################################################

# put hammerspoon config dir under ~/.config
defaults write org.hammerspoon.Hammerspoon MJConfigFile ~/.config/hammerspoon/init.lua

# Allow opening apps from any source
sudo spctl --master-disable

###############################################################################
# Screen                                                                      #
###############################################################################

# Save screenshots to ~/Pictures
defaults write com.apple.screencapture location -string "${HOME}/Pictures"

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# default finder dir is ~
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# open in new windows rather than tabs
defaults write com.apple.finder FinderSpawnTab -float 0

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Do not group list view
defaults write com.apple.finder FXPreferredGroupBy -string "None"

# Show hidden files
defaults write com.apple.finder "AppleShowAllFiles" -bool "true"

# Avoid creating .DS_Store files on network volumes or USB drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

###############################################################################
# UI                                                                          #
###############################################################################

# Jump to the spot that's clicked on the scroll bar
defaults write -g AppleScrollerPagingBehavior -bool true

# Manual TODO: unbind ~everything from "Keyboard Shortcuts"

###############################################################################

killall SystemUIServer || true
killall Finder || true
killall Dock || true

###############################################################################
# Power Management (cross ref with 'pmset -g' + 'man pmset')                  #
###############################################################################

# Disable auto update, auto backup when sleeping
sudo pmset -a powernap 0

# Disable wake by network
sudo pmset -a womp 0
