/* TrueVision activity gate. Event-driven; no polling or rendering loop. */
(() => {
  window.__truevisionActivity?.dispose();
  const root = document.documentElement;
  const update = () => {
    const visible = document.visibilityState === 'visible';
    const fullscreen = Boolean(document.fullscreenElement);
    const maximized = Boolean(document.querySelector('.Wrapper.Maximized'));
    const active = visible && (document.hasFocus() || fullscreen || maximized);
    const value = String(active);
    if (root.dataset.truevisionAnimate !== value) root.dataset.truevisionAnimate = value;
  };
  const listeners = [
    [window, 'focus'], [window, 'blur'], [window, 'resize'],
    [document, 'visibilitychange'], [document, 'fullscreenchange'],
    [document, 'DOMContentLoaded'],
  ];
  for (const [target, event] of listeners) target.addEventListener(event, update);
  const dispose = () => {
    for (const [target, event] of listeners) target.removeEventListener(event, update);
    window.removeEventListener('pagehide', dispose);
    delete root.dataset.truevisionAnimate;
    delete window.__truevisionActivity;
  };
  window.addEventListener('pagehide', dispose);
  window.__truevisionActivity = { update, dispose };
  update();
})();

/* Preserve the installed base's UI fixes; no mouse-following capsule glow. */
(async () => {
 window.__minimalDarkCapsuleGlow?.dispose?.();
 for (const source of ["https://millennium.host/v1/themes/Minimal-Dark-for-Steam/libraryroot.custom.js","https://millennium.host/v1/themes/Minimal-Dark-for-Steam/elements/options/global_options/menus_context_menus/animation/js/m_cm_animation.js","https://millennium.host/v1/themes/Minimal-Dark-for-Steam/elements/options/library_options/library_labels/compact_library_labels.js","https://millennium.host/v1/themes/Minimal-Dark-for-Steam/elements/options/library_options/compact_lc/compact_library_collections.js","https://millennium.host/v1/themes/Minimal-Dark-for-Steam/elements/options/overlay_options/pixel_align/pixel_overlay.js","https://millennium.host/v1/themes/Minimal-Dark-for-Steam/elements/options/topbar_options/steam_menu_on_hover/open_on_hover.js"]) {
  try { await import(source); } catch (error) { console.warn('[TrueVision] Base script unavailable', source, error); }
 }
})();
