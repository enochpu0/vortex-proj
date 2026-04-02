# 项目配置与技能包

## 项目信息

**项目名称**: Mystery Files - 悬疑叙事游戏
**游戏引擎**: Godot 4.x
**目标平台**: iOS
**引擎目录**: `godot-engine/` - 此目录包含 Godot 引擎的所有文件，应用工程代码位于此目录下

## 项目文档

所有项目文档位于 `docs/` 目录：

| 文档 | 路径 |
|------|------|
| 文档索引 | `docs/README.md` |
| UI/UX 需求文档 | `docs/requirements/Game_UI_UX_Requirements.md` |
| 技术架构文档 | `docs/technical/Game_Technical_Architecture.md` |
| 开发实施计划 | `docs/plans/mystery-game-implementation.md` |

---

## 技能包配置

本项目技能包位于：

```
.agent/skills/
```

该技能包包含 **1,328+ 技能**，适用于 Claude Code、Cursor、Gemini CLI 等 AI 编程助手。

### 技能包结构

```
.agent/skills/
└── skills/
    ├── skill-name/
    │   ├── SKILL.md              # 技能定义文件
    │   ├── examples/             # 示例代码
    │   ├── scripts/              # 辅助脚本
    │   └── resources/            # 参考资料
```

### 如何使用技能

在对话中使用 `@技能名` 来调用技能：

```
@brainstorming 帮我设计一个待办应用
@test-driven-development 为这个函数编写测试
@systematic-debugging 帮我调试这个问题
```

### 常用技能推荐

| 场景 | 推荐技能 |
|------|----------|
| 新功能设计 | `@brainstorming` |
| 编写代码 | `@test-driven-development` |
| 修复 Bug | `@systematic-debugging` |
| 代码审查 | `@receiving-code-review` |
| Git 操作 | `@git-pushing` |
| 前端开发 | `@frontend-design` |
| 编写计划 | `@writing-plans` |
| 编写文档 | `@doc-coauthoring` |

### 技能文件格式

```markdown
---
name: skill-name
description: "技能描述"
risk: safe
source: community
---

# 技能标题

## Overview
## When to Use
## Instructions
## Examples
```

### 相关文档

- [技能目录](.agent/skills/skills/README.md) - 浏览所有技能
- [技能解剖](.agent/skills/docs/contributors/skill-anatomy.md) - 技能结构详解
- [贡献指南](.agent/skills/CONTRIBUTING.md) - 创建新技能指南

---

*最后更新：2026-03-27*
