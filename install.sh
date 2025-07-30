#!/bin/bash

# TokyoNight Cyberpunk SwayFX Setup - Automated Installer
# Optimized for Intel i5-4430 + AMD RX 580 and similar hardware
# Author: [Your Name]
# License: MIT

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Art Header
print_header() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║    ████████╗ ██████╗ ██╗  ██╗██╗   ██╗ ██████╗              ║"
    echo "║    ╚══██╔══╝██╔═══██╗██║ ██╔╝╚██╗ ██╔╝██╔═══██╗             ║"
    echo "║       ██║   ██║   ██║█████╔╝  ╚████╔╝ ██║   ██║             ║"
    echo "║       ██║   ██║   ██║██╔═██╗   ╚██╔╝  ██║   ██║             ║"
    echo "║       ██║   ╚██████╔╝██║  ██╗   ██║   ╚██████╔╝             ║"
    echo "║       ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝    ╚═════╝              ║"
    echo "║                                                              ║"
    echo "║           🌃 CYBERPUNK SWAYFX SETUP 🌃                      ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# Check if running on Arch Linux
check_arch() {
    if [[ ! -f /etc/arch-release ]]; then
        log_error "This script is designed for Arch Linux only!"
        exit 1
    fi
    log_success "Arch Linux detected"
}

# Check if yay is installed
check_yay() {
    if ! command -v yay &> /dev/null; then
        log_warning "yay AUR helper not found. Installing..."

        # Install yay dependencies
        sudo pacman -S --needed --noconfirm base-devel git

        # Clone and build yay
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ~

        log_success "yay installed successfully"
    else
        log_success "yay AUR helper found"
    fi
}

# Detect hardware
detect_hardware() {
    log_step "Detecting hardware..."

    # CPU detection
    CPU_INFO=$(lscpu | grep "Model name" | sed 's/Model name:\s*//')
    log_info "CPU: $CPU_INFO"

    # GPU detection
    if lspci | grep -i "vga\|3d\|display" | grep -qi "amd\|radeon"; then
        GPU_VENDOR="amd"
        log_info "AMD GPU detected"
    elif lspci | grep -i "vga\|3d\|display" | grep -qi "nvidia"; then
        GPU_VENDOR="nvidia"
        log_info "NVIDIA GPU detected"
    elif lspci | grep -i "vga\|3d\|display" | grep -qi "intel"; then
        GPU_VENDOR="intel"
        log_info "Intel GPU detected"
    else
        GPU_VENDOR="unknown"
        log_warning "GPU vendor could not be detected"
    fi

    # RAM detection
    RAM_GB=$(free -h | awk '/^Mem:/ {print $2}' | sed 's/Gi//')
    log_info "RAM: ${RAM_GB}GB"
}

# Install base packages
install_base_packages() {
    log_step "Installing base packages..."

    local packages=(
        # SwayFX and core Wayland components
        "swayidle"
        "swaylock-effects"
        "swaybg"
        "waybar"
        "wofi"
        "dunst"
        "grim"
        "slurp"
        "wl-clipboard"

        # Audio system
        "pipewire"
        "pipewire-pulse"
        "pipewire-alsa"
        "pavucontrol"

        # Applications
        "thunar"
        "alacritty"
        "firefox"

        # Display manager
        "sddm"

        # System tools
        "btop"
        "neofetch"
        "starship"
        "playerctl"
        "polkit-gnome"

        # Development tools
        "base-devel"
        "git"
    )

    log_info "Installing official packages..."
    sudo pacman -S --needed --noconfirm "${packages[@]}"

    # AUR packages
    local aur_packages=(
        "swayfx"
        "eww"
        "nwg-dock"
        "nwg-drawer"
        "nwg-look"
        "azote"
        "spotify"
        "sddm-sugar-candy-git"
    )

    log_info "Installing AUR packages..."
    yay -S --needed --noconfirm "${aur_packages[@]}"

    log_success "Base packages installed"
}

# Install GPU-specific packages
install_gpu_packages() {
    log_step "Installing GPU-specific packages..."

    case $GPU_VENDOR in
        "amd")
            log_info "Installing AMD GPU packages..."
            sudo pacman -S --needed --noconfirm \
                mesa lib32-mesa \
                vulkan-radeon lib32-vulkan-radeon \
                xf86-video-amdgpu
            ;;
        "nvidia")
            log_info "Installing NVIDIA GPU packages..."
            sudo pacman -S --needed --noconfirm \
                nvidia nvidia-utils lib32-nvidia-utils \
                nvidia-settings
            ;;
        "intel")
            log_info "Installing Intel GPU packages..."
            sudo pacman -S --needed --noconfirm \
                mesa lib32-mesa \
                vulkan-intel lib32-vulkan-intel \
                xf86-video-intel
            ;;
        *)
            log_warning "Unknown GPU vendor, installing generic packages..."
            sudo pacman -S --needed --noconfirm mesa lib32-mesa
            ;;
    esac

    log_success "GPU packages installed"
}

