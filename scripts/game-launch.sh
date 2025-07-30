#!/bin/bash
# Enhanced gaming launch script

# Set CPU governor to performance
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Set GPU to high performance
echo high | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level

# Launch with optimizations
exec gamemoderun mangohud "$@"
