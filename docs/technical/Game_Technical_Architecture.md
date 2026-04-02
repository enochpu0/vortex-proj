# 悬疑叙事游戏 - 技术架构文档

> **文档类型**: 技术架构设计文档 (TAD)
> **版本**: 1.0.0
> **创建日期**: 2026-03-27
> **状态**: 待评审
> **关联文档**: [UI/UX 需求文档](../requirements/Game_UI_UX_Requirements.md)

---

## 目录

1. [架构概述](#1-架构概述)
2. [技术选型](#2-技术选型)
3. [系统架构](#3-系统架构)
4. [目录结构](#4-目录结构)
5. [核心模块设计](#5-核心模块设计)
6. [数据流设计](#6-数据流设计)
7. [AI 服务设计](#7-ai-服务设计)
8. [语音服务设计](#8-语音服务设计)
9. [数据存储设计](#9-数据存储设计)
10. [音频系统设计](#10-音频系统设计)
11. [性能优化](#11-性能优化)
12. [安全考虑](#12-安全考虑)

---

## 1. 架构概述

### 1.1 架构目标

| 目标 | 描述 |
|------|------|
| **可维护性** | 清晰的分层结构，模块职责单一 |
| **可扩展性** | 易于添加新功能、新故事模板 |
| **性能** | iOS 设备流畅运行 (60 FPS) |
| **离线能力** | 核心功能支持离线使用 |
| **低耦合** | 模块间通过事件总线通信 |

### 1.2 架构模式

采用 **分层架构 + 状态机 + 事件驱动** 的混合模式：

```
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                    │
│              (UI 场景、对话 UI、HUD、动画)                │
├─────────────────────────────────────────────────────────┤
│                   Game State Machine                    │
│           (Menu → Explore → Dialogue → Ending)          │
├─────────────────────────────────────────────────────────┤
│                   Business Logic Layer                  │
│        (Story/NPC/Clue/Audio Manager + Event Bus)       │
├─────────────────────────────────────────────────────────┤
│                   Service Layer                         │
│              (AI Service + Voice Service)               │
├─────────────────────────────────────────────────────────┤
│                   Data Layer                            │
│           (SaveData + StoryDB + ConfigDB)               │
└─────────────────────────────────────────────────────────┘
```

### 1.3 设计原则

| 原则 | 说明 |
|------|------|
| **单一职责** | 每个模块只负责一个功能领域 |
| **事件驱动** | 模块间通过事件总线解耦通信 |
| **依赖倒置** | 高层模块不依赖低层模块具体实现 |
| **状态隔离** | 游戏状态由状态机统一管理 |

---

## 2. 技术选型

### 2.1 核心技术栈

| 层级 | 技术 | 版本 | 说明 |
|------|------|------|------|
| **游戏引擎** | Godot Engine | 4.x | 开源、轻量、2D 友好 |
| **编程语言** | GDScript | 2.0 | Python-like，易学易用 |
| **构建工具** | Godot Editor | 4.x | 内置编辑器 |
| **版本控制** | Git + Git LFS | - | 大文件管理 |

### 2.2 第三方库/插件

| 名称 | 用途 | 必需 |
|------|------|------|
| **Godot Speech Plugin** | 语音识别集成 | ✅ |
| **ONNX Runtime GDNative** | 本地 AI 模型推理 | ✅ |
| **Godot HTTP Client** | HTTP 请求 | 内置 |
| **Godot Audio Bus** | 音频混音 | 内置 |

### 2.3 外部服务

| 服务 | 用途 | 依赖 |
|------|------|------|
| **OpenAI API / 国产大模型** | 云端故事生成 | 需要网络 |
| **本地小模型** | NPC 对话生成 | 离线可用 |
| **iOS Speech Framework** | 语音识别 | 离线可用 |

### 2.4 技术选型理由

#### 为什么选择 Godot？

| 因素 | 说明 |
|------|------|
| **轻量级** | 包体积仅 ~20MB (Unity ~50MB+) |
| **2D 像素友好** | Pixel Perfect Camera 内置支持 |
| **开源免费** | 无版税，无收入分成 |
| **Scene/Node 架构** | 天然适合 UI 场景组织 |
| **GDScript** | 学习曲线平缓，开发效率高 |

#### 为什么 AI 采用云端 + 本地混合？

| 方案 | 用途 | 优势 |
|------|------|------|
| **云端 LLM** | 故事生成 | 高质量、复杂剧情 |
| **本地小模型** | NPC 对话 | 低延迟、离线可用、隐私保护 |

---

## 3. 系统架构

### 3.1 整体架构图

```
┌─────────────────────────────────────────────────────────────────┐
│                        Godot 游戏引擎                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                   Presentation Layer                       │ │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐     │ │
│  │  │ UI 场景   │ │ 对话 UI   │ │ HUD 层    │ │ 过渡动画  │     │ │
│  │  │ Scenes   │ │ Dialogue │ │ HUD      │ │ Transitions│    │ │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘     │ │
│  └────────────────────────────────────────────────────────────┘ │
│                              ↕                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                   Game State Machine                       │ │
│  │     Menu → Explore → Dialogue → Ending → Archive          │ │
│  └────────────────────────────────────────────────────────────┘ │
│                              ↕                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                   Business Logic Layer                     │ │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐     │ │
│  │  │ 故事管理  │ │ NPC 管理  │ │ 线索管理  │ │ 音频管理  │     │ │
│  │  │ StoryMgr │ │ NPCMgr   │ │ ClueMgr  │ │ AudioMgr │     │ │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘     │ │
│  └────────────────────────────────────────────────────────────┘ │
│                              ↕                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                   Service Layer                            │ │
│  │  ┌──────────────────┐ ┌──────────────────┐                │ │
│  │  │   AI Service     │ │   Voice Service  │                │ │
│  │  │  ├─ Cloud LLM    │ │  ├─ Local STT    │                │ │
│  │  │  └─ Local Model  │ │  └─ VAD          │                │ │
│  │  └──────────────────┘ └──────────────────┘                │ │
│  └────────────────────────────────────────────────────────────┘ │
│                              ↕                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                   Data Layer                               │ │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐     │ │
│  │  │ SaveData │ │ StoryDB │ │ ConfigDB │ │ HistoryDB│     │ │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘     │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                   Event Bus (全局事件)                      │ │
│  │   StoryEvent | DialogueEvent | AudioEvent | SaveEvent     │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 模块依赖关系

```
                    ┌─────────────┐
                    │   UI Scenes │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │  GameState  │
                    │  (状态机)    │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
       ┌──────▼──────┐ ┌──▼────────┐ ┌─▼──────────┐
       │  Managers   │ │ EventBus  │ │ Services   │
       │ (业务逻辑)   │ │ (事件总线) │ │ (AI/Voice) │
       └──────┬──────┘ └───────────┘ └─────┬──────┘
              │                             │
              └──────────────┬──────────────┘
                             │
                    ┌────────▼────────┐
                    │   Data Layer    │
                    │  (Storage/DB)   │
                    └─────────────────┘
```

### 3.3 游戏状态流转

```
┌─────────────┐
│    MENU     │ ◄─────────────────────────────────┐
│   主菜单     │                                   │
└──────┬──────┘                                   │
       │ 开始新游戏                                 │
       ▼                                          │
┌─────────────┐     触发章节结束     ┌────────────┐│
│   EXPLORE   │ ───────────────────► │  ENDING    ││
│   探索场景   │                     │  结局结算   ││
└──────┬──────┘                     └─────┬──────┘│
       │ 进入对话                          │ 下一案件
       ▼                                   │
┌─────────────┐                            │
│  DIALOGUE   │ ───────────────────────────┘
│   对话场景   │
└──────┬──────┘
       │ 返回
       ▼
┌─────────────┐
│   ARCHIVE   │
│   档案记录   │
└─────────────┘
```

---

## 4. 目录结构

### 4.1 项目根目录

```
mystery-files/
├── project.godot                    # Godot 项目配置
├── icon.svg                         # 游戏图标
├── README.md                        # 项目说明
├── .gitignore                       # Git 忽略配置
└── .gitattributes                   # Git LFS 配置
```

### 4.2 场景目录 (`scenes/`)

```
scenes/
├── ui/                              # UI 场景
│   ├── main_menu.tscn               # 主菜单场景
│   ├── explore.tscn                 # 探索场景
│   ├── dialogue.tscn                # 对话场景
│   ├── ending.tscn                  # 结局结算场景
│   ├── archive.tscn                 # 档案记录场景
│   └── settings.tscn                # 设置界面场景
│
├── characters/                      # 角色场景
│   ├── npc_base.tscn                # NPC 基础场景
│   ├── npc_doctor.tscn              # 医生 NPC
│   ├── npc_detective.tscn           # 侦探 NPC
│   └── player.tscn                  # 玩家场景
│
└── common/                          # 通用场景
    ├── transition.tscn              # 转场动画场景
    ├── loading.tscn                 # 加载界面场景
    └── confirmation_dialog.tscn     # 确认对话框场景
```

### 4.3 脚本目录 (`scripts/`)

```
scripts/
├── autoload/                        # 全局单例 (Autoload)
│   ├── game_state.gd                # 游戏状态机
│   ├── event_bus.gd                 # 全局事件总线
│   ├── story_manager.gd             # 故事管理器
│   ├── npc_manager.gd               # NPC 管理器
│   ├── clue_manager.gd              # 线索管理器
│   ├── audio_manager.gd             # 音频管理器
│   ├── save_manager.gd              # 存档管理器
│   ├── ai_service.gd                # AI 服务层
│   └── voice_service.gd             # 语音服务层
│
├── scenes/                          # 场景脚本
│   ├── main_menu.gd
│   ├── explore.gd
│   ├── dialogue.gd
│   ├── ending.gd
│   ├── archive.gd
│   └── settings.gd
│
├── components/                      # 可复用组件
│   ├── typewriter_label.gd          # 打字机效果标签
│   ├── pixel_sprite.gd              # 像素精灵
│   ├── voice_button.gd              # 语音按钮
│   ├── sound_wave.gd                # 声波动画组件
│   └── dialogue_box.gd              # 对话框组件
│
└── utils/                           # 工具类
    ├── constants.gd                 # 常量定义
    ├── logger.gd                    # 日志工具
    ├── extensions.gd                # 扩展函数
    └── json_utils.gd                # JSON 工具
```

### 4.4 资源目录 (`resources/`)

```
resources/
├── sprites/                         # 像素素材
│   ├── characters/                  # 角色立绘
│   │   ├── doctor/
│   │   ├── detective/
│   │   └── witness/
│   ├── scenes/                      # 场景图
│   │   ├── office/
│   │   ├── street/
│   │   └── mansion/
│   ├── items/                       # 道具/线索图标
│   │   ├── key.png
│   │   ├── letter.png
│   │   └── photo.png
│   └── ui/                          # UI 元素
│       ├── buttons/
│       ├── frames/
│       └── icons/
│
├── audio/                           # 音频文件
│   ├── bgm/                         # 背景音乐
│   │   ├── main_theme.ogg
│   │   ├── mystery_1.ogg
│   │   ├── tension.ogg
│   │   └── ending.ogg
│   ├── sfx/                         # 音效
│   │   ├── button_click.wav
│   │   ├── dialogue_type.wav
│   │   ├── clue_collect.wav
│   │   └── transition.wav
│   └── ambient/                     # 环境音
│       ├── rain.ogg
│       ├── clock_ticking.ogg
│       └── wind.ogg
│
└── fonts/                           # 字体文件
    ├── pixel_font.ttf               # 像素字体
    └── font_imports.cfg             # 字体导入配置
```

### 4.5 数据目录 (`data/`)

```
data/
├── story_templates/                 # 故事模板
│   ├── template_mansion.json
│   ├── template_office.json
│   └── template_street.json
│
├── npcs/                            # NPC 数据
│   ├── doctor.json
│   ├── detective.json
│   └── witness.json
│
├── dialogues/                       # 对话数据
│   ├── intro.json
│   ├── investigation.json
│   └── ending.json
│
└── config/                          # 配置文件
    ├── game_config.json
    ├── audio_config.json
    └── ai_config.json
```

### 4.6 存档目录 (`saves/` - 运行时创建)

```
saves/                               # user://saves/
├── current_save.cfg                 # 当前存档
├── history.json                     # 通关历史
└── settings.cfg                     # 设置配置
```

### 4.7 资源目录 (`assets/`)

```
assets/
├── models/                          # 本地 AI 模型
│   ├── dialogue_model.onnx          # 对话生成模型
│   └── emotion_classifier.onnx      # 情感分类模型
│
└── vocab/                           # 词表/提示词
    ├── story_prompts.json           # 故事生成提示词
    ├── npc_templates.json           # NPC 模板
    └── dialogue_patterns.json       # 对话模式
```

---

## 5. 核心模块设计

### 5.1 游戏状态机 (`game_state.gd`)

#### 职责
- 管理游戏全局状态
- 处理状态转换
- 触发状态相关事件

#### API 设计

```gdscript
class_name GameStateMachine
extends Node

# 信号
signal state_changed(from_state: State, to_state: State)

# 状态枚举
enum State {
    MENU,       # 主菜单
    EXPLORE,    # 探索场景
    DIALOGUE,   # 对话场景
    ENDING,     # 结局结算
    ARCHIVE,    # 档案记录
    SETTINGS    # 设置界面
}

# 公开方法
func change_state(new_state: State) -> void
func is_in_game() -> bool
func is_in_menu() -> bool
func get_current_state() -> State
func get_previous_state() -> State
```

#### 状态转换规则

| 当前状态 | 可转换到 | 触发条件 |
|---------|---------|---------|
| MENU | EXPLORE | 开始新游戏/继续游戏 |
| MENU | ARCHIVE | 点击档案库 |
| MENU | SETTINGS | 点击设置 |
| EXPLORE | DIALOGUE | 与 NPC 对话 |
| EXPLORE | MENU | 返回主菜单 |
| DIALOGUE | EXPLORE | 结束对话 |
| DIALOGUE | ENDING | 触发结局 |
| ENDING | ARCHIVE | 查看档案 |
| ENDING | MENU | 返回主菜单 |

---

### 5.2 全局事件总线 (`event_bus.gd`)

#### 职责
- 模块间解耦通信
- 全局事件分发
- 事件订阅/发布

#### 事件列表

```gdscript
class_name EventBusClass
extends Node

# 游戏状态事件
signal game_state_changed(from: int, to: int)

# 故事事件
signal story_started(story_id: String)
signal story_progressed(chapter: int)
signal story_ended(ending_id: String)
signal story_generated(story_data: Dictionary)

# 对话事件
signal dialogue_started(npc_id: String)
signal dialogue_line_shown(line_id: String)
signal player_spoke(text: String)
signal npc_response(text: String)

# 线索事件
signal clue_collected(clue_id: String)
signal clue_examined(clue_id: String)

# 音频事件
signal bgm_changed(track_id: String)
signal sfx_played(sfx_id: String)
signal volume_changed(bus: String, volume: float)

# 存档事件
signal game_saved(save_id: String)
signal game_loaded(save_id: String)

# 语音事件
signal voice_input_started()
signal voice_input_finished()
signal voice_recognized(text: String)
signal voice_error(error: String)
```

---

### 5.3 故事管理器 (`story_manager.gd`)

#### 职责
- 故事生成协调
- 故事进度管理
- 结局判定

#### 数据结构

```gdscript
class StoryData:
    var id: String
    var title: String
    var chapters: Array          # 章节列表
    var npcs: Array              # NPC 列表
    var clues: Array             # 线索列表
    var endings: Array           # 结局列表
    var metadata: Dictionary     # 元数据

class StoryProgress:
    var current_chapter: int
    var collected_clues: Array[String]
    var talked_npcs: Array[String]
    var visited_scenes: Array[String]
    var dialogue_history: Array[Dictionary]
```

#### 公开方法

```gdscript
class_name StoryManagerClass
extends Node

# 故事生成
func generate_new_story() -> void
func set_story(story_data: Dictionary) -> void

# 进度管理
func advance_chapter() -> void
func collect_clue(clue_id: String) -> void
func talk_to_npc(npc_id: String) -> void
func visit_scene(scene_id: String) -> void

# 结局判定
func trigger_ending() -> String
func calculate_score() -> int
func get_ending_type() -> String

# 查询
func get_current_story() -> Dictionary
func get_progress() -> Dictionary
func get_clue_count() -> int
func get_npc_count() -> int
```

---

### 5.4 NPC 管理器 (`npc_manager.gd`)

#### 职责
- NPC 数据管理
- NPC 对话生成
- NPC 表情控制

#### 数据结构

```gdscript
class NPCData:
    var id: String
    var name: String
    var role: String
    var background: String
    var personality: String
    var sprite_path: String
    var expressions: Dictionary  # 表情映射
    var dialogue_tree: Dictionary
```

#### 公开方法

```gdscript
class_name NPCManagerClass
extends Node

# NPC 管理
func load_npc(npc_id: String) -> NPCData
func get_all_npcs() -> Array

# 对话
func get_npc_response(npc_id: String, player_input: String) -> String
func get_npc_emotion(npc_id: String, context: String) -> String

# 表情
func get_npc_expression(npc_id: String, emotion: String) -> String
func set_npc_expression(npc_id: String, expression: String) -> void

# 状态
func get_npc_state(npc_id: String) -> NPCState
func set_npc_state(npc_id: String, state: NPCState) -> void
```

---

### 5.5 线索管理器 (`clue_manager.gd`)

#### 职责
- 线索收集管理
- 线索状态追踪
- 线索展示

#### 数据结构

```gdscript
class ClueData:
    var id: String
    var name: String
    var description: String
    var type: String           # physical, testimonial, documentary
    var location: String       # 发现位置
    var related_npc: String    # 相关 NPC
    var importance: int        # 1-5 重要程度
    var sprite_path: String
```

#### 公开方法

```gdscript
class_name ClueManagerClass
extends Node

func collect_clue(clue_id: String) -> void
func examine_clue(clue_id: String) -> Dictionary
func get_all_clues() -> Array[ClueData]
func get_collected_clues() -> Array[ClueData]
func get_missing_clues() -> Array[ClueData]
func is_clue_collected(clue_id: String) -> bool
```

---

## 6. 数据流设计

### 6.1 用户交互数据流

```
用户点击/语音输入
        │
        ▼
┌─────────────┐
│  UI Scene   │  ← 场景脚本处理输入
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  GameState  │  ← 检查状态是否允许操作
└──────┬──────┘
       │
       ▼
┌─────────────┐     ┌─────────────┐
│  Manager    │ ──► │   EventBus  │  ← 发布事件
└──────┬──────┘     └─────────────┘
       │
       ▼
┌─────────────┐
│  Service    │  ← AI/Voice服务处理
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Data Layer  │  ← 数据持久化
└─────────────┘
```

### 6.2 故事生成数据流

```
触发新游戏
        │
        ▼
┌─────────────┐
│StoryManager │
└──────┬──────┘
        │ 生成请求
        ▼
┌─────────────┐
│ AICloudService │  ← 云端 LLM
└──────┬──────┘
        │ 返回故事数据
        ▼
┌─────────────┐
│StoryManager │  ← 缓存故事
└──────┬──────┘
        │
        ▼
┌─────────────┐     ┌─────────────┐
│ SaveManager │────►│ Data Layer  │  ← 保存
└─────────────┘     └─────────────┘
```

### 6.3 对话交互数据流

```
用户按住说话
        │
        ▼
┌─────────────┐
│VoiceService │  ← 录音
└──────┬──────┘
        │ 音频数据
        ▼
┌─────────────┐
│ Local STT   │  ← 本地语音识别
└──────┬──────┘
        │ 识别文本
        ▼
┌─────────────┐
│ Dialogue UI │  ← 显示用户输入
└──────┬──────┘
        │
        ▼
┌─────────────┐
│ NPCManager  │  ← 请求 NPC 回应
└──────┬──────┘
        │
        ▼
┌─────────────┐
│AILocalModel │  ← 本地小模型生成对话
└──────┬──────┘
        │ NPC 回应文本
        ▼
┌─────────────┐
│ Dialogue UI │  ← 打字机效果显示
└─────────────┘
```

### 6.4 存档数据流

```
触发保存 (自动/手动)
        │
        ▼
┌─────────────┐
│StoryManager │  ← 收集故事数据
└──────┬──────┘
        │
        ▼
┌─────────────┐
│ NPCManager  │  ← 收集 NPC 数据
└──────┬──────┘
        │
        ▼
┌─────────────┐
│SaveManager  │  ← 组织存档数据
└──────┬──────┘
        │ ConfigFile
        ▼
┌─────────────┐
│ user://saves/ │  ← 写入文件
└─────────────┘
```

---

## 7. AI 服务设计

### 7.1 架构

```
┌─────────────────────────────────────────────────────────┐
│                     AI Service Layer                     │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌───────────────────┐         ┌───────────────────┐    │
│  │   Cloud Service   │         │   Local Service   │    │
│  │   (故事生成)       │         │   (NPC 对话)       │    │
│  │                   │         │                   │    │
│  │  - OpenAI API     │         │  - ONNX Model     │    │
│  │  - Anthropic API  │         │  - 量化模型        │    │
│  │  - 国产大模型      │         │  - 轻量推理        │    │
│  └─────────┬─────────┘         └─────────┬─────────┘    │
│            │                             │               │
│            └──────────────┬──────────────┘               │
│                           │                              │
│                  ┌────────▼────────┐                     │
│                  │  AI Interface   │                     │
│                  │  (统一接口)      │                     │
│                  └─────────────────┘                     │
└─────────────────────────────────────────────────────────┘
```

### 7.2 云端故事生成

#### 请求格式

```json
{
    "model": "gpt-4",
    "messages": [
        {
            "role": "system",
            "content": "你是一位悬疑故事作家，擅长创作短篇互动悬疑故事。"
        },
        {
            "role": "user",
            "content": {
                "type": "mystery",
                "length": "medium",
                "chapters": 3,
                "endings": 3,
                "npcs": 4,
                "clues": 6,
                "theme": "午夜访客"
            }
        }
    ],
    "temperature": 0.8,
    "max_tokens": 2000
}
```

#### 响应格式

```json
{
    "id": "story_001",
    "title": "午夜的访客",
    "chapters": [
        {
            "id": "chapter_1",
            "title": "第一夜",
            "scenes": ["书房", "客厅", "卧室"],
            "content": "..."
        }
    ],
    "npcs": [
        {
            "id": "npc_001",
            "name": "Dr. Smith",
            "role": "家庭医生",
            "background": "...",
            "dialogue_style": "冷静、专业"
        }
    ],
    "clues": [
        {
            "id": "clue_001",
            "name": "带血的信纸",
            "description": "...",
            "location": "书房"
        }
    ],
    "endings": [
        {
            "id": "ending_truth",
            "name": "真相的碎片",
            "condition": "收集全部线索"
        }
    ]
}
```

### 7.3 本地对话生成

#### 模型选择

| 模型 | 大小 | 用途 | 推理时间 |
|------|------|------|---------|
| **Phi-3-mini** | 3.8B | NPC 对话 | ~500ms |
| **Gemma-2B** | 2B | NPC 对话 | ~300ms |
| **Qwen-1.8B** | 1.8B | NPC 对话 | ~250ms |

#### 提示词模板

```
你是 {npc_name}，{npc_background}。
当前场景：{scene_context}
玩家说：{player_input}

请用简短的对话回应（不超过 50 字），体现你的性格：{personality}。
如果有情绪变化，请在末尾标注 [情绪]。
```

---

## 8. 语音服务设计

### 8.1 架构

```
┌─────────────────────────────────────────────────────────┐
│                   Voice Service Layer                    │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌───────────────────┐         ┌───────────────────┐    │
│  │  iOS Speech       │         │  VAD Module       │    │
│  │  Framework        │         │  (语音活动检测)    │    │
│  │                   │         │                   │    │
│  │  - SFSpeechRecognizer │    │  - 静音检测        │    │
│  │  - 离线识别       │         │  - 开始/结束判断   │    │
│  └─────────┬─────────┘         └─────────┬─────────┘    │
│            │                             │               │
│            └──────────────┬──────────────┘               │
│                           │                              │
│                  ┌────────▼────────┐                     │
│                  │ VoiceService    │                     │
│                  │ (Godot 脚本)     │                     │
│                  └─────────────────┘                     │
└─────────────────────────────────────────────────────────┘
```

### 8.2 语音识别流程

```
用户按住语音按钮
        │
        ▼
┌─────────────┐
│  开始录音   │  ← 调用 iOS Speech Framework
└──────┬──────┘
        │
        ▼
┌─────────────┐
│  VAD 检测    │  ← 检测语音开始
└──────┬──────┘
        │ 录音中...
        ▼
┌─────────────┐
│  声波动画    │  ← UI 实时反馈
└──────┬──────┘
        │
        ▼
┌─────────────┐
│  用户松手    │  ← 停止录音
└──────┬──────┘
        │
        ▼
┌─────────────┐
│  识别处理    │  ← Speech Framework 处理
└──────┬──────┘
        │ 识别文本
        ▼
┌─────────────┐
│  返回结果    │  ← 发送到对话系统
└─────────────┘
```

### 8.3 多语言支持

| 语言 | 代码 | 模型 |
|------|------|------|
| 简体中文 | zh-CN | iOS 中文模型 |
| 英文 | en-US | iOS 英文模型 |

---

## 9. 数据存储设计

### 9.1 存储方案

| 数据类型 | 存储方式 | 路径 |
|---------|---------|------|
| **游戏存档** | ConfigFile | user://saves/current_save.cfg |
| **历史记录** | JSON | user://saves/history.json |
| **设置配置** | ConfigFile | user://saves/settings.cfg |
| **故事缓存** | JSON | user://data/stories/ |
| **临时数据** | Dictionary | 内存 |

### 9.2 存档数据结构

```json
{
    "save_version": "1.0",
    "timestamp": "2026-03-27T10:30:00Z",
    "play_time": 1832,
    "story": {
        "id": "story_001",
        "title": "午夜的访客",
        "chapter": 2,
        "progress": {
            "collected_clues": ["clue_001", "clue_003"],
            "talked_npcs": ["npc_001"],
            "visited_scenes": ["scene_office"]
        }
    },
    "player": {
        "name": "侦探",
        "stats": {
            "dialogues": 15,
            "correct_guesses": 2
        }
    }
}
```

### 9.3 历史记录结构

```json
{
    "history": [
        {
            "story_id": "story_001",
            "story_title": "午夜的访客",
            "ending_id": "ending_truth",
            "ending_name": "真相的碎片",
            "score": 85,
            "play_time": 1832,
            "completed_at": "2026-03-27T11:00:00Z",
            "collected_clues": 5,
            "total_clues": 6
        }
    ]
}
```

---

## 10. 音频系统设计

### 10.1 音频总线结构

```
Master
├── BGM (背景音乐)
│   ├── main_theme.ogg
│   ├── mystery_1.ogg
│   └── ending.ogg
│
├── SFX (音效)
│   ├── button_click.wav
│   ├── dialogue_type.wav
│   └── clue_collect.wav
│
└── Ambient (环境音)
    ├── rain.ogg
    ├── clock_ticking.ogg
    └── wind.ogg
```

### 10.2 音频管理器 API

```gdscript
class_name AudioManagerClass
extends Node

# BGM
func play_bgm(track_id: String, fade_in: float = 1.0) -> void
func stop_bgm(fade_out: float = 1.0) -> void
func pause_bgm() -> void
func resume_bgm() -> void

# 音效
func play_sfx(sfx_id: String, volume_db: float = 0.0) -> void
func play_sfx_pitch(sfx_id: String, pitch: float = 1.0) -> void

# 环境音
func play_ambient(ambient_id: String, loop: bool = true) -> void
func stop_ambient(ambient_id: String) -> void

# 音量控制
func set_bgm_volume(volume: float) -> void
func set_sfx_volume(volume: float) -> void
func set_ambient_volume(volume: float) -> void

# 特殊效果
func duck_bgm_for_dialogue() -> void
func restore_bgm_volume() -> void
```

### 10.3 音频淡入淡出

```gdscript
func fade_in_bgm(track_id: String, duration: float = 1.0) -> void:
    var tween = create_tween()
    audio_stream_player.volume_db = -80.0
    audio_stream_player.play()
    tween.tween_property(audio_stream_player, "volume_db", 0.0, duration)

func fade_out_bgm(duration: float = 1.0) -> void:
    var tween = create_tween()
    tween.tween_property(audio_stream_player, "volume_db", -80.0, duration)
    tween.tween_callback(audio_stream_player.stop)
```

---

## 11. 性能优化

### 11.1 渲染优化

| 优化项 | 方法 | 目标 |
|--------|------|------|
| **像素完美** | Pixel Perfect Camera | 无模糊 |
| **精灵批处理** | 合并静态精灵 | 减少 Draw Call |
| **图集打包** | TexturePacker | 减少纹理切换 |
| **视口裁剪** | 只渲染可见区域 | 减少 GPU 负载 |

### 11.2 内存优化

| 优化项 | 方法 |
|--------|------|
| **纹理压缩** | ETC2/ASTC 格式 |
| **音频压缩** | OGG Vorbis |
| **按需加载** | 场景/资源延迟加载 |
| **资源卸载** | 切换场景时清理 |

### 11.3 AI 推理优化

| 优化项 | 方法 |
|--------|------|
| **模型量化** | INT8 量化，减少 75% 内存 |
| **K V Cache** | 对话历史缓存 |
| **流式输出** | 边生成边显示 |

---

## 12. 安全考虑

### 12.1 数据安全

| 风险 | 缓解措施 |
|------|---------|
| **存档篡改** | 校验和验证 |
| **隐私泄露** | 本地处理语音数据 |
| **API 密钥泄露** | 配置文件不提交 Git |

### 12.2 网络安全

| 风险 | 缓解措施 |
|------|---------|
| **API 请求劫持** | HTTPS 加密传输 |
| **请求重放** | 时间戳验证 |
| **速率限制** | 客户端限流 |

### 12.3 .gitignore 配置

```gitignore
# 敏感配置
*.key
*.env
config/secrets.cfg

# 运行时文件
user://
saves/
logs/

# 构建产物
export/
builds/
```

---

## 附录 A: Godot 项目配置

```ini
; project.godot 片段

[application]
config/name="Mystery Files"
run/main_scene="res://scenes/ui/main_menu.tscn"
config/features=PackedStringArray("4.x", "Forward Plus")
config/icon="res://icon.svg"

[display]
window/size/viewport_width=1280
window/size/viewport_height=720
window/stretch/mode="viewport"
window/stretch/aspect="keep"

[rendering]
textures/canvas_textures/default_texture_filter=0  ; 关闭纹理过滤 (像素风)
```

---

## 附录 B: 自动加载配置

```ini
; project.godot 片段

[autoload]
EventBus="*res://scripts/autoload/event_bus.gd"
GameState="*res://scripts/autoload/game_state.gd"
StoryManager="*res://scripts/autoload/story_manager.gd"
NPCManager="*res://scripts/autoload/npc_manager.gd"
ClueManager="*res://scripts/autoload/clue_manager.gd"
AudioManager="*res://scripts/autoload/audio_manager.gd"
SaveManager="*res://scripts/autoload/save_manager.gd"
AIService="*res://scripts/autoload/ai_service.gd"
VoiceService="*res://scripts/autoload/voice_service.gd"
```

---

*文档版本：1.0.0*
*最后更新：2026-03-27*
*下次评审：待开发完成后*
