# Mystery Files - Godot iOS Project

A mystery narrative game with voice interaction and AI-generated stories.

## Project Structure

```
mystery-files/
├── project.godot                    # Godot project configuration
├── icon.svg                         # App icon
├── .godot/                          # Godot editor cache (auto-generated)
│
├── scenes/                          # Scene files (.tscn)
│   ├── ui/                          # UI scenes
│   │   ├── main_menu.tscn
│   │   ├── explore.tscn
│   │   ├── dialogue.tscn
│   │   ├── ending.tscn
│   │   ├── archive.tscn
│   │   └── settings.tscn
│   ├── characters/                  # Character scenes
│   │   └── npc_base.tscn
│   └── common/                      # Common scenes
│       └── transition.tscn
│
├── scripts/                         # GDScript files (.gd)
│   ├── autoload/                    # Global singletons
│   │   ├── event_bus.gd
│   │   ├── game_state.gd
│   │   ├── story_manager.gd
│   │   ├── npc_manager.gd
│   │   ├── clue_manager.gd
│   │   ├── audio_manager.gd
│   │   ├── save_manager.gd
│   │   ├── ai_service.gd
│   │   └── voice_service.gd
│   ├── scenes/                      # Scene scripts
│   │   └── *.gd
│   ├── components/                  # Reusable components
│   │   └── *.gd
│   └── utils/                       # Utility functions
│       └── *.gd
│
├── resources/                       # Game resources
│   ├── sprites/                     # Pixel art sprites
│   │   ├── characters/
│   │   ├── scenes/
│   │   ├── items/
│   │   └── ui/
│   ├── audio/                       # Audio files
│   │   ├── bgm/                     # Background music
│   │   ├── sfx/                     # Sound effects
│   │   └── ambient/                 # Ambient sounds
│   └── fonts/                       # Font files
│
├── data/                            # Game data
│   ├── story_templates/             # Story templates
│   ├── npcs/                        # NPC data
│   ├── dialogues/                   # Dialogue data
│   └── config/                      # Configuration files
│
├── assets/                          # Additional assets
│   ├── models/                      # AI models (ONNX)
│   └── vocab/                       # Vocab and prompts
│
├── ios/                             # iOS specific files
│   ├── GodotProject/                # Xcode project (generated on export)
│   └── Frameworks/                  # iOS frameworks
│
└── export_presets/                  # Export presets
	└── ios_export_preset.godot
```

## Prerequisites

1. **Godot 4.x** - Download from [godotengine.org](https://godotengine.org/)
2. **Xcode 15+** - For iOS builds (macOS only)
3. **Apple Developer Account** - For device testing and App Store distribution

## Getting Started

1. Open `project.godot` in Godot Editor
2. Configure API keys in `data/config/ai_config.json`
3. Press F5 to run the project

## iOS Export

1. Install iOS build templates: `godot --install-build-templates`
2. Configure export preset in Project → Export → iOS
3. Set your Team ID and Bundle Identifier
4. Export to Xcode project
5. Open in Xcode and sign with your developer certificate
6. Build and run on device

## Documentation

- [UI/UX Requirements](../docs/requirements/Game_UI_UX_Requirements.md)
- [Technical Architecture](../docs/technical/Game_Technical_Architecture.md)
- [Implementation Plan](../docs/plans/mystery-game-implementation.md)

## License

All rights reserved.
