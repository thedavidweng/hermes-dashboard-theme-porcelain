/**
 * Porcelain Theme Companion Plugin
 *
 * This plugin keeps Porcelain distributable without patching Hermes itself.
 * Hermes currently renders placeholder swatches for user YAML themes while
 * another theme is active, so the theme CSS cannot affect that state. The
 * plugin adds the Porcelain swatch in the existing theme picker DOM.
 */

(function () {
  "use strict";

  const SDK = window.__HERMES_PLUGIN_SDK__;
  if (!SDK) {
    console.error("[porcelain-theme] SDK not found; dashboard may be outdated");
    return;
  }

  installPorcelainThemeSwatch();

  function installPorcelainThemeSwatch() {
    const paint = () => {
      const options = document.querySelectorAll('button[role="option"]');
      options.forEach((option) => {
        const label = (option.textContent || "").trim();
        if (!/\bporcelain\b/i.test(label)) return;

        const swatch = option.querySelector('[aria-hidden="true"].h-4.w-9.shrink-0');
        if (!swatch || swatch.dataset.porcelainSwatch === "true") return;

        swatch.dataset.porcelainSwatch = "true";
        swatch.classList.remove("border-dashed");
        swatch.innerHTML = "";
        swatch.style.display = "flex";
        swatch.style.overflow = "hidden";
        swatch.style.borderStyle = "solid";
        swatch.style.borderColor = "#d4d4d4";

        ["#000000", "#262626", "#e5e5e5"].forEach((color) => {
          const part = document.createElement("span");
          part.style.flex = "1 1 0";
          part.style.background = color;
          swatch.appendChild(part);
        });
      });
    };

    paint();
    const observer = new MutationObserver(paint);
    observer.observe(document.body, { childList: true, subtree: true });
  }

  window.__HERMES_PLUGINS__.register("porcelain-theme", function PorcelainThemeCompanion() {
    return null;
  });

  console.log("[porcelain-theme] companion loaded");
})();
