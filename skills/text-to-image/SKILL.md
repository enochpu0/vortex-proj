---
name: text-to-image
description: "使用 MiniMax API 生成图片，支持文生图功能"
risk: medium
---

# Text to Image

## Overview

调用 MiniMax Image Generation API 将文字描述转换为图片。

## When to Use

- 需要根据场景描述生成游戏素材图片时
- 需要快速生成概念图用于设计讨论时
- 生成 UI 背景图、场景氛围图等游戏资源时

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

1. 修改 `text-to-image.py` 中的 `prompt` 为你的描述
2. 可选：修改 `aspect_ratio`（支持 "1:1", "16:9", "9:16", "3:2", "2:3"）
3. 运行脚本：
   ```bash
   python text-to-image.py
   ```
4. 图片会保存到 `build/output-0.jpeg`, `build/output-1.jpeg` 等文件（临时文件必须存放在 `build/` 目录）

### 参数说明

| 参数 | 类型 | 说明 |
|------|------|------|
| prompt | string | 图片描述文本 |
| model | string | 模型名称，固定为 "image-01" |
| aspect_ratio | string | 图片比例 |
| response_format | string | 返回格式，固定为 "base64" |

## Examples

### 基本用法

```python
payload = {
    "model": "image-01",
    "prompt": "a mysterious abandoned house at night, foggy atmosphere, cinematic lighting",
    "aspect_ratio": "16:9",
    "response_format": "base64",
}
```

### 游戏场景描述示例

```
"ancient chinese temple interior, dimly lit by torchlight, dust particles in the air, mysterious atmosphere, photorealistic"
```

```
"modern office room at midnight, blue moonlight through window, single desk lamp on, noir detective vibe"
```