# Install gaming packages
install_gaming_packages() {
    log_step "Installing gaming optimization packages..."

    local gaming_packages=(
        "gamemode"
        "lib32-gamemode"
        "gamescope"
        "mangohud"
        "lib32-mangohud"
        "steam"
        "lutris"
        "wine"
        "wine-mono"
        "wine-gecko"
        "winetricks"
    )

    sudo pacman -S --needed --noconfirm "${gaming_packages[@]}"

    # Install Heroic Games Launcher
    yay -S --needed --noconfirm heroic-games-launcher-bin

    # Optionally install zen kernel for better gaming performance
    read -p "Install linux-zen kernel for better gaming performance? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Installing linux-zen kernel..."
        yay -S --needed --noconfirm linux-zen linux-zen-headers
        log_warning "Remember to select linux-zen in your bootloader!"
    fi

    log_success "Gaming packages installed"
}

# Setup Zram
setup_zram() {
    log_step "Setting up Zram for better memory management..."

    sudo pacman -S --needed --noconfirm zram-generator

    # Create zram configuration
    sudo tee /etc/systemd/zram-generator.conf > /dev/null <<EOF
[zram0]
zram-size = min(ram / 2, 4096)
compression-algorithm = zstd
EOF

    sudo systemctl enable systemd-zram-setup@zram0.service
    log_success "Zram configured"
}

# Create directories
create_directories() {
    log_step "Creating necessary directories..."

    local dirs=(
        "$HOME/.config/sway"
        "$HOME/.config/waybar"
        "$HOME/.config/eww"
        "$HOME/.config/alacritty"
        "$HOME/.config/dunst"
        "$HOME/scripts"
        "$HOME/Pictures/wallpapers"
        "$HOME/.local/share/applications"
    )

    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
        log_info "Created directory: $dir"
    done

    log_success "Directories created"
}

