# Hermes Dashboard Theme: Porcelain

> 极简主义 · 灰阶柱状图 · 12px 圆角卡片 · 药丸形导航标签 · 纯白画布  
> 为 [Hermes Dashboard Theme Hackathon](https://x.com/Teknium/status/2047941621358928157) 开发

## 🎨 设计理念

Porcelain 主题拥抱「少即是多」的设计哲学：

- **纯白画布** (`background: #ffffff`) — 最大化内容呼吸空间，让信息成为主角
- **灰階色板** — 使用 `#374151` (gray-500) 作为主文字/ accent 颜色，通过灰度层次替代色彩
- **12px 圆角卡片** — 适度圆角带来现代感，保持视觉上的柔和但不松懈
- **药丸形导航标签** — 两端半圆的 pill shape 让导航按钮更友好、点击区域更大
- **弱化装饰** — 关闭暗角 (`warmGlow: rgba(0,0,0,0)`) 和纹理 (`noiseOpacity: 0`)，不干扰数据呈现

这种设计特别适合：
- 长时间监控数据仪表板
- 需要高对比度、低视觉疲劳的场景
- 喜欢 Swiss Design / 国际主义风格的用户

---

## 📁 项目结构

```
hermes-dashboard-theme-porcelain/
├── theme/
│   └── porcelain.yaml          # 主主题文件（单文件即可生效）
├── plugin/
│   ├── manifest.json            # 可选的配套插件（增强功能）
│   └── dist/
│       ├── index.js             # 插件 JS bundle
│       └── style.css            # 插件专属 CSS（如需要）
├── docs/
│   ├── screenshots/             # 主题截图
│   └── FEATURES.md              # 功能清单（供评审）
├── assets/
│   └── crest.svg                # 主题资源（可选）
├── README.md                    # 本文件
├── LICENSE                      # MIT License
└── .gitignore
```

---

## 🚀 快速开始

### 1. 安装主题

```bash
# 复制主题文件到 hermes 配置目录
cp theme/porcelain.yaml ~/.hermes/dashboard-themes/

# 如果目录不存在，先创建
mkdir -p ~/.hermes/dashboard-themes
```

### 2. 启动 / 重启 Dashboard

```bash
# 启动 dashboard（如果还未运行）
hermes dashboard

# 或者重启已运行的实例
# 在 dashboard 页面按Cmd+Shift+R 强制刷新，或者重启进程
```

### 3. 切换主题

1. 打开浏览器访问 `http://127.0.0.1:9119`
2. 点击右上角的 **调色板图标**（Palette Switcher）
3. 选择 **"Porcelain"** 主题
4. 页面即刻重绘

主题选择会持久化保存到 `~/.hermes/config.yaml` 的 `dashboard.theme` 字段。

---

## 📖 官方文档解读：主题系统三阶层

Hermes Dashboard 的扩展系统有三层，**主题（Theme）是第一层也是最简单的一层**：

### Layer 1 – Themes（主题层）
- **文件位置**：`~/.hermes/dashboard-themes/*.yaml`
- **生效方式**：Drop-in 即可，无需构建 (`no npm run build`)
- **核心配置**：
  - `palette` — 三層顏色（background/midground/foreground）+ 暗角 + 紋理
  - `typography` — 字體棧、Base size、line-height、letter-spacing
  - `layout` — 圓角半徑 (`radius`)、密度 (`density`)
- **可選擴展**：
  - `colorOverrides` — 覆蓋特定 shadcn token（如 Primary、Accent）
  - `componentStyles` — 直接覆寫組件bucket的 CSS 變數
  - `customCSS` — 直接注入原始 CSS（選擇器級別的定制）
  - `assets` — 提供圖片 URL 給 plugin 使用
  - `layoutVariant` — 切換整體佈局（standard / cockpit / tiled）

### Layer 2 – UI Plugins（UI 插件層）
- **文件位置**：`~/.hermes/plugins/<name>/dashboard/`
- **組成**：`manifest.json` + `dist/index.js` (+ `dist/style.css`)
- **能力**：
  - 註冊新頁籤 (`tab.path`)
  - 覆蓋內建頁面 (`tab.override`)
  - 注入 Shell slots (sidebar, header-left, footer, 等)
  - 頁面級增強 (`page-scoped slots: sessions:top/`, `config:bottom/`, …)
- **SDK**：通过 `window.__HERMES_PLUGIN_SDK__` 获得 React、hooks、组件库、API 客户端

### Layer 3 – Backend Plugins（後端插件層）
- **文件位置**：`~/.hermes/plugins/<name>/dashboard/plugin_api.py`
- **框架**：FastAPI `APIRouter`
- **掛載路徑**：`/api/plugins/<name>/…`
- **權限**：運行在同一個進程，可直接 `import hermes_state` 等內module

---

## 🛠️ 你可以用这个主题做什么？

### ✅ 独立使用（仅 YAML 文件）
- **整站换色**：修改 `palette` 中的三个颜色，整个 UI 自动 cascade
- **字体替换**：通过 `fontUrl` 加载 Google Fonts / Bunny Fonts / 自托管字体
- **圆角微调**：`radius: "0"` 到 `"1rem"`，所有卡片/按钮/输入框同步更新
- **密度切换**：`density: compact` 适合数据密集型，`spacious` 适合阅读密集型
- **布局变体**：`layoutVariant: cockpit` 启用左侧侧边栏（需配合插件注入内容）

### ✅ 通过 `componentStyles` 定制组件外观（无需 CSS 选择器）
```yaml
componentStyles:
  card:
    border: "1px solid var(--color-border)"
    boxShadow: "inset 0 0 0 1px rgba(0,0,0,0.08)"
  tab:
    clipPath: "polygon(12px 0, calc(100% - 12px) 0, 100% 50%, calc(100% - 12px) 100%, 12px 100%, 0 50%)"
```
支持 buckets: `card` `header` `footer` `sidebar` `tab` `progress` `badge` `backdrop` `page`

### ✅ 通过 `colorOverrides` 覆盖特定 token（保留 palette cascade 的优点是自动适配明暗）
```yaml
colorOverrides:
  primary: "#6b7280"       # 强制主色为灰
  accent: "#9ca3af"        # 强制强调色为浅灰
  ring: "#d1d5db"         # focus ring 颜色
```

### ✅ 通过 `customCSS` 注入全局样式（选择器级别控制）
```yaml
customCSS: |
  /* 滚动条美化 */
  ::-webkit-scrollbar-thumb { background: var(--color-border); }
  
  /* 表格 zebra striping */
  table tr:nth-child(even) td { background: var(--color-muted); }
  
  /* 自定义动画 */
  @keyframes fade-in { from { opacity: 0; } to { opacity: 1; } }
```
⚠️ 上限 32 KiB。超过请移步 plugin 的 `.css` 文件（无上限）。

### ✅ 使用 `assets` 提供主题专属图片
```yaml
assets:
  crest: "/assets/crest.svg"           # → --theme-asset-crest
  bg: "/assets/gradient-bg.jpg"        # → --theme-asset-bg（自动连到 <Backdrop />）
```
Plugin 可以通过 JS 读取：
```js
const crest = getComputedStyle(document.documentElement)
  .getPropertyValue("--theme-asset-crest").trim();
```

---

## 📋 完整主题 YAML 字段参考

| 字段 | 类型 | 必需 | 说明 |
|------|------|------|------|
| `name` | string | ❌ | 内部标识符（默认从文件名推导） |
| `label` | string | ❌ | UI 显示的用户友好名称 |
| `description` | string | ❌ | 工具提示/下拉列表中的描述 |
| `palette` | object | ❌ | 三層顏色 + `warmGlow` + `noiseOpacity` |
| `typography` | object | ❌ | `fontSans` `fontMono` `fontDisplay` `fontUrl` `baseSize` `lineHeight` `letterSpacing` |
| `layout` | object | ❌ | `radius` `density` |
| `layoutVariant` | `standard` \|\| `cockpit` \|\| `tiled` | ❌ | 整体布局模式 |
| `assets` | object | ❌ | 图片资源映射 |
| `componentStyles` | object | ❌ | 组件 bucket 的 CSS 变量覆盖 |
| `colorOverrides` | object | ❌ | 直接覆盖 shadcn token |
| `customCSS` | string (block) | ❌ | 原始 CSS 代码块 |

**Key Points**:
- 所有字段都 **可选** — 缺少的键回退到默认主题（Hermes Teal）
- 因此一个主题可以只有 **一个颜色** 就生效（如官方 Neon 示例）
- 文件放在 `~/.hermes/dashboard-themes/`，YAML 格式，扩展名 `.yaml` 或 `.yml`
- 更改后刷新dashboard即可生效，无需重启

---

## 🔧 可选：配套插件（增强主题）

如果你想要：
- 一个 **cockpit 侧边栏** 显示监控数据
- 在 **header-left** 显示自定义 crest/logo
- 在 **sessions 页面顶部** 插入提示卡片
- 自定义 **Backend API 路由** 供前端调用

…那么可以写一个插件。本仓库已包含基础脚手架：

### 插件目录
```
plugin/
├── manifest.json     # 插件清单（必需）
└── dist/
    ├── index.js      # JS bundle（IIFE，无需打包）
    └── style.css     # 可选：自定义 CSS（无 32KB 限制）
```

### 快速启用插件

1. 确保目录结构正确：
```bash
cp -r plugin ~/.hermes/plugins/porcelain-theme/dashboard/
```

   **注意**：插件必须位于 `~/.hermes/plugins/<name>/dashboard/`（多一层 `dashboard/` 子目录）

2. 通知 dashboard 重扫插件：
```bash
curl http://127.0.0.1:9119/api/dashboard/plugins/rescan
# 或直接重启 hermes dashboard
```

3. 如果 `manifest.json` 有 `tab.hidden: true`，插件不会出现在侧边栏；如果上报了 `slots`，组件会注入到对应位置。

### 示例：注入侧边栏 + header crest

修改 `plugin/dist/index.js`：

```javascript
(function () {
  "use strict";

  const SDK = window.__HERMES_PLUGIN_SDK__;
  const { React } = SDK;

  // 侧边栏 HUD — 显示当前 agent 状态
  function SidebarHUD() {
    const [status, setStatus] = React.useState({});
    
    React.useEffect(() => {
      SDK.api.getStatus().then(setStatus);
      const timer = setInterval(() => SDK.api.getStatus().then(setStatus), 5000);
      return () => clearInterval(timer);
    }, []);

    return React.createElement("div", { className: "p-4 space-y-4" },
      React.createElement("h3", { className: "font-semibold text-sm" }, "Agent Status"),
      React.createElement("div", null,
        React.createElement("div", { className: "flex justify-between text-xs" },
          React.createElement("span", null, "Sessions"),
          React.createElement("span", null, status.sessionCount || "—")
        ),
        React.createElement("div", { className: "h-1 w-full bg-muted rounded-full mt-1" },
          React.createElement("div", {
            className: "h-full bg-primary rounded-full",
            style: { width: `${(status.sessionCount || 0) % 100}%` }
          })
        )
      )
    );
  }

  // Header crest — 读取主题提供的 crest 图片
  function HeaderCrest() {
    const crest = getComputedStyle(document.documentElement)
      .getPropertyValue("--theme-asset-crest").trim();
    return crest
      ? React.createElement("img", { src: crest, alt: "Crest", width: 24, height: 24, className: "rounded-full" })
      : null;
  }

  // 注册主组件（即使 tab.hidden: true，也要占位以便 direct URL 访问）
  window.__HERMES_PLUGINS__.register("porcelain-theme", function () {
    return React.createElement("div", null, "Porcelain theme companion plugin");
  });

  // 注册到 shell slots
  window.__HERMES_PLUGINS__.registerSlot("porcelain-theme", "sidebar", SidebarHUD);
  window.__HERMES_PLUGINS__.registerSlot("porcelain-theme", "header-left", HeaderCrest);
})();
```

对应的 `plugin/manifest.json`：
```json
{
  "name": "porcelain-theme",
  "label": "Porcelain Theme Companion",
  "description": "Companion UI elements for the Porcelain theme",
  "icon": "Sparkles",
  "version": "1.0.0",
  "tab": {
    "path": "/porcelain",
    "position": "end",
    "hidden": true               // 不显示侧边栏 tab（只通过 slots 增强）
  },
  "slots": ["sidebar", "header-left"],
  "entry": "dist/index.js"
}
```

---

## 📸 截图与演示

请在 `docs/screenshots/` 目录下放置主题截图，建议包含：

1. **Dashboard 首页** — 展示白底灰字、排版、12px圆角卡片
2. **Sessions 页面** — 表格样式、hover 效果、滚动条美化
3. **Tabs 导航** — 药丸形 tab 的选中/未选中状态
4. **Stats 卡片** — 带有渐变 bar 的统计卡片（通过 `.stat-card-bar` 实现）
5. **Modal/Select/Dropdown** — 表单控件样式

---

## 🏆 Hackathon 提交清单

根据 [Teknium 的公告](https://x.com/Teknium/status/2047941621358928157)，参赛要求：

- [ ] **GitHub 仓库公开** — 已初始化（本仓库）
- [ ] **README 完整** — 包含设计理念、安装指南、特性列表
- [ ] **主题文件 `porcelain.yaml`** — 已完成，位于 `theme/`
- [ ] **截图或视频** — 添加到 `docs/screenshots/` 并嵌入 README
- [ ] **可选：插件** — 如有增强功能，请提交 `plugin/` 目录
- [ ] **开源许可证** — 建议 MIT License（已预留 `LICENSE` 文件）
- [ ] **Discord 提交** — 在截止时间前将 GitHub 链接和截图发布到 Hermes Discord

**Judgement Criteria** (Teknium 原话):
> which I think is most awesome and useful

重点评审维度：
1. **Awesome** — 设计美学是否独特、印象深刻
2. **Useful** — 是否提升日常使用体验（易读性、信息密度、视觉疲劳）

**我的一点解读**：
- Porcelain 走的是 **数据优先** 路线 — 减少视觉噪音，让数据更突出
- 药丸形 tab + 12px 圆角在现在主流圆角 4–8px 的 Dashboard 中偏大，有辨识度
- 纯白画布在大多数 Dashboard（深色默认）中会形成强烈对比
- 灰阶配色 + 柱状图暗示，适合做成 **Analytics 导向** 的主题

---

## 🐛 调试与故障排除

### 主题没出现在切换器中？
```bash
# 检查文件位置
ls ~/.hermes/dashboard-themes/

# 通过 API 确认 dashboard 能读到
curl http://127.0.0.1:9119/api/dashboard/themes | jq
```
- 确保文件扩展名为 `.yaml` 或 `.yml`
- 检查 YAML 语法（缩进、冒号后空格）
- 查看日志：`tail -f ~/.hermes/logs/errors.log`

### 某些样式不生效？
- `componentStyles` 只影响指定 bucket — 如果你改了 `card` 但想改 `CardHeader`，那是 `card` bucket 内的子组件，已经包含
- `customCSS` 的优先级可能不够？尝试加 `!important`（适度使用）
- 有些组件使用内联样式（style={{…}}），需要用 `colorOverrides` 或 theme vars 才能覆盖

### 自定义 CSS 超过 32 KiB？
- 拆分到 plugin 的 `style.css`（无大小限制）
- 或优化：提取公共部分到 `:root` 变量

### 想要动态效果（如 hover 动画）？
- 放在 `customCSS` 中，使用 `transition` 属性
- 或写一个 plugin，用 React `useState` + `setInterval` 做实时数据驱动的样式变化

---

## 📚 延伸阅读

- **官方指南**：https://hermes-agent.nousresearch.com/docs/user-guide/features/extending-the-dashboard
- **Full Theme YAML Reference** — 所有字段的详细说明（见上方表格）
- **Plugin 开发** — 如需更复杂交互，可阅读本仓库 `plugin/` 目录的注释
- **Strike Freedom Cockpit Demo** — `hermes-agent` repo 自带的完整示例：`plugins/strike-freedom-cockpit/`

---

## 📄 许可证

MIT License — 你可以自由使用、修改、分发。

---

## 🙋 支持

- Hermes Discord：`#dashboard-theming` 频道
- GitHub Issues：提交 bug 或 feature 请求
- 官方文档：Web Dashboard → Extending the Dashboard

---

**Happy theming!**  
愿你的 Porcelain 主题在黑客松中脱颖而出 🚀
