# Porcelain Theme — Feature Checklist

> Hackathon 提交材料：列出本主题的所有设计决策和功能亮点

---

## 🎯 核心设计原则

| 原则 | 实现 |
|------|------|
| **Soft monochrome on white** | 移除所有非必要装饰（暗角、纹理、渐变背景） |
| **数据优先** | 弱化 UI chrome，让表格、数字、文本成为视觉重心 |
| **纯白画布** | `background: #ffffff` — 最大化内容区域和对比度 |
| **灰阶系统** | 主色 `#374151` (gray-500) + 灰度层次，避免色彩分散注意力 |
| **适度圆角** | `radius: 12px` — 现代但不甜腻 |
| **药丸形导航** | `clip-path: polygon(...)` 实现两端半圆的 pill shape tabs |

---

## ✨ 功能特性（按官方 Theme 字段分类）

### 1. 调色板 (Palette)

| Token | 值 | 说明 |
|-------|-----|------|
| `palette.background` | `#ffffff` (alpha 1.0) | 纯白画布 |
| `palette.midground` | `#374151` (gray-500) | 主文字/图标/ accent |
| `palette.foreground` | `#000000` (alpha 0) | 顶高亮（隐藏） |
| `palette.warmGlow` | `rgba(0,0,0,0)` | 无暗角 |
| `palette.noiseOpacity` | `0` | 无颗粒纹理 |

**效果**：所有 shadcn token（card、popover、muted、border、primary、ring…）自动从这 3 层颜色 cascade 推导。

---

### 2. 色彩覆蓋 (Color Overrides)

为什么需要？虽然 palette cascade 能推导出全部 token，但为了保证 **灰阶一致性**，我们显式覆盖了以下 key：

| Override Key | 值 | 用途 |
|--------------|-----|------|
| `primary` | `#6b7280` (gray-500) | 按钮主色、active tab 背景 |
| `primaryForeground` | `#ffffff` | 主按钮文字 |
| `accent` | `#9ca3af` (gray-400) | hover/高亮背景 |
| `accentForeground` | `#ffffff` | accent 上的文字 |
| `ring` | `#d1d5db` (gray-300) | focus ring、边框高亮 |
| `border` | `#e5e7eb` (gray-200) | 默认边框 |
| `destructive` | `#ef4444` (red-500) | 错误/删除（保留红色用于警示） |
| `success` | `#22c55e` (green-500) | 成功状态（保留绿色） |

> **设计考量**：在纯白背景上，过深的主色会显得沉重；gray-500 在白色上对比度刚好（WCAG AA）。边框使用 gray-200，比传统浅灰更柔和。

---

### 3. 排版 (Typography)

| Property | 值 | 说明 |
|----------|-----|------|
| `fontSans` | `Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif` | 正文字体 |
| `fontMono` | `'JetBrains Mono', 'Fira Code', ui-monospace, monospace` | 代码字体 |
| `fontDisplay` | `Inter, sans-serif` | 标题字体（同 body） |
| `fontUrl` | Google Fonts (Inter + JetBrains Mono) | 按需加载 |
| `baseSize` | `15px` | 比默认 14px 稍大，提高长文可读性 |
| `lineHeight` | `1.6` | 宽松行高，配合大字号 |
| `letterSpacing` | `-0.003em` | 微调字间距（Inter 在 15px 时略微收缩更佳） |

---

### 4. 布局 (Layout)

| Property | 值 | 说明 |
|----------|-----|------|
| `layout.radius` | `12px` | 全局圆角 |
| `layout.density` | `comfortable` | 间距乘数 1.0 — 标准 |
| `layoutVariant` | `standard` | 单列 1600px 居中（可改为 `cockpit` 配合插件） |

**12px 圆角的视觉效果**：
- Card、Button、Input、Select、Modal、Badge、Progress 全部 inherits `--radius`
- 在 15px 字号 + comfortable spacing 下，12px 圆角 ≈ `0.8rem`，视觉重量适中

---

### 5. 组件样式覆蓋 (Component Styles)

只覆蓋必须的 bucket，其余由 palette cascade 自动處理：

```yaml
componentStyles:
  card:
    border: "1px solid var(--color-border)"
    boxShadow: "0 1px 2px 0 rgba(0, 0, 0, 0.05)"
  tab:
    clipPath: "polygon(12px 0, calc(100% - 12px) 0, 100% 50%, calc(100% - 12px) 100%, 12px 100%, 0 50%)"
    borderRadius: "9999px"   # fallback
  header:
    borderBottom: "1px solid var(--color-border)"
    background: "rgba(255, 255, 255, 0.8)"
    backdropFilter: "blur(8px)"
  progress:
    borderRadius: "9999px"
```

**设计细节**：
- `card` 增加 `0 1px 2px rgba(0,0,0,0.05)` 的超轻阴影，在白底上制造层次
- `header` 使用半透明白色 + `backdrop-filter: blur(8px)` 实现毛玻璃，滚动时内容模糊透视
- `tab` 的 `clip-path` 实现两端半圆的药丸形，比单纯 `border-radius` 更具设计感

---

### 6. 原始 CSS (customCSS)

`customCSS` 块注入 32 KB 以内的原始 CSS，用于组件样式无法表达的细节：

