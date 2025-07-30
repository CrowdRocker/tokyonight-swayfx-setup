#!/bin/bash
# SwayFX TokyoNight Cyberpunk Keybind Display

TEMP_FILE="/tmp/swayfx_keybinds.txt"

cat > "$TEMP_FILE" << 'EOF'
┌─────────────────────────────────────────────────────────────────┐
│                    🎮 SWAYFX KEYBINDS 🎮                      │
├─────────────────────────────────────────────────────────────────┤
│ SYSTEM                                                          │
│  Super + Return        → Terminal (Alacritty)                  │
│  Super + Shift + Q     → Close Window                          │
│  Super + Shift + E     → Exit SwayFX                           │
│  Super + Shift + C     → Reload Config                         │
│  Super + Space         → Focus Mode Toggle                     │
│                                                                 │
│ APPLICATIONS                                                    │
│  Super + D             → App Launcher (nwg-drawer)             │
│  Super + E             → File Manager (Thunar)                 │
│  Super + G             → Game Launcher                         │
│  Super + B             → Browser                               │
│  Super + K             → Show Keybinds                         │
│                                                                 │
│ WINDOW MANAGEMENT                                               │
│  Super + H/J/K/L       → Move Focus (Vim keys)                 │
│  Super + Arrow Keys    → Move Focus                            │
│  Super + Shift + Move  → Move Windows                          │
│  Super + R             → Resize Mode                           │
│  Super + F             → Fullscreen                            │
│  Super + Shift + Space → Toggle Floating                       │
│                                                                 │
│ LAYOUTS                                                         │
│  Super + S             → Stacking Layout                       │
│  Super + W             → Tabbed Layout                         │
│  Super + X             → Toggle Split Layout                   │
│                                                                 │
│ WORKSPACES                                                      │
│  Super + 1-5           → Switch Workspace                      │
│  Super + Shift + 1-5   → Move to Workspace                     │
│                                                                 │
│ GAMING                                                          │
│  Super + F11           → Toggle Fullscreen                     │
│  Super + Alt + G       → Launch with GameMode                  │
│  Print Screen          → Screenshot Selection                  │
│  Super + Print         → Full Screenshot                       │
│                                                                 │
│ MEDIA                                                           │
│  Volume/Media Keys     → Audio Control                         │
│  XF86AudioPlay         → Play/Pause                            │
└─────────────────────────────────────────────────────────────────┘
EOF

alacritty \
  --title "SwayFX Keybinds" \
  --option window.dimensions.columns=75 \
  --option window.dimensions.lines=35 \
  --option window.position.x=100 \
  --option window.position.y=100 \
  --option colors.primary.background="'#1a1b26'" \
  --option colors.primary.foreground="'#7aa2f7'" \
  --option window.opacity=0.95 \
  --hold \
  -e sh -c "cat '$TEMP_FILE' && echo '\n📝 Press any key to close...' && read -n 1"

rm -f "$TEMP_FILE"
