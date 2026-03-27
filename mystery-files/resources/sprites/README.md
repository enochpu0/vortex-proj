# Sprite Resources

Place your pixel art sprites in these directories:

## Characters
- `characters/` - Character portraits and sprites

Required character sprites (128x128 or 256x256, 16-bit pixel style):
- `doctor/` - Doctor NPC sprites
  - `normal.png` - Neutral expression
  - `smile.png` - Happy expression
  - `mad.png` - Angry expression
  - `shock.png` - Surprised expression
  - `puzzle.png` - Confused expression
  - `concerned.png` - Sad/concerned expression

- `butler/` - Butler NPC sprites
  - `normal.png`, `polite_smile.png`, `stern.png`, `startled.png`, `uncertain.png`, `somber.png`

- `nephew/` - Nephew NPC sprites
  - `normal.png`, `relieved.png`, `angry.png`, `shocked.png`, `confused.png`, `worried.png`

## Scenes
- `scenes/` - Background scenes (1920x1080, 16:9 aspect ratio)

Required scenes:
- `study.png` - Study room
- `living_room.png` - Living room
- `hallway.png` - Hallway
- `office.png` - Office
- `garden.png` - Garden
- `kitchen.png` - Kitchen

## Items
- `items/` - Clue and item icons (64x64 or 128x128)

Required items:
- `letter.png` - Bloodstained letter
- `watch.png` - Broken pocket watch
- `photo.png` - Old photograph
- `medicine.png` - Medicine bottle
- `key.png` - Mysterious key
- `diary.png` - Victim's diary

## UI
- `ui/` - UI elements and icons

Required UI elements:
- `buttons/` - Button sprites (normal, hover, pressed states)
- `frames/` - Dialog frames and borders
- `icons/` - Various icons (clue, settings, back, etc.)

## Sprite Specifications

| Type | Size | Style | Format |
|------|------|-------|--------|
| Character | 128x128 / 256x256 | 16-bit pixel | PNG (transparent) |
| Scene | 1920x1080 | 16-bit pixel | PNG |
| Item | 64x64 / 128x128 | 16-bit pixel | PNG (transparent) |
| UI | Variable | 16-bit pixel | PNG (transparent) |

## Color Palette (Recommended)

Use a consistent 16-bit color palette:
- Primary: #2EC4B6 (Teal/Cyan)
- Secondary: #E74C3C (Red for accents)
- Dark: #1A1A2E (Dark blue/black)
- Light: #F5F5F5 (Off-white)
