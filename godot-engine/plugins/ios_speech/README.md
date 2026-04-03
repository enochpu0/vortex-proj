# iOS Speech Recognition Plugin for Godot 4.x

## Overview

This plugin provides iOS Speech Framework integration for the Mystery Files Godot 4.x project, enabling real-time speech recognition using Apple's SFSpeechRecognizer API.

## Plugin Structure

```
plugins/ios_speech/
├── plugin.cfg              # Godot plugin metadata
├── ios_speech.gdextension  # GDExtension entry point
├── bin/                    # Compiled C++ library (not included)
│   └── ios_speech.extension
├── src/                    # C++ source code (placeholder structure)
│   ├── ios_speech.cpp
│   ├── ios_speech.h
│   ├── speech_recognizer.cpp
│   └── speech_recognizer.h
├── ios/                    # iOS-specific bindings
│   └── SpeechBridge.swift
└── README.md               # This file
```

## Files

### plugin.cfg

Plugin configuration file declaring:
- Plugin name and metadata
- Godot version compatibility (4.2.0+)
- iOS platform requirement
- Feature flags for speech recognition capabilities

### ios_speech.gdextension

GDExtension entry point configuration for Godot 4.x, defining:
- Library entry symbol
- Dependency on compiled extension binary
- iOS permissions for speech recognition and microphone access

## Required Implementation

This is a placeholder structure. Full implementation requires:

### 1. GDExtension C++ Code

The plugin requires C++ code using Godot 4.x's GDExtension API:
- `godot-cpp` bindings
- `NativeScript` class registration
- `MethodBinder` for exposing methods to GDScript

### 2. iOS Speech Framework Bindings

Using `SFSpeechRecognizer` from Apple's Speech Framework:
- Request speech recognition authorization
- Create and configure speech recognition requests
- Handle real-time audio input
- Process recognition results and hypotheses
- Support offline recognition when available

### 3. iOS Build Configuration

- Add to `ios/export_presets.cfg`
- Configure Info.plist permissions:
  - `NSSpeechRecognitionUsageDescription`
  - `NSMicrophoneUsageDescription`
- Link against SpeechKit framework

### 4. GDScript API (Proposed)

```gdscript
# Example usage
var speech = IOSpeech.new()

func _ready():
    speech.request_authorization()
    speech.authorization_changed.connect(_on_auth_changed)

func start_recognition():
    speech.start_recognition("en-US", {"offline": true})

func _on_auth_changed(authenticated):
    if authenticated:
        print("Speech recognition authorized")

func _on_speech_result(result):
    print("Recognized: ", result.text)
    print("Confidence: ", result.confidence)
```

## Permissions

The plugin requires the following iOS permissions (configured in Info.plist):

- **Speech Recognition**: `NSSpeechRecognitionUsageDescription`
- **Microphone**: `NSMicrophoneUsageDescription`

## Limitations

- Only available on iOS devices (not simulator for full functionality)
- Speech recognition quality depends on device hardware
- Offline recognition requires `supports_on_device_recognition` check
- Language support varies by iOS version and region

## References

- [Godot 4.x GDExtension Documentation](https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/index.html)
- [Apple Speech Framework Documentation](https://developer.apple.com/documentation/speech)
- [SFSpeechRecognizer](https://developer.apple.com/documentation/speech/sfspeechrecognizer)

---

*Created for Mystery Files project - Godot 4.x iOS Speech Recognition*
