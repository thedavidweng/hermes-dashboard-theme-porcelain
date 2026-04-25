/**
 * Porcelain Theme Companion Plugin
 *
 * 本插件为 Porcelain 主题提供增强 UI 组件：
 * - sidebar slot: 实时 agent 状态面板（会话数、模型、运行时间）
 * - header-left slot: 主题 crest (读取主题 assets 中的 crest 图片)
 * - sessions:top slot: 可选 — 在 Sessions 页面顶部插入提示卡片
 *
 * 架构说明：
 * - IIFE 模式，无需打包（React 从 SDK 获取）
 * - 使用 window.__HERMES_PLUGIN_SDK__ 访问 React、hooks、组件库、API 客户端
 * - 通过 window.__HERMES_PLUGINS__.register() 注册主组件
 * - 通过 window.__HERMES_PLUGINS__.registerSlot() 注入 shell slots
 *
 * 参考：官方文档 → Plugins → The Plugin SDK
 */

(function () {
  "use strict";

  const SDK = window.__HERMES_PLUGIN_SDK__;
  if (!SDK) {
    console.error("[porcelain-theme] SDK not found — dashboard may be outdated");
    return;
  }

  const { React } = SDK;
  const { useState, useEffect, useCallback } = SDK.hooks;

  // ═══════════════════════════════════════════════════════════════
  // 组件 1: Sidebar HUD — 显示 Agent 实时状态
  // ═══════════════════════════════════════════════════════════════
  function SidebarHUD() {
    const [status, setStatus] = useState({});
    const [error, setError] = useState(null);

    useEffect(() => {
      let mounted = true;
      const fetch = async () => {
        try {
          const data = await SDK.api.getStatus();
          if (mounted) setStatus(data);
        } catch (e) {
          if (mounted) setError(e);
        }
      };
      fetch();
      const timer = setInterval(fetch, 5000); // 5s 轮询
      return () => {
        mounted = false;
        clearInterval(timer);
      };
    }, []);

    if (error) {
      return React.createElement("div", { className: "p-4 text-xs text-muted-foreground" },
        "Failed to load agent status"
      );
    }

    const sessions = status.sessionCount || 0;
    const version = status.version || "—";
    const uptime = status.uptime ? `${Math.floor(status.uptime / 60)}m` : "—";

    return React.createElement("div", { className: "p-4 space-y-4" },
      // Header
      React.createElement("div", { className: "flex items-center gap-2 mb-2" },
        React.createElement("span", { className: "text-sm font-semibold" }, "Agent Status"),
        React.createElement("span", { className: "text-xs text-muted-foreground" }, `v${version}`)
      ),

      // Sessions 统计 + 迷你柱状图
      React.createElement("div", { className: "space-y-1" },
        React.createElement("div", { className: "flex justify-between text-xs" },
          React.createElement("span", null, "Sessions"),
          React.createElement("span", { className: "font-mono" }, sessions.toString())
        ),
        React.createElement("div", { className: "h-1.5 w-full bg-muted rounded-full overflow-hidden" },
          React.createElement("div", {
            className: "h-full bg-primary transition-all duration-500",
            style: { width: `${Math.min((sessions % 100), 100)}%` }
          })
        )
      ),

      // Uptime
      React.createElement("div", { className: "flex justify-between text-xs" },
        React.createElement("span", null, "Uptime"),
        React.createElement("span", { className: "font-mono" }, uptime)
      ),

      // Model (if available)
      status.model && React.createElement("div", { className: "flex justify-between text-xs" },
        React.createElement("span", null, "Model"),
        React.createElement("span", { className: "font-mono truncate max-w-[120px]" }, status.model)
      )
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 组件 2: Header Crest — 从主题 assets 读取 crest 图片
  // ═══════════════════════════════════════════════════════════════
  function HeaderCrest() {
    const [src, setSrc] = useState(null);

    useEffect(() => {
      // 读取 CSS 变量 --theme-asset-crest（如果主题定义了）
      const crest = getComputedStyle(document.documentElement)
        .getPropertyValue("--theme-asset-crest-raw")   // 使用 raw 版本，避免 url(...) 包裹
        .trim()
        .replace(/^url\(["']?/, "")
        .replace(/["']?\)$/, "");

      if (crest) {
        setSrc(crest);
      } else {
        // 回退：尝试读取 --theme-asset-crest（可能已经是 url(...)）
        const raw = getComputedStyle(document.documentElement)
          .getPropertyValue("--theme-asset-crest")
          .trim();
        if (raw) {
          setSrc(raw.replace(/^url\(["']?|["']?\)$/g, ""));
        }
      }
    }, []);

    if (!src) return null;

    return React.createElement("img", {
      src: src,
      alt: "Theme Crest",
      width: 24,
      height: 24,
      className: "rounded-full object-cover border border-border"
    });
  }

  // ═══════════════════════════════════════════════════════════════
  // 组件 3: Sessions Banner — 可选，在 Sessions 页面顶部显示提示
  // ═══════════════════════════════════════════════════════════════
  function SessionsBanner() {
    return React.createElement("div", { className: "mb-4" },
      React.createElement("div", {
        className: "rounded-lg bg-muted/50 border border-border px-4 py-3 text-sm",
        style: { borderRadius: "12px" }
      },
        "💡 Tip: Use tags and labels to organize your sessions. Filter by tag in the sidebar."
      )
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 注册主组件（占位，供 direct URL /porcelain 访问）
  // ═══════════════════════════════════════════════════════════════
  window.__HERMES_PLUGINS__.register("porcelain-theme", function HomePage() {
    return React.createElement("div", { className: "p-8 space-y-6" },
      React.createElement("div", null,
        React.createElement("h1", { className: "text-2xl font-bold mb-2" }, "Porcelain Theme Companion"),
        React.createElement("p", { className: "text-muted-foreground" },
          "This plugin provides UI enhancements for the Porcelain theme. " +
          "It is designed to run silently in the background via slots."
        )
      ),
      React.createElement("div", { className: "grid grid-cols-1 md:grid-cols-2 gap-4" },
        React.createElement("div", { className: "rounded-lg border border-border p-4", style: { borderRadius: "12px" } },
          React.createElement("h3", { className: "font-semibold mb-2" }, "Active Slots"),
          React.createElement("ul", { className: "text-sm space-y-1 text-muted-foreground" },
            React.createElement("li", null, "• sidebar — Agent status HUD"),
            React.createElement("li", null, "• header-left — Theme crest"),
            React.createElement("li", null, "• sessions:top — Banner (currently registered)")
          )
        )
      )
    );
  });

  // ═══════════════════════════════════════════════════════════════
  // 注册到 Shell Slots
  // ═══════════════════════════════════════════════════════════════
  window.__HERMES_PLUGINS__.registerSlot("porcelain-theme", "sidebar", SidebarHUD);
  window.__HERMES_PLUGINS__.registerSlot("porcelain-theme", "header-left", HeaderCrest);
  window.__HERMES_PLUGINS__.registerSlot("porcelain-theme", "sessions:top", SessionsBanner);

  console.log("[porcelain-theme] plugin loaded — slots registered");
})();
