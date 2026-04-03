# Mystery Files - Remaining Development Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 完成 Mystery Files iOS 悬疑叙事游戏 MVP 开发

**Architecture:** 分层架构 + 状态机 + 事件驱动，基于 Godot 4.x 引擎

**Tech Stack:** Godot 4.x, GDScript, iOS Speech Framework, MiniMax API

---

## 项目现状总结

| 阶段 | 状态 | 完成度 |
|------|------|--------|
| Phase 0: 项目初始化 | ✅ 完成 | 100% |
| Phase 1: 核心框架 | ✅ 完成 | 100% |
| Phase 2: UI场景 | ✅ 完成 | 100% |
| Phase 3: AI服务 | ⚠️ 部分完成 | 80% (本地模型可选) |
| Phase 4: 语音服务 | ⚠️ 部分完成 | 50% (缺少iOS插件) |
| Phase 5: 音频系统 | ⬜ 未开始 | 0% |
| Phase 6: 内容制作 | ⬜ 未开始 | 0% |
| Phase 7: 测试发布 | ⬜ 未开始 | 0% |

---

## Phase A: iOS Speech Framework 插件开发

### Task A.1: 创建 GDNative 插件结构

**Files:**
- Create: `godot-engine/plugins/ios_speech/plugin.cfg`
- Create: `godot-engine/plugins/ios_speech/ios_speech.cpp`
- Create: `godot-engine/plugins/ios_speech/ios_speech.h`

**Step 1: 创建插件配置文件**

Create: `godot-engine/plugins/ios_speech/plugin.cfg`
```ini
[plugin]
name="iOS Speech Recognition"
description="Native iOS Speech Framework integration for Godot 4.x"
author="Mystery Files Team"
version="1.0.0"
script="ios_speech.gdextension"
```

**Step 2: 创建 iOS Speech 头文件**

Create: `godot-engine/plugins/ios_speech/ios_speech.h`
```cpp
#ifndef IOS_SPEECH_H
#define IOS_SPEECH_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/ref.hpp>
#include <godot_cpp/variant/array.hpp>
#include <speech/speech.h>

namespace godot {

class IOSSpeech : public Node {
    GDCLASS(IOSSpeech, Node);

private:
    SFSpeechRecognizer *recognizer;
    SFSpeechAudioBufferRecognitionRequest * recognition_request;
    AVAudioEngine *audio_engine;
    bool is_recording;

protected:
    static void _bind_methods();

public:
    IOSSpeech();
    ~IOSSpeech();

    void request_permissions();
    bool check_permissions();
    void start_recording();
    void stop_recording();
    String get_transcription();

    void _ready() override;
    void _process(double delta) override;

signals:
    void transcription_completed(String text);
    void recording_started();
    void recording_stopped();
    void error_occurred(String error_message);
};

}

#endif
```

**Step 3: 创建插件编译配置**

Create: `godot-engine/plugins/ios_speech/ios_speech.gdextension`
```json
{
    "entry_symbol": "ios_speech_init",
    "dependency_bitset": "16",
    "compile_times": "0",
    "struct_offset": "0",
    "symbols": []
}
```

---

### Task A.2: 实现 VoiceService 与 iOS 插件对接

**Files:**
- Modify: `godot-engine/scripts/autoload/voice_service.gd`
- Modify: `godot-engine/scripts/components/voice_button.gd`

**Step 1: 更新 VoiceService 连接原生插件**

Modify: `godot-engine/scripts/autoload/voice_service.gd`

添加插件初始化逻辑：
```gdscript
func _ready() -> void:
    if OS.get_name() == "iOS":
        init_native_plugin()

func init_native_plugin() -> void:
    # 尝试获取 iOS Speech 插件
    var plugin = Engine.get_singleton("IOSSpeech")
    if plugin:
        plugin.connect("transcription_completed", _on_transcription_completed)
        plugin.connect("error_occurred", _on_speech_error)
        _native_plugin = plugin
```

---

## Phase B: 音频系统

### Task B.1: 配置 Godot 音频总线

**Files:**
- Modify: `godot-engine/project.godot`
- Modify: `godot-engine/scripts/autoload/audio_manager.gd`

**Step 1: 在 project.godot 添加音频总线配置**

Modify: `godot-engine/project.godot` (在 `[audio]` 部分后添加)

```ini
[audio]

[audio.buses]

bus/0/name="Master"
bus/0/volume_db=0.0
bus/0/send=""

bus/1/name="BGM"
bus/1/volume_db=0.0
bus/1/send="Master"

bus/2/name="SFX"
bus/2/volume_db=0.0
bus/2/send="Master"

bus/3/name="Ambient"
bus/3/volume_db=-6.0
bus/3/send="Master"
```

**Step 2: 实现淡入淡出功能**

Modify: `godot-engine/scripts/autoload/audio_manager.gd`

添加淡入淡出方法：
```gdscript
func fade_in_bgm(track_id: String, duration: float = 1.0) -> void:
    var player = _get_or_create_bgm_player(track_id)
    player.volume_db = -80.0
    player.play()
    var tween = create_tween()
    tween.tween_property(player, "volume_db", 0.0, duration)
    current_bgm = track_id

func fade_out_bgm(duration: float = 1.0) -> void:
    if not current_bgm_player:
        return
    var tween = create_tween()
    tween.tween_property(current_bgm_player, "volume_db", -80.0, duration)
    tween.tween_callback(current_bgm_player, "stop")
```

