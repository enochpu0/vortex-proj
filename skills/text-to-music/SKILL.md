---
name: text-to-music
description: "使用 MiniMax API 生成歌词和音乐，支持文生歌词、文生音乐功能"
risk: medium
---

# Text to Music

## Overview

调用 MiniMax API 完成歌词生成和音乐生成两个功能。

## When to Use

- 需要为游戏生成背景音乐时
- 需要为游戏场景创作定制歌词时
- 需要快速生成概念音乐用于设计讨论时

## 文件说明

| 文件 | 功能 | API 端点 |
|------|------|----------|
| `lyric-generate.py` | 根据给定歌词生成音乐 | `/v1/music_generation` |
| `write-music.py` | 根据描述生成歌词 | `/v1/lyrics_generation` |

## Instructions

### 环境要求

- Python 3.x
- `requests` 库：`pip install requests`
- `MINIMAX_API_KEY` 环境变量（必须）

### 获取 API Key

1. 注册 MiniMax 账号：https://www.minimax.io/
2. 在开发者平台获取 API Key
3. 设置环境变量：
   ```bash
   export MINIMAX_API_KEY="your_api_key_here"
   ```

### 使用方法

#### 方式一：生成歌词

修改 `write-music.py` 中的 `prompt` 为歌曲描述，运行即可：

```bash
python3 skills/text-to-music/write-music.py
```

输出为 JSON 格式的歌词文本。

#### 方式二：根据歌词生成音乐

1. 修改 `lyric-generate.py` 中的 `lyrics` 为你的歌词
2. 修改 `prompt` 为音乐风格描述（如 "Mandopop, Festive, Upbeat"）
3. 运行脚本：
   ```bash
   python3 skills/text-to-music/lyric-generate.py
   ```
4. 音乐文件 URL 会输出到控制台

### 参数说明

#### write-music.py

| 参数 | 类型 | 说明 |
|------|------|------|
| mode | string | 模式，"write_full_song" 生成完整歌曲 |
| prompt | string | 歌曲描述文本 |

#### lyric-generate.py

| 参数 | 类型 | 说明 |
|------|------|------|
| model | string | 模型名称，"music-2.5+" |
| prompt | string | 音乐风格描述 |
| lyrics | string | 歌词文本 |
| audio_setting.sample_rate | int | 采样率，默认 44100 |
| audio_setting.bitrate | int | 比特率，默认 256000 |
| audio_setting.format | string | 音频格式，默认 "mp3" |
| output_format | string | 输出格式，"url" 或 "base64" |

### 输出文件存放

**临时文件必须存放在 `build/` 目录下**，禁止污染源代码目录。

生成的音频文件如需保存，请手动下载到 `build/` 目录。

## Examples

### 歌词生成示例

```python
payload = {
    "mode": "write_full_song",
    "prompt": "一首神秘的悬疑风格歌曲，节奏缓慢，充满悬念"
}
```

### 音乐生成示例

```python
payload = {
    "model": "music-2.5+",
    "prompt": "Mysterious, Suspense, Slow tempo, Cinematic",
    "lyrics": "[Verse]\n迷雾笼罩着古老的城堡\n月光下隐藏着秘密\n...",
    "audio_setting": {
        "sample_rate": 44100,
        "bitrate": 256000,
        "format": "mp3"
    },
    "output_format": "url"
}
```

### 游戏场景音乐描述示例

```
"Dark ambient, horror, tension building, low drone, distant whispers"
```

```
"Happy upbeat chiptune, 8-bit, video game menu music"
```

```
"Epic orchestral, dramatic climax, boss battle music"
```
