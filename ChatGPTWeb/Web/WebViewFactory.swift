import WebKit

enum WebViewFactory {
    static func makeConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        let preferences = WKPreferences()
        preferences.isFraudulentWebsiteWarningEnabled = true
        configuration.preferences = preferences
        let theme = WKUserScript(source: Self.nightCityTheme, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(theme)
        return configuration
    }

    static func makeWebView(configuration: WKWebViewConfiguration? = nil) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: configuration ?? makeConfiguration())
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        webView.scrollView.keyboardDismissMode = .interactive
        webView.backgroundColor = .systemBackground
        webView.scrollView.backgroundColor = .systemBackground
        webView.isOpaque = false
        return webView
    }

    private static let nightCityTheme = #"""
    (() => {
      const css = \`
      :root {color-scheme:dark!important;--nc-ink:#f1f7ff;--nc-yellow:#ffe16b;--nc-cyan:#63f4ed;--nc-pink:#ff70c2;--nc-blue:#83baff;--nc-violet:#b49aff}
      html,body {min-height:100%;background:transparent!important;color:var(--nc-ink)!important;color-scheme:dark!important}
      body {background:transparent!important;color:var(--nc-ink)!important;font-family:-apple-system,BlinkMacSystemFont,"SF Pro Text",sans-serif!important}
      .nc-world {position:fixed;inset:0;z-index:0;overflow:hidden;pointer-events:none;contain:strict;
        background:radial-gradient(ellipse at 12% 23%,rgba(255,63,171,.38),transparent 28%),radial-gradient(ellipse at 86% 30%,rgba(42,221,234,.34),transparent 31%),radial-gradient(ellipse at 53% 62%,rgba(126,90,237,.30),transparent 43%),linear-gradient(180deg,#17233f 0%,#283957 42%,#354660 68%,#17243b 100%)}
      .nc-world:before {content:"";position:absolute;inset:27% -8% 0;background:repeating-linear-gradient(90deg,transparent 0 13px,rgba(255,218,103,.86) 14px 16px,transparent 17px 26px,rgba(89,234,242,.72) 27px 29px,transparent 30px 43px),repeating-linear-gradient(0deg,transparent 0 17px,rgba(255,196,87,.40) 18px 20px,transparent 21px 34px),repeating-linear-gradient(90deg,#081426 0 35px,#142844 36px 72px,#091629 73px 112px,transparent 113px 125px);clip-path:polygon(0 28%,7% 28%,7% 12%,15% 12%,15% 37%,23% 37%,23% 7%,31% 7%,31% 28%,39% 28%,39% 17%,47% 17%,47% 0,56% 0,56% 32%,64% 32%,64% 10%,72% 10%,72% 34%,80% 34%,80% 8%,88% 8%,88% 24%,100% 24%,100% 100%,0 100%);-webkit-mask-image:linear-gradient(to top,black 0%,black 82%,transparent 100%);mask-image:linear-gradient(to top,black 0%,black 82%,transparent 100%);filter:drop-shadow(0 -8px 22px rgba(72,225,238,.20))}
      .nc-world:after {content:"";position:absolute;inset:0;background:linear-gradient(112deg,transparent 0 22%,rgba(255,79,185,.12) 23%,transparent 39%),linear-gradient(72deg,transparent 0 58%,rgba(68,231,239,.12) 59%,transparent 77%),repeating-linear-gradient(0deg,transparent 0 4px,rgba(190,225,255,.05) 5px 6px);opacity:.9}
      .nc-haze {position:absolute;inset:38% -10% -5%;background:linear-gradient(180deg,transparent,rgba(77,210,222,.16) 48%,rgba(11,22,42,.54));filter:blur(16px)}
      .nc-rain {position:absolute;inset:-30% 0 0;opacity:.24;background:repeating-linear-gradient(104deg,transparent 0 22px,rgba(164,225,255,.18) 23px,transparent 24px 61px);animation:nc-rain-drift 11s linear infinite}
      @keyframes nc-rain-drift {to{transform:translate3d(-35px,90px,0)}}
      .nc-sign {position:absolute;display:flex;align-items:center;justify-content:center;text-align:center;box-sizing:border-box;padding:7px 9px;min-height:38px;color:#f4fcff;font:900 9px/1.35 ui-monospace,Menlo,monospace;letter-spacing:1.25px;background:linear-gradient(120deg,rgba(13,48,72,.96),rgba(49,27,70,.94));border:1px solid rgba(99,244,237,.92);border-left:4px solid var(--nc-cyan);box-shadow:0 0 8px rgba(99,244,237,.65),0 0 25px rgba(99,244,237,.25),inset 0 0 15px rgba(99,244,237,.16);text-shadow:0 0 9px currentColor;opacity:.94;transform:perspective(180px) rotateY(-7deg)}
      .nc-sign.a {top:15%;right:-7px;width:122px;min-height:66px;color:#fff0fa;border-color:var(--nc-pink);border-left-color:var(--nc-pink);background:linear-gradient(130deg,rgba(87,24,72,.97),rgba(29,37,69,.95));box-shadow:0 0 10px rgba(255,112,194,.7),0 0 28px rgba(255,112,194,.32)}
      .nc-sign.b {top:38%;left:-11px;width:108px;min-height:56px;color:#fff8d5;border-color:var(--nc-yellow);border-left-color:var(--nc-yellow);background:linear-gradient(130deg,rgba(86,62,23,.97),rgba(29,37,69,.95));box-shadow:0 0 10px rgba(255,225,107,.62),0 0 25px rgba(255,225,107,.24);transform:perspective(180px) rotateY(8deg)}
      .nc-sign.c {top:59%;right:8%;width:94px;min-height:44px;color:#dceaff;border-color:var(--nc-blue);background:linear-gradient(130deg,rgba(22,53,104,.97),rgba(32,39,82,.96));box-shadow:0 0 12px rgba(131,186,255,.68),0 0 28px rgba(131,186,255,.30)}
      #root,#__next,body>div:not(.nc-world) {position:relative;z-index:1;background:transparent!important}
      main,[role=main],#thread,[data-testid*=conversation],[data-testid*=conversation-turns],[class*=conversation],[class*=Conversation],[class*=scrollArea],[class*=scroll-area],[class*=bg-token-main-surface],[class*=bg-token-sidebar-surface] {background-color:transparent!important;background-image:none!important}
      main>div,[role=main]>div,[data-testid*=conversation]>div {background:transparent!important}
      body:before {content:"";position:fixed;top:0;left:0;right:0;height:3px;z-index:99999;pointer-events:none;background:linear-gradient(90deg,var(--nc-pink),var(--nc-violet),var(--nc-cyan),var(--nc-yellow));box-shadow:0 0 13px rgba(89,242,238,.75)}
      body :where(p,li,h1,h2,h3,h4,h5,h6,strong,em,b,i,label,small,blockquote,td,th,time,figcaption,span) {color:var(--nc-ink)}
      body a {color:var(--nc-cyan)!important}
      nav,aside,[role=navigation],[data-testid*=sidebar] {color:#f0f8ff!important;background:linear-gradient(145deg,rgba(35,52,79,.98),rgba(20,39,64,.98))!important;border-color:rgba(131,186,255,.48)!important;box-shadow:8px 0 32px rgba(3,9,20,.32)!important}
      nav :where(span,p,a,button,div),aside :where(span,p,a,button,div),[role=navigation] :where(span,p,a,button,div),[data-testid*=sidebar] :where(span,p,a,button,div) {color:#f1f8ff!important}
      nav button,aside button,[role=navigation] button,[data-testid*=sidebar] button {background:rgba(91,154,202,.13)!important;border:1px solid rgba(125,190,225,.20)!important;border-radius:8px!important}
      [data-message-author-role] {position:relative!important;isolation:isolate;box-sizing:border-box!important;padding:23px 16px 16px!important;border-radius:15px 3px 15px 3px!important;backdrop-filter:blur(15px)!important;overflow-wrap:anywhere!important}
      [data-message-author-role]:before {position:absolute;top:5px;left:14px;z-index:2;font:800 8px/1.2 ui-monospace,Menlo,monospace;letter-spacing:1.4px;opacity:.92;pointer-events:none}
      [data-message-author-role]:after {content:"";position:absolute;top:8px;right:13px;width:24px;height:2px;background:currentColor;opacity:.8;box-shadow:0 0 8px currentColor;pointer-events:none}
      [data-message-author-role=user] {background:linear-gradient(120deg,rgba(95,66,25,.88),rgba(48,48,67,.91))!important;border:1px solid rgba(255,225,107,.76)!important;border-right:3px solid var(--nc-yellow)!important;box-shadow:0 8px 22px rgba(0,0,0,.30),0 0 18px rgba(255,225,107,.13),inset 0 0 22px rgba(255,225,107,.10)!important;margin:16px 0 20px auto!important;max-width:min(94%,780px)!important}
      [data-message-author-role=user]:before {content:"OUTGOING // USER TRANSMISSION";color:var(--nc-yellow);text-shadow:0 0 8px rgba(255,225,107,.8)}
      [data-message-author-role=assistant] {background:linear-gradient(125deg,rgba(20,66,82,.90),rgba(43,39,78,.93))!important;border:1px solid rgba(99,244,237,.68)!important;border-left:3px solid var(--nc-cyan)!important;box-shadow:0 8px 24px rgba(0,0,0,.30),0 0 20px rgba(99,244,237,.15),inset 0 0 22px rgba(99,244,237,.09)!important;margin:18px 0 24px!important}
      [data-message-author-role=assistant]:before {content:"INCOMING // NETRUNNER RESPONSE";color:var(--nc-cyan);text-shadow:0 0 8px rgba(99,244,237,.8)}
      [data-message-author-role=user] :where(p,span,div,li,strong,em,b,i),[data-message-author-role=assistant] :where(p,span,div,li,strong,em,b,i,blockquote,td,th) {color:#f4f8ff!important}
      [data-message-author-role] pre,pre {max-width:100%!important;overflow-x:auto!important;white-space:pre!important}
      [data-message-author-role] code,[data-message-author-role] pre,pre,code {background:rgba(7,18,35,.88)!important;color:#d2fbff!important;border:1px solid rgba(99,244,237,.36)!important;border-radius:7px!important}
      form:has(textarea),[data-testid*=composer],[class*=composer] {background:linear-gradient(120deg,rgba(17,43,65,.94),rgba(48,34,69,.95))!important;border:1px solid rgba(99,244,237,.74)!important;border-radius:15px 4px 15px 4px!important;box-shadow:0 -5px 25px rgba(0,0,0,.26),0 0 20px rgba(99,244,237,.22),inset 0 1px rgba(255,255,255,.12)!important;backdrop-filter:blur(18px)!important}
      form:has(textarea) {padding:8px!important}
      textarea,[contenteditable=true] {color:#f5fbff!important;-webkit-text-fill-color:#f5fbff!important;caret-color:var(--nc-yellow)!important}
      textarea::placeholder,[contenteditable=true][data-placeholder] {color:#c0d3e5!important;-webkit-text-fill-color:#c0d3e5!important;opacity:1!important}
      .nc-control-row {display:flex!important;align-items:center!important;justify-content:flex-end!important;flex-wrap:wrap!important;gap:7px!important;min-width:0!important;max-width:100%!important}
      .nc-neon-control {position:relative!important;display:inline-flex!important;flex:0 1 auto!important;align-items:center!important;justify-content:center!important;box-sizing:border-box!important;min-width:38px!important;min-height:38px!important;width:auto!important;height:auto!important;max-width:100%!important;padding:8px 11px!important;overflow:hidden!important;white-space:normal!important;overflow-wrap:anywhere!important;border:1px solid rgba(117,238,245,.90)!important;border-radius:7px 2px 7px 2px!important;background:linear-gradient(145deg,rgba(17,64,87,.98),rgba(30,35,69,.98))!important;color:#edffff!important;box-shadow:0 0 0 2px rgba(34,198,218,.12),0 0 10px rgba(89,242,238,.42),inset 0 0 12px rgba(89,242,238,.17)!important;text-shadow:0 0 8px currentColor!important;line-height:1.15!important;font-size:12px!important;transition:transform .14s ease,filter .14s ease,box-shadow .14s ease!important}
      .nc-neon-control:before {content:"";position:absolute;inset:3px;border:1px solid rgba(219,255,255,.22);border-radius:4px 1px 4px 1px;pointer-events:none}
      .nc-neon-control:after {content:"";position:absolute;left:7px;right:7px;bottom:2px;height:1px;background:currentColor;opacity:.9;box-shadow:0 0 7px currentColor;pointer-events:none}
      .nc-neon-control.nc-icon-only {width:40px!important;height:40px!important;min-width:40px!important;padding:0!important;flex:0 0 40px!important}
      .nc-neon-control svg {display:block!important;flex:0 0 auto!important;width:18px!important;height:18px!important;max-width:100%!important;max-height:100%!important;overflow:visible!important;filter:drop-shadow(0 0 4px currentColor)!important}
      .nc-neon-control :where(span,div) {position:relative!important;z-index:1;max-width:100%!important;white-space:inherit!important;overflow-wrap:anywhere!important}
      .nc-neon-control.nc-attach {color:#9bcaff!important;border-color:#9bcaff!important;box-shadow:0 0 10px rgba(131,186,255,.48),inset 0 0 12px rgba(131,186,255,.17)!important}
      .nc-neon-control.nc-voice {color:#ff9bd2!important;border-color:#ff9bd2!important;box-shadow:0 0 10px rgba(255,112,194,.48),inset 0 0 12px rgba(255,112,194,.17)!important}
      .nc-neon-control.nc-send {color:#ffe98a!important;border-color:#ffe98a!important;box-shadow:0 0 12px rgba(255,225,107,.55),inset 0 0 12px rgba(255,225,107,.18)!important}
      .nc-neon-control.nc-stop {color:#ff91a9!important;border-color:#ff91a9!important;box-shadow:0 0 10px rgba(255,91,133,.48),inset 0 0 12px rgba(255,91,133,.17)!important}
      .nc-neon-control:active {transform:translateY(1px) scale(.96)!important;filter:brightness(1.35)!important;box-shadow:0 0 17px currentColor,inset 0 0 14px rgba(255,255,255,.18)!important}
      button:focus-visible,textarea:focus-visible,[contenteditable=true]:focus-visible {outline:2px solid var(--nc-yellow)!important;outline-offset:2px!important}
      ::selection {background:rgba(255,225,107,.38)!important;color:white!important}
      * {scrollbar-color:#5acbd6 transparent!important}
      @media(prefers-reduced-motion:reduce){*,*::before,*::after{animation:none!important;transition:none!important;scroll-behavior:auto!important}}
      \`;
      const classify=()=>{
        const buttons=[...document.querySelectorAll('button')];
        buttons.forEach(b=>{
          const label=((b.getAttribute('aria-label')||'')+' '+(b.getAttribute('title')||'')+' '+(b.innerText||'')).toLowerCase();
          const composer=b.closest('form,[data-testid*=composer],[class*=composer]');
          if(!composer)return;
          b.classList.add('nc-neon-control');
          const visibleText=(b.innerText||'').trim();
          if(!visibleText && b.querySelector('svg')) b.classList.add('nc-icon-only');
          if(/attach|upload|file|image|photo|添加|附件|上传|照片|图片/.test(label)) b.classList.add('nc-attach');
          else if(/voice|microphone|dictation|语音|麦克风/.test(label)) b.classList.add('nc-voice');
          else if(/stop|停止|cancel|取消/.test(label)) b.classList.add('nc-stop');
          else if(/send|发送/.test(label)||b.matches('[data-testid*=send]')) b.classList.add('nc-send');
        });
        document.querySelectorAll('form,[data-testid*=composer],[class*=composer]').forEach(c=>{
          const controls=[...c.querySelectorAll('button.nc-neon-control')];
          if(controls.length>1) {const parent=controls[0].parentElement;if(parent&&controls.every(b=>b.parentElement===parent)&&[...parent.children].every(child=>child.tagName==='BUTTON'))parent.classList.add('nc-control-row')}
        });
      };
      const install=()=>{
        if(!document.documentElement)return;
        if(!document.getElementById('night-city-v3-style')){const s=document.createElement('style');s.id='night-city-v3-style';s.textContent=css;(document.head||document.documentElement).appendChild(s)}
        if(document.body&&!document.querySelector('.nc-world')){
          const world=document.createElement('div');world.className='nc-world';world.setAttribute('aria-hidden','true');
          const haze=document.createElement('div');haze.className='nc-haze';
          const rain=document.createElement('div');rain.className='nc-rain';
          const a=document.createElement('div');a.className='nc-sign a';a.textContent='NIGHT CITY\\A LIVE FEED';a.style.whiteSpace='pre-line';
          const b=document.createElement('div');b.className='nc-sign b';b.textContent='AFTERLIFE\\A NETRUNNER BAR';b.style.whiteSpace='pre-line';
          const d=document.createElement('div');d.className='nc-sign c';d.textContent='NEON\\A DISTRICT 09';d.style.whiteSpace='pre-line';
          world.append(haze,rain,a,b,d);document.body.insertBefore(world,document.body.firstChild)
        }
        classify()
      };
      install();
      new MutationObserver(()=>{install();classify()}).observe(document,{childList:true,subtree:true,attributes:true,attributeFilter:['aria-label','title']});
    })();
    """#
}