---

### Task B.2: 准备真实音频素材

**Files:**
- Create: `godot-engine/resources/audio/bgm/mystery_theme.ogg`
- Create: `godot-engine/resources/audio/bgm/tension.ogg`
- Create: `godot-engine/resources/audio/sfx/dialogue_type.wav`
- Create: `godot-engine/resources/audio/sfx/clue_collect.wav`
- Create: `godot-engine/resources/audio/ambient/rain.ogg`

**Note:** 使用 text-to-music skill 生成BGM：
```bash
export MINIMAX_API_KEY="your_key"
python3 skills/text-to-music/lyric-generate.py  # 生成悬疑氛围音乐
```

音频文件必须存放在 `build/` 目录，验证后移动到 `godot-engine/resources/audio/`。

---

## Phase C: 内容制作

### Task C.1: 生成像素角色立绘

**Files:**
- Create: `godot-engine/resources/sprites/characters/npc_doctor.png`
- Create: `godot-engine/resources/sprites/characters/npc_butler.png`
- Create: `godot-engine/resources/sprites/characters/npc_nephew.png`

**Note:** 使用 text-to-image skill 生成像素风格角色：
```bash
python3 skills/text-to-image/text-to-image.py
# prompt: "pixel art character portrait, detective, 16-bit style, 256x256"
```

输出到 `build/` 后移动到目标目录。

---

### Task C.2: 生成场景背景图

**Files:**
- Create: `godot-engine/resources/sprites/scenes/office.png`
- Create: `godot-engine/resources/sprites/scenes/study.png`
- Create: `godot-engine/resources/sprites/scenes/mansion_exterior.png`

**Note:**
```bash
# prompt: "pixel art game scene, mysterious mansion interior, 1920x1080, 16-bit style"
```

---

### Task C.3: 完成第一个故事模板

**Files:**
- Modify: `godot-engine/data/story_templates/template_mansion.json`

**结构要求:**
```json
{
    "id": "template_mansion",
    "title": "古堡之谜",
    "chapters": [
        {
            "id": "chapter_1",
            "title": "第一夜",
            "scenes": ["entrance", "study", "bedroom"],
            "clues": [" bloody_letter", "broken_watch", "mysterious_key"],
            "npcs": ["npc_butler", "npc_doctor"],
            "endings_conditions": {}
        }
    ],
    "npcs": [],
    "clues": [],
    "endings": [
        {"id": "truth", "name": "真相", "condition": "all_clues"}
    ]
}
```

---

## Phase D: 集成测试

### Task D.1: 场景切换测试

**Files:**
- Test: `godot-engine/scenes/ui/main_menu.tscn` → `explore.tscn`
- Test: `godot-engine/scenes/ui/explore.tscn` → `dialogue.tscn`
- Test: `godot-engine/scenes/ui/dialogue.tscn` → `ending.tscn`

**验证点:**
- [ ] 状态转换正确触发
- [ ] EventBus 信号正确发送
- [ ] 数据正确传递

---

### Task D.2: AI 服务集成测试

**Files:**
- Test: `godot-engine/scripts/autoload/ai_service.gd`
- Test: `godot-engine/scripts/autoload/story_manager.gd`

**验证点:**
- [ ] story_generation 请求成功
- [ ] 响应数据正确解析
- [ ] 故事数据正确存储

---

### Task D.3: 语音交互流程测试

**Files:**
- Test: `godot-engine/scripts/components/voice_button.gd`
- Test: `godot-engine/scripts/autoload/voice_service.gd`

**验证点:**
- [ ] 录音开始/停止正常
- [ ] 语音识别结果正确
- [ ] 对话流程正确响应

---

## Phase E: iOS 构建与发布

### Task E.1: iOS Export 配置

**Files:**
- Modify: `godot-engine/ios/export_presets.cfg`

**Step 1: 创建导出配置**

```ini
[preset.0]
name="iOS"
platform="iOS"
runnable=true
custom_features=""
export_filter="all_resources"
include_filter=""
exclude_filter=""
export_path="ios_build/MysteryFiles.ipa"
```

---

### Task E.2: App Store 准备

**Files:**
- Create: `godot-engine/icons/app_icon.png` (1024x1024)
- Create: `godot-engine/icons/screenshot_1.png` (按需)
- Modify: `godot-engine/ios/Info.plist`

---

## 执行顺序

1. **Phase A** → iOS Speech 插件（优先级最高，语音是核心功能）
2. **Phase B** → 音频系统（基础功能）
3. **Phase C** → 内容制作（美术资源）
4. **Phase D** → 集成测试
5. **Phase E** → iOS 构建

---

## Done When

- [ ] iOS Speech Framework 插件正常工作
- [ ] 音频淡入淡出效果实现
- [ ] 真实音频素材替换占位符
- [ ] 像素角色和场景完成
- [ ] 完整故事模板可运行
- [ ] 所有场景切换正常
- [ ] AI 故事生成功能正常
- [ ] iOS 真机测试通过
- [ ] App Store 包可导出

---

*Plan Created: 2026-04-03*
*For: Mystery Files - iOS Mystery Narrative Game*
