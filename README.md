# Mystery Files

> 一款 iOS 悬疑叙事游戏 - 通过语音交互与 NPC 对话，体验随机生成的悬疑故事

---

## 🚀 快速开始

### 项目位置

Godot 项目位于 `mystery-files/` 目录：

```bash
cd mystery-files
# 在 Godot Editor 中打开 project.godot
```

### 文档

| 文档 | 路径 |
|------|------|
| 项目索引 | [mystery-files/PROJECT_INDEX.md](mystery-files/PROJECT_INDEX.md) |
| UI/UX 需求 | [docs/requirements/Game_UI_UX_Requirements.md](docs/requirements/Game_UI_UX_Requirements.md) |
| 技术架构 | [docs/technical/Game_Technical_Architecture.md](docs/technical/Game_Technical_Architecture.md) |
| 实施计划 | [docs/plans/mystery-game-implementation.md](docs/plans/mystery-game-implementation.md) |

---

## 🎮 游戏特色

- **16-bit 像素风格** - 复古像素艺术视觉
- **语音交互** - 按住说话与 NPC 对话
- **AI 故事生成** - 云端 LLM 生成高质量悬疑剧情
- **多结局设计** - 根据玩家表现触发不同结局

---

## 🛠️ 技术栈

| 项目 | 技术 |
|------|------|
| 游戏引擎 | Godot 4.x |
| 编程语言 | GDScript |
| 语音识别 | iOS Speech Framework (本地) |
| AI 故事 | 云端 LLM + 本地小模型 |
| 数据存储 | ConfigFile + JSON |

---

## 📁 项目结构

```
mystery-files/
├── README.md                        # 项目说明
├── CLAUDE.md                        # 技能包配置
├── docs/                            # 文档目录
│   ├── README.md                    # 文档索引
│   ├── requirements/                # 需求文档
│   ├── technical/                   # 技术文档
│   ├── plans/                       # 实施计划
│   └── reference/                   # 参考文档
├── .agent/skills/                   # 技能包
├── scenes/                          # Godot 场景
├── scripts/                         # Godot 脚本
├── resources/                       # 资源文件
└── project.godot                    # Godot 项目配置
```

---

## 📋 开发状态

| 阶段 | 状态 |
|------|------|
| 需求分析 | ✅ 完成 |
| 技术架构 | ✅ 完成 |
| 实施计划 | ✅ 完成 |
| 项目开发 | ⬜ 进行中 |

---

## 🚀 快速开始

1. 阅读 [UI/UX 需求文档](docs/requirements/Game_UI_UX_Requirements.md) 了解游戏设计
2. 阅读 [技术架构文档](docs/technical/Game_Technical_Architecture.md) 了解技术选型
3. 阅读 [开发实施计划](docs/plans/mystery-game-implementation.md) 开始开发

---

*最后更新：2026-03-27*
