# Mystery Files - Project Index

> **Generated**: 2026-03-27
> **Version**: 1.0.0
> **Engine**: Godot 4.x
> **Platform**: iOS

---

## Quick Start

1. **Open Project**: Open `project.godot` in Godot Editor 4.x
2. **Configure API**: Edit `data/config/ai_config.json` with your API key
3. **Run**: Press F5 to run in editor
4. **Export iOS**: Project → Export → iOS → Save

---

## Project Structure

```
mystery-files/
├── project.godot              # Godot project configuration
├── icon.svg                   # App icon
├── README.md                  # This file
├── .gitignore                 # Git ignore rules
├── .gitattributes             # Git LFS configuration
│
├── scenes/                    # Scene files (.tscn)
│   ├── ui/
│   │   ├── main_menu.tscn
│   │   ├── explore.tscn
│   │   ├── dialogue.tscn
│   │   ├── ending.tscn
│   │   ├── archive.tscn
│   │   └── settings.tscn
│   ├── characters/
│   └── common/
│
├── scripts/                   # GDScript files (.gd)
│   ├── autoload/              # Global singletons
│   │   ├── event_bus.gd
│   │   ├── game_state.gd
│   │   ├── story_manager.gd
│   │   ├── npc_manager.gd
│   │   ├── clue_manager.gd
│   │   ├── audio_manager.gd
│   │   ├── save_manager.gd
│   │   ├── ai_service.gd
│   │   └── voice_service.gd
│   ├── scenes/                # Scene scripts
│   │   ├── main_menu.gd
│   │   ├── explore.gd
│   │   ├── dialogue.gd
│   │   ├── ending.gd
│   │   ├── archive.gd
│   │   └── settings.gd
│   ├── components/            # Reusable components
│   │   ├── typewriter_label.gd
│   │   ├── sound_wave.gd
│   │   └── voice_button.gd
│   └── utils/                 # Utilities
│       ├── logger.gd
│       └── constants.gd
│
├── resources/                 # Game resources
│   ├── sprites/               # Pixel art
│   │   ├── characters/
│   │   ├── scenes/
│   │   ├── items/
│   │   └── ui/
│   ├── audio/                 # Audio files
│   │   ├── bgm/
│   │   ├── sfx/
│   │   └── ambient/
│   └── fonts/                 # Fonts
│
├── data/                      # Game data
│   ├── story_templates/       # Story templates
│   │   └── sample_story.json
│   ├── npcs/                  # NPC data
│   │   ├── npc_doctor.json
│   │   ├── npc_butler.json
│   │   └── npc_nephew.json
│   ├── dialogues/             # Dialogue data
│   └── config/                # Configuration
│       ├── ai_config.example.json
│       └── game_config.json
│
├── assets/                    # Additional assets
│   ├── models/                # AI models (ONNX)
│   └── vocab/                 # Prompts and vocab
│       └── story_prompts.json
│
├── ios/                       # iOS specific
│   ├── GodotProject/          # Xcode project (generated)
│   ├── Frameworks/            # iOS frameworks
│   └── README.md              # iOS export guide
│
└── export_presets/            # Export presets
    └── ios_export_preset.godot
```

---

## Core Systems

### Autoload Singletons (9 managers)

| Manager | File | Purpose |
|---------|------|---------|
| EventBus | `event_bus.gd` | Global event system |
| GameState | `game_state.gd` | State machine |
| StoryManager | `story_manager.gd` | Story progression |
| NPCManager | `npc_manager.gd` | NPC dialogue |
| ClueManager | `clue_manager.gd` | Clue tracking |
| AudioManager | `audio_manager.gd` | Audio playback |
| SaveManager | `save_manager.gd` | Save/load |
| AIService | `ai_service.gd` | Cloud AI + Local AI |
| VoiceService | `voice_service.gd` | Speech recognition |

---

## Configuration

### AI Configuration

Edit `data/config/ai_config.json`:

```json
{
  "cloud": {
    "api_key": "YOUR_API_KEY",
    "endpoint": "https://api.openai.com/v1/chat/completions",
    "model": "gpt-4"
  }
}
```

### iOS Export

1. Open `project.godot`
2. Configure Bundle Identifier
3. Set Team ID
4. Export to Xcode

See `ios/README.md` for detailed instructions.

---

## Documentation

| Document | Path |
|----------|------|
| UI/UX Requirements | `../docs/requirements/Game_UI_UX_Requirements.md` |
| Technical Architecture | `../docs/technical/Game_Technical_Architecture.md` |
| Implementation Plan | `../docs/plans/mystery-game-implementation.md` |

---

## Next Steps

1. **Add Audio**: Place BGM and SFX in `resources/audio/`
2. **Add Sprites**: Place pixel art in `resources/sprites/`
3. **Configure API**: Add your LLM API key
4. **Test**: Run in Godot Editor
5. **Export**: Export to Xcode for iOS testing

---

## License

All rights reserved.
