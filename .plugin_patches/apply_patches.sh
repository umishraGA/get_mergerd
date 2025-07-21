#!/bin/bash

# Copy patched build.gradle to better_player plugin
cp -f .plugin_patches/better_player/android/build.gradle ~/.pub-cache/hosted/pub.dev/better_player-0.0.84/android/build.gradle

echo "Patches applied successfully!" 