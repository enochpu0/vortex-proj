# 📦 Mystery Files - 完整项目结构

> **创建日期**: 2026-03-27
> **项目类型**: Godot 4.x iOS 游戏
> **状态**: 初始工程已完成

---

## 📁 完整目录结构

```
ui_test/
├── README.md                          # 项目主说明
├── CLAUDE.md                          # 技能包配置
│
├── docs/                              # 项目文档
│   ├── README.md                      # 文档索引
│   ├── requirements/                  # 需求文档
│   │   └── Game_UI_UX_Requirements.md # UI/UX 需求
│   ├── technical/                     # 技术文档
│   │   └── Game_Technical_Architecture.md # 技术架构
│   ├── plans/                         # 实施计划
│   │   └── mystery-game-implementation.md # 开发计划
│   └── reference/                     # 参考文档
│       └── UI_Design_System_Specification.md # UI 设计规范
│
└── mystery-files/                     # Godot 游戏项目
    ├── project.godot                  # Godot 项目配置
    ├── icon.svg                       # 应用图标
    ├── README.md                      # 项目说明
    ├── PROJECT_INDEX.md               # 项目索引
    ├── .gitignore                     # Git 忽略
    ├── .gitattributes                 # Git LFS 配置
    │
    ├── scenes/                        # 场景文件
    │   └── ui/
    │       ├── main_menu.tscn         # 主菜单
    │       ├── explore.tscn           # 探索场景
    │       ├── dialogue.tscn          # 对话场景
    │       ├── ending.tscn            # 结局场景
    │       ├── archive.tscn           # 档案场景
    │       └── settings.tscn          # 设置场景
    │
    ├── scripts/                       # GDScript 脚本
    │   ├── autoload/                  # 全局单例 (9 个)
    │   │   ├── event_bus.gd           # 事件总线
    │   │   ├── game_state.gd          # 游戏状态机
    │   │   ├── story_manager.gd       # 故事管理
    │   │   ├── npc_manager.gd         # NPC 管理
    │   │   ├── clue_manager.gd        # 线索管理
    │   │   ├── audio_manager.gd       # 音频管理
    │   │   ├── save_manager.gd        # 存档管理
    │   │   ├── ai_service.gd          # AI 服务
    │   │   └── voice_service.gd       # 语音服务
    │   ├── scenes/                    # 场景脚本 (6 个)
    │   │   ├── main_menu.gd
    │   │   ├── explore.gd
    │   │   ├── dialogue.gd
    │   │   ├── ending.gd
    │   │   ├── archive.gd
    │   │   └── settings.gd
    │   ├── components/                # 可复用组件 (3 个)
    │   │   ├── typewriter_label.gd    # 打字机效果
    │   │   ├── sound_wave.gd          # 声波动画
    │   │   └── voice_button.gd        # 语音按钮
    │   └── utils/                     # 工具类 (2 个)
    │       ├── logger.gd              # 日志工具
    │       └── constants.gd           # 常量定义
    │
    ├── resources/                     # 资源文件
    │   ├── sprites/README.md          # 像素素材说明
    │   └── audio/README.md            # 音频资源说明
    │
    ├── data/                          # 游戏数据
    │   ├── story_templates/
    │   │   └── sample_story.json      # 示例故事模板
    │   ├── npcs/
    │   │   ├── npc_doctor.json        # 医生 NPC
    │   │   ├── npc_butler.json        # 管家 NPC
    │   │   └── npc_nephew.json        # 侄子 NPC
    │   └── config/
    │       ├── ai_config.example.json # AI 配置示例
    │       └── game_config.json       # 游戏配置
    │
    ├── assets/                        # 额外资源
    │   └── vocab/
    │       └── story_prompts.json     # 故事提示词
    │
    ├── ios/                           # iOS 导出
    │   ├── GodotProject/.gitkeep      # Xcode 项目 (生成)
    │   ├── Frameworks/.gitkeep        # iOS 框架
    │   └── README.md                  # iOS 导出指南
    │
    └── export_presets/
        └── ios_export_preset.godot    # iOS 导出预设
```

---

## 📊 文件统计

| 类别 | 数量 |
|------|------|
| **场景文件 (.tscn)** | 6 |
| **脚本文件 (.gd)** | 20 |
| **数据文件 (.json)** | 6 |
| **配置文件** | 3 |
| **文档文件 (.md)** | 8 |

---

## ✅ 已完成

### 核心系统
- [x] 事件总线 (EventBus)
- [x] 游戏状态机 (GameState)
- [x] 故事管理器 (StoryManager)
- [x] NPC 管理器 (NPCManager)
- [x] 线索管理器 (ClueManager)
- [x] 音频管理器 (AudioManager)
- [x] 存档管理器 (SaveManager)
- [x] AI 服务 (AIService)
- [x] 语音服务 (VoiceService)

### UI 场景
- [x] 主菜单 (main_menu)
- [x] 探索场景 (explore)
- [x] 对话场景 (dialogue)
- [x] 结局场景 (ending)
- [x] 档案场景 (archive)
- [x] 设置场景 (settings)

### 组件
- [x] 打字机效果标签 (TypewriterLabel)
- [x] 声波动画 (SoundWave)
- [x] 语音按钮 (VoiceButton)

### 配置
- [x] Godot 项目配置 (project.godot)
- [x] iOS 导出预设
- [x] AI 服务配置
- [x] 游戏配置

### 数据
- [x] 示例故事模板
- [x] 3 个 NPC 数据
- [x] 提示词模板

---

## 🔧 待完成

### 资源制作
- [ ] 像素角色立绘 (3 个 NPC × 6 表情)
- [ ] 像素场景背景 (6 个场景)
- [ ] 线索图标 (6 个)
- [ ] UI 元素 (按钮、边框等)
- [ ] BGM 音乐 (4 首)
- [ ] 音效 (4 个)
- [ ] 环境音 (3 个)

### 功能完善
- [ ] iOS 语音识别插件集成
- [ ] 本地 AI 模型集成 (ONNX)
- [ ] 云端 LLM API 对接
- [ ] 实际故事内容制作

---

## 🚀 使用方式

### 1. 打开项目

```bash
cd mystery-files
# 在 Godot Editor 4.x 中打开 project.godot
```

### 2. 配置 API Key

编辑 `data/config/ai_config.json`:

```json
{
  "cloud": {
    "api_key": "sk-your-api-key-here"
  }
}
```

### 3. 运行项目

在 Godot Editor 中按 F5 运行

### 4. 导出 iOS

1. Project → Export → iOS
2. 保存到 `ios/GodotProject/`
3. 在 Xcode 中打开并签名
4. 部署到 iOS 设备

---

## 📖 相关文档

| 文档 | 说明 |
|------|------|
| [PROJECT_INDEX.md](mystery-files/PROJECT_INDEX.md) | 项目完整索引 |
| [README.md](mystery-files/README.md) | 项目说明 |
| [ios/README.md](mystery-files/ios/README.md) | iOS 导出指南 |

---

*最后更新：2026-03-27*