# Copy configuration files
copy_configs() {
    log_step "Copying configuration files..."

    # Check if config files exist
    if [[ ! -d "configs" ]]; then
        log_error "configs directory not found! Make sure you're running this from the repository root."
        exit 1
    fi

    # Copy configurations
    cp -r configs/sway/* "$HOME/.config/sway/"
    cp -r configs/waybar/* "$HOME/.config/waybar/"
    cp -r configs/eww/* "$HOME/.config/eww/"
    cp -r configs/alacritty/* "$HOME/.config/alacritty/"

    # Copy starship config
    if [[ -f "configs/starship.toml" ]]; then
        cp configs/starship.toml "$HOME/.config/"
    fi

    # Copy scripts
    if [[ -d "scripts" ]]; then
        cp scripts/* "$HOME/scripts/"
        chmod +x "$HOME/scripts/"*.sh
    fi

    # Copy wallpapers
    if [[ -d "wallpapers" ]]; then
        cp wallpapers/* "$HOME/Pictures/wallpapers/"
    fi

    log_success "Configuration files copied"
}

# Setup services
setup_services() {
    log_step "Setting up system services..."

    # Enable SDDM
    sudo systemctl enable sddm

    # Enable user services
    systemctl --user enable pipewire pipewire-pulse

    # Enable GameMode daemon
    sudo systemctl enable gamemoded

    log_success "Services configured"
}

# Configure SDDM theme
setup_sddm_theme() {
    log_step "Configuring SDDM theme..."

    # Create SDDM config
    sudo tee /etc/sddm.conf > /dev/null <<EOF
[Theme]
Current=sugar-candy

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot
EOF

    # Configure SugarCandy theme
    local theme_dir="/usr/share/sddm/themes/sugar-candy"
    if [[ -d "$theme_dir" ]]; then
        sudo tee "$theme_dir/theme.conf" > /dev/null <<EOF
[General]
Background="Backgrounds/tokyonight-cyberpunk.jpg"
MainColor="#7aa2f7"
AccentColor="#bb9af7"
BackgroundColor="#1a1b26"
OverrideLoginButtonTextColor="#c0caf5"
InterfaceShadowSize="6"
RoundCorners="20"
ScreenWidth="1440"
ScreenHeight="900"
FullBlur="false"
PartialBlur="false"
BlurRadius="100"
HaveFormBackground="false"
FormPosition="left"
BackgroundImageHAlignment="center"
BackgroundImageVAlignment="center"
EOF

        # Copy wallpaper for SDDM if available
        if [[ -f "$HOME/Pictures/wallpapers/tokyonight-cyberpunk.jpg" ]]; then
            sudo cp "$HOME/Pictures/wallpapers/tokyonight-cyberpunk.jpg" "$theme_dir/Backgrounds/"
        fi

        log_success "SDDM theme configured"
    else
        log_warning "SugarCandy theme directory not found, skipping theme configuration"
    fi
}

# Performance optimizations
apply_performance_optimizations() {
    log_step "Applying performance optimizations..."

    # Create GameMode config
    mkdir -p "$HOME/.config"
    tee "$HOME/.config/gamemode.ini" > /dev/null <<EOF
[general]
renice=10
ioprio=1
inhibit_screensaver=1

[gpu]
apply_gpu_optimizations=accept-responsibility
gpu_device=0

[custom]
start=notify-send "GameMode activated"
end=notify-send "GameMode deactivated"
EOF

    # Create performance script
    tee "$HOME/scripts/performance-mode.sh" > /dev/null <<'EOF'
#!/bin/bash
# Performance mode toggle

if [[ "$1" == "enable" ]]; then
    echo "Enabling performance mode..."
    echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
    swaymsg blur disable
    swaymsg shadows disable
    notify-send "Performance Mode" "Enabled for gaming" -t 3000
elif [[ "$1" == "disable" ]]; then
    echo "Disabling performance mode..."
    echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
    swaymsg blur enable
    swaymsg shadows enable
    notify-send "Performance Mode" "Disabled" -t 3000
else
    echo "Usage: $0 {enable|disable}"
fi
EOF

    chmod +x "$HOME/scripts/performance-mode.sh"

    log_success "Performance optimizations applied"
}

# Setup font
setup_fonts() {
    log_step "Installing fonts..."

    # Install JetBrains Mono Nerd Font
    yay -S --needed --noconfirm ttf-jetbrains-mono-nerd

    # Update font cache
    fc-cache -fv

    log_success "Fonts installed"
}

# Final setup steps
final_setup() {
    log_step "Performing final setup steps..."

    # Add user to gamemode group
    sudo usermod -aG gamemode "$USER"

    # Set default shell to bash with starship (if not already set)
    if [[ "$SHELL" != "/bin/bash" ]]; then
        read -p "Change default shell to bash? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            chsh -s /bin/bash
            log_info "Default shell changed to bash"
        fi
    fi

    # Add starship to bashrc if not already present
    if ! grep -q "starship init bash" "$HOME/.bashrc" 2>/dev/null; then
        echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
        log_info "Starship added to .bashrc"
    fi

    log_success "Final setup completed"
}

# Main installation function
main() {
    print_header

    log_info "Starting TokyoNight Cyberpunk SwayFX installation..."
    echo

    # Confirmation prompt
    echo -e "${YELLOW}This script will:"
    echo "• Install SwayFX and related packages"
    echo "• Install gaming optimizations"
    echo "• Copy configuration files"
    echo "• Setup SDDM theme"
    echo "• Configure system services"
    echo -e "${NC}"

    read -p "Continue with installation? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Installation cancelled by user"
        exit 0
    fi

    echo

    # Run installation steps
    check_arch
    check_yay
    detect_hardware
    install_base_packages
    install_gpu_packages
    install_gaming_packages
    setup_zram
    setup_fonts
    create_directories
    copy_configs
    setup_services
    setup_sddm_theme
    apply_performance_optimizations
    final_setup

    echo
    log_success "🎉 Installation completed successfully!"
    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗"
    echo "║                        INSTALLATION COMPLETE                 ║"
    echo "╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${CYAN}Next steps:${NC}"
    echo "1. Reboot your system: ${YELLOW}sudo reboot${NC}"
    echo "2. Select 'SwayFX' from the SDDM login screen"
    echo "3. Use ${YELLOW}Super + K${NC} to view keybindings"
    echo "4. Use ${YELLOW}Super + G${NC} to open the game launcher"
    echo "5. Enjoy your cyberpunk desktop! 🌃"
    echo
    echo -e "${BLUE}For troubleshooting, check the README.md file${NC}"
    echo

    read -p "Reboot now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Rebooting system..."
        sudo reboot
    else
        log_info "Please reboot manually to complete the setup"
    fi
}

# Handle script interruption
cleanup() {
    echo
    log_warning "Installation interrupted!"
    log_info "You can re-run the script to continue the installation"
    exit 1
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Check if script is run from correct directory
if [[ ! -f "install.sh" ]] || [[ ! -d "configs" ]]; then
    log_error "Please run this script from the repository root directory"
    log_info "Usage: cd tokyonight-swayfx-setup && ./install.sh"
    exit 1
fi

# Run main function
main "$@"