| 区块 | 特性 |
|------|------|
| **全局** | `body` 字体平滑、反锯齿 |
| **滚动条** | 细滚动条（8px宽）、hover 高亮 |
| **表格样式** | 统一边框、zebra striping（hover 高亮）、表头灰色背景 |
| **统计卡片柱状图** | `.stat-card-bar` 类，用 `linear-gradient` 模拟 bar chart |
| **Badge** | 强制 `border-radius: 9999px`（药丸形标签） |
| **Tabs** | 触发器设为药丸形，active 时填充 primary color |
| **Button** | 统一圆角 8px，primary 按钮使用 primary 色 |
| **Card 内部结构** | Header/Content/Footer 分别圆角处理 |
| **Input/Select/Textarea** | 统一边框、圆角、focus ring |
| **Code blocks** | 强制 JetBrains Mono，暗色背景 + 圆角 |
| **Progress** | 重写 webkit pseudo-elements 为药丸形 |
| **Tooltip** | 统一样式，避免默认浏览器差异 |
| **Dropdown/Menu** | 12px 圆角、阴影、hover 高亮 |
| **Modal/Dialog** | 16px 圆角、边框、深阴影 |
| **Skeleton 加载态** | 渐变 shimmer 动画，圆角 4px |

---

### 7. 可选插件的功能

本仓库的 `plugin/` 目录提供了一个 **Companion Plugin**，注入以下 UI 增强：

| Slot | 组件 | 描述 |
|------|------|------|
| `sidebar` | `SidebarHUD` | 实时显示 Agent 状态（会话数、版本、运行时间、当前模型），5s 轮询 |
| `header-left` | `HeaderCrest` | 读取主题 `assets.crest` 并在 header 左侧显示圆形 crest |
| `sessions:top` | `SessionsBanner` | 在 Sessions 页面顶部插入一条提示（例如：建议给 session 打标签） |

**插件技术细节**：
- **IIFE 模式** — 无需打包工具，单文件直接加载
- **React from SDK** — 不捆绑 React，使用 `window.__HERMES_PLUGIN_SDK__.React`
- **Hooks from SDK** — `useState` `useEffect` `useCallback` `useMemo` `useRef`
- **shadcn 组件** — 通过 `SDK.components` 获取（Card、Badge 等）
- **API 客户端** — `SDK.api.getStatus()` 调用 Hermes 内置 API
- **主题感知** — 使用 `getComputedStyle` 读取 CSS 变量（`--theme-asset-crest`）

---

## 📊 视觉规格速查

| 属性 | 值 | 备注 |
|------|-----|------|
| 背景色 | `#ffffff` | 纯白 |
| 主文字色 | `#374151` (gray-500) | 对比度 ~7.5:1，超 AA |
| 副文字色 | `#6b7280` (gray-500) | `--color-muted-foreground` |
| 边框色 | `#e5e7eb` (gray-200) | 轻量边框 |
| hover 背景 | `#f3f4f6` (gray-100) | `--color-accent` |
| 主按钮背景 | `#6b7280` | `--color-primary` |
| 主按钮文字 | `#ffffff` | `--color-primary-foreground` |
| 圆角（全局） | `12px` | `--radius` |
| 圆角（小控件） | `8px` | Input、Select、Button |
| 圆角（ pills） | `9999px` | Badge、Tab trigger、Progress |
| 字体（正文） | Inter 15px / 1.6 | `font-sans` |
| 字体（代码） | JetBrains Mono 13px | `font-mono` |
| 间距密度 | comfortable (1.0×) | `--spacing-mul` |

---

## 🎬 安装与测试（开发流程）

```bash
# 1. 复制主题到 Hermes 目录
cp theme/porcelain.yaml ~/.hermes/dashboard-themes/

# 2. 可选：安装 companion plugin
mkdir -p ~/.hermes/plugins/porcelain-theme/dashboard
cp -r plugin/* ~/.hermes/plugins/porcelain-theme/dashboard/

# 3. 强制重扫插件（如果 dashboard 已运行）
curl http://127.0.0.1:9119/api/dashboard/plugins/rescan

# 4. 刷新浏览器 (Cmd+Shift+R)，切换主题到 Porcelain
# 5. 截图，提交！
```

---

## 📸 截图位置

请将以下截图保存到 `docs/screenshots/`：

1. `dashboard-home.png` — 首页概览（显示白底、卡片、表格）
2. `sessions-page.png` — Sessions 页面（突出表格样式、hover、sidebar HUD）
3. `tabs-pill-shape.png` — Tabs 导航（药丸形选中/未选中）
4. `stats-card-bars.png` — 统计卡片的渐变 bar（如有）
5. `modal-select.png` — Modal、Select dropdown 统一样式
6. `dark-mode-check.png` — 可选：验证在官方 dark 主题下 fallback 正常

建议使用 **2560×1440** 或 **1920×1080** 分辨率截图，保持截图区域宽屏。

---

## 🏆 Hackathon 提交链接

```
GitHub: https://github.com/thedavidweng/hermes-dashboard-theme-porcelain
Discord: (待填 - 发布到 Hermes Discord #dashboard-theming 频道)
```

**提交流程**：
1. Push 到 GitHub（public repo）
2. 运行 `git status` 确认所有文件已提交
3. 在 Discord 发布：
   - 主题名称 + 一句话介绍
   - GitHub repo 链接
   - 1–3 张截图或短视频（GIF ≤ 10 MB）
4. 等待 Teknium 在 24 小时内评选

---

## 🙏 致谢

- **Hermes Agent Team** — 出色的可扩展架构
- **Teknium / Nous Research** — 举办黑客松，激励社区创作
- **Swiss Design** — Soft monochrome on white美学的灵感来源
- **shadcn/ui** — 设计系统的基石

---

*最后更新：2026-04-25*  
*版本：1.0.0-hackathon-entry*
