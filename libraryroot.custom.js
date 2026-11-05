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

/* Native Steam owns game rows, virtual scrolling and every game action.
   This rail adds only shortcuts. No cursor tracking, timers or render loop. */
(() => {
 window.__truevisionTactical?.dispose();
 let rail;
 const icons={library:'M4 4h6v16H4zM14 4h6v16h-6z',collections:'M4 4h6v6H4zM14 4h6v6h-6zM4 14h6v6H4zM14 14h6v6h-6z',downloads:'M12 3v12m-5-5 5 5 5-5M4 17v4h16v-4',store:'M3 5h2l2 11h11l3-8H6M9 20h.01M17 20h.01'};
 const actions=[['library','Library'],['collections','Collections'],['downloads','Downloads'],['store','Store']];
 const navigate=action=>{
  const owner=window.opener?.SteamUIStore?window.opener:window;
  if(action==='store')owner.MainWindowBrowserManager?.ActivateTab('store');
  else owner.SteamUIStore?.Navigate({library:'/library/home',collections:'/library/collections',downloads:'/downloads'}[action]);
 };
 const mount=()=>{
  if(rail?.isConnected)return;
  const library=document.querySelector('body.DesktopUI .Library');
  if(!library)return;
  rail=document.createElement('nav');rail.className='truevision-rail';rail.setAttribute('aria-label','TrueVision navigation');
  for(const [action,label] of actions){
   const button=document.createElement('button');button.type='button';button.className='truevision-rail-button';button.title=label;button.setAttribute('aria-label',label);button.dataset.action=action;
   button.innerHTML=`<svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="${icons[action]}"/></svg><span>${label}</span>`;
   button.addEventListener('click',()=>navigate(action));rail.append(button);
  }
  const profile=document.createElement('span');profile.className='truevision-rail-profile';profile.setAttribute('aria-hidden','true');rail.append(profile);
  library.append(rail);
 };
 const observer=new MutationObserver(mount);
 observer.observe(document.body,{childList:true,subtree:true});
 const dispose=()=>{observer.disconnect();rail?.remove();window.removeEventListener('pagehide',dispose);delete window.__truevisionTactical;};
 window.addEventListener('pagehide',dispose);window.__truevisionTactical={dispose,mount};mount();
})();
