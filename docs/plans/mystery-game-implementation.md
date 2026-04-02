# Mystery Files - Implementation Plan

> **Goal**: Build iOS mystery narrative game MVP with core gameplay loop (Explore → Dialogue → Ending)
> **Architecture**: Layered + State Machine + Event Driven (Godot 4.x)
> **Timeline**: 42 days (6 weeks)

---

## Phase 0: Project Initialization (2 days)

### Task 0.1: Create Godot Project
- **Action**: Initialize Godot 4.x project
- **Files**: `project.godot`, `icon.svg`
- **Verify**: Window 1280x720, Forward Plus renderer, texture filter off

### Task 0.2: Create Directory Structure
- **Action**: Create all directories per architecture doc
- **Verify**: scenes/, scripts/, resources/, data/, assets/

### Task 0.3: Setup Git Repository
- **Action**: Initialize Git, create .gitignore and .gitattributes
- **Verify**: LFS configured for large files

---

## Phase 1: Core Framework (5 days)

### Task 1.1: EventBus (`scripts/autoload/event_bus.gd`)
- Create signal definitions for all events
- Configure as Autoload in project.godot

### Task 1.2: GameState (`scripts/autoload/game_state.gd`)
- Implement state machine with MENU/EXPLORE/DIALOGUE/ENDING states
- State transition logic with signals

### Task 1.3: StoryManager (`scripts/autoload/story_manager.gd`)
- Story data structure and progress tracking
- Clue collection and NPC interaction tracking

### Task 1.4: NPCManager (`scripts/autoload/npc_manager.gd`)
- NPC data loading and caching
- Dialogue response generation interface

### Task 1.5: ClueManager (`scripts/autoload/clue_manager.gd`)
- Clue registration and collection tracking
- Query methods for collected/missing clues

### Task 1.6: SaveManager (`scripts/autoload/save_manager.gd`)
- ConfigFile-based save/load
- Auto-create saves directory

### Task 1.7: AudioManager (`scripts/autoload/audio_manager.gd`)
- BGM and SFX playback
- Audio bus routing

---

## Phase 2: UI Scenes (8 days)

### Task 2.1: Main Menu (`scenes/ui/main_menu.tscn`)
- Logo, New Game, Continue, Archive, Settings buttons
- Continue button shows only when save exists

### Task 2.2: Explore Scene (`scenes/ui/explore.tscn`)
- Chapter title, 16:9 scene image, interaction buttons
- Click-to-interact with highlighted objects

### Task 2.3: Dialogue Scene (`scenes/ui/dialogue.tscn`)
- NPC portrait center, dialogue box bottom
- Voice button with waveform animation

### Task 2.4: TypewriterLabel Component (`scripts/components/typewriter_label.gd`)
- Character-by-character text display
- Typing sound effect per character

### Task 2.5: SoundWave Component (`scripts/components/sound_wave.gd`)
- 5-7 bar pixel waveform animation
- Updates with voice amplitude

### Task 2.6: Ending Scene (`scenes/ui/ending.tscn`)
- Chapter Complete badge, ending name, star rating
- Statistics panel, Q&A section

### Task 2.7: Archive Scene (`scenes/ui/archive.tscn`)
- Player statistics cards
- Case history list, achievement badges

### Task 2.8: Settings Scene (`scenes/ui/settings.tscn`)
- Audio sliders (BGM/SFX/Ambient)
- Voice settings, display options, data management

---

## Phase 3: AI Service Integration (5 days)

### Task 3.1: AIService Base (`scripts/autoload/ai_service.gd`)
- HTTP client for cloud LLM API
- generate_story() and get_dialogue_response() methods

### Task 3.2: Cloud LLM Configuration
- `data/config/ai_config.json` with API credentials
- Environment-based config (exclude from Git)

### Task 3.3: Story Prompt Templates
- `assets/vocab/story_prompts.json`
- System prompt and response format

### Task 3.4: Local Model Integration (Optional)
- ONNX Runtime GDNative setup
- Load dialogue model for offline inference

---

## Phase 4: Voice Service Integration (4 days)

### Task 4.1: VoiceService (`scripts/autoload/voice_service.gd`)
- Voice state machine (IDLE/LISTENING/RECOGNIZING)
- Signal emissions for UI updates

### Task 4.2: iOS Speech Framework Plugin
- GDNative plugin for native iOS integration
- SFSpeechRecognizer wrapper

### Task 4.3: VoiceButton Component (`scripts/components/voice_button.gd`)
- Hold-to-talk button behavior
- Connect to VoiceService

### Task 4.4: Voice Interaction Flow Testing
- Test recording → recognition → display flow
- Error handling for failed recognition

---

## Phase 5: Audio System (3 days)

### Task 5.1: Audio Bus Configuration
- Create BGM, SFX, Ambient buses in Godot
- Set default volume levels

### Task 5.2: Audio Asset Preparation
- 5-8 BGM tracks, 15-20 SFX, 3-5 ambient sounds
- OGG/Vorbis format for music, WAV for SFX

### Task 5.3: Fade In/Out Implementation
- Tween-based volume transitions
- Duck BGM during dialogue (-10dB)

---

## Phase 6: Content Production (10 days)

### Task 6.1: Pixel Character Sprites
- 3-4 NPCs with 3-4 expressions each
- 128x128 or 256x256, 16-bit style, PNG

### Task 6.2: Pixel Scene Backgrounds
- 4 scenes: Office, Living Room, Study, Street
- 1920x1080 (16:9), PNG

### Task 6.3: UI Asset Production
- Buttons (normal/hover/click states)
- Dialogue box, icons, badges

### Task 6.4: First Story Template
- `data/story_templates/template_mansion.json`
- Complete 3-chapter mystery with 3 endings

---

## Phase 7: Testing & Release (5 days)

### Task 7.1: Functional Testing
- All buttons and interactions
- Full dialogue flow
- Voice recognition accuracy
- Save/load functionality

### Task 7.2: Performance Testing
- FPS stability (target 60)
- Memory usage (<500MB)
- Load times (<3 seconds)

### Task 7.3: iOS Build & Test
- Configure iOS export preset
- Code signing setup
- Real device testing

### Task 7.4: Bug Fixes
- Prioritize and fix critical bugs
- Regression testing

### Task 7.5: App Store Preparation
- App icon (1024x1024)
- 5 screenshots
- Description and privacy policy

---

## Done When

- [ ] All 6 UI scenes implemented
- [ ] All 9 autoload managers working
- [ ] Cloud LLM story generation functional
- [ ] Local voice recognition working
- [ ] Complete story template ready
- [ ] iOS build runs on device
- [ ] All functional tests pass

---

*Generated: 2026-03-27*
*Next Review: After Phase 1 completion*
