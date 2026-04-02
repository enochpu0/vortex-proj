# iOS Export Guide

## Prerequisites

1. **Apple Developer Account** - Required for code signing
2. **Xcode 15+** - Installed on macOS
3. **Godot 4.x** - With iOS export templates installed

## Installation Steps

### 1. Install iOS Export Templates

```bash
# In Godot Editor
# Go to: Editor → Manage Export Templates → Download and Install
```

Or manually:
```bash
godot --install-build-templates
```

### 2. Configure Export Preset

1. Open Project → Export
2. Select "iOS" preset
3. Configure the following:
   - **Bundle Identifier**: `com.yourcompany.mysteryfiles`
   - **Team ID**: Your Apple Developer Team ID
   - **Code Sign Identity**: iPhone Developer (debug) / iPhone Distribution (release)

### 3. Set Privacy Permissions

The following privacy descriptions are required:

- **Microphone**: For voice interaction with NPCs
- **Speech Recognition**: For voice input processing

Edit `project.godot`:
```ini
[iOS]
privacy/microphone_usage_description="Need microphone access for voice interaction"
privacy/speech_recognition_usage_description="Need speech recognition for voice input"
```

### 4. Export to Xcode

1. In Godot Editor: Project → Export → iOS
2. Click "Save" to export
3. Choose output directory: `ios/GodotProject/`

### 5. Open in Xcode

```bash
cd ios/GodotProject
open GodotProject.xcodeproj
```

### 6. Code Signing in Xcode

1. Select project in Xcode sidebar
2. Go to "Signing & Capabilities"
3. Select your Team
4. Ensure Bundle Identifier matches

### 7. Build and Run

1. Connect iOS device
2. Select device as target
3. Press ⌘R to build and run

## Troubleshooting

### Issue: "No provisioning profiles found"
**Solution**: Go to Xcode Preferences → Accounts → Download Manual Profiles

### Issue: "Code signing identity not found"
**Solution**: Ensure you have valid certificates in Keychain Access

### Issue: "Speech Framework not available"
**Solution**: Minimum iOS version should be 15.0+

## App Store Submission

1. Create App Store Connect entry
2. Prepare screenshots (5 required)
3. Write description and keywords
4. Submit for review

## References

- [Godot iOS Export Docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
