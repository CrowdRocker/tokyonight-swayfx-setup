#!/bin/bash
# Performance mode for gaming

# Set CPU governor
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Disable SwayFX effects temporarily for maximum performance
swaymsg blur disable
swaymsg shadows disable

# Launch game with optimizations
exec gamemoderun mangohud "$@"

# Re-enable effects after game closes
swaymsg blur enable
swaymsg shadows enable
echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
