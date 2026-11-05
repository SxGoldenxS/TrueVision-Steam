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
