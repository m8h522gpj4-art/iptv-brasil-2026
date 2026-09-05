# IPTV Brasil iOS README

This folder contains a minimal SwiftUI example app and helper code to load playlists and play HLS streams, plus a default configuration file.

Included:
- IPTVBrasil2026.xcodeproj (not included; see instructions to create/open)
- default_config.json — default playlist/config that is copied to Application Support on first run
- Sources/ConfigManager.swift — manages copying default config, reading, writing, and migrations
- Sources/PlaylistParser.swift — lightweight parser for .m3u and JSON playlists
- Sources/PlayerView.swift — AVPlayer-based SwiftUI player view
- Sources/ContentView.swift and IPTVBrasilApp.swift — main app views
- /server/Dockerfile and convert_to_hls.sh — minimal FFmpeg-based HLS packager (server-side)

How to use
1. Open Xcode and create a new app named "IPTVBrasil2026" (SwiftUI, iOS 15+). Replace/add the Sources files below into the project.
2. Add default_config.json into the app bundle (in Copy Bundle Resources).
3. Build & run on a device or simulator. On first run the default config is copied to Application Support and used as the live config.

Upgrade behavior
- The app will never overwrite the user's config.json stored in Application Support on update.
- If a schema change is needed, adjust ConfigManager.migrateIfNeeded to implement upgrade steps keyed by "configVersion".

Server-side
- A basic Docker + FFmpeg script is provided to convert arbitrary input streams/files to HLS segments/manifests for iOS playback.

License: MIT
