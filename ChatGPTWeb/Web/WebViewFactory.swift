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
     const css = `
     :root {
      color-scheme:dark!important;
      --nc-ink:#eaf7ff;--nc-muted:#a9c3d2;--nc-yellow:#ffdf55;--nc-cyan:#59f2ee;
      --nc-pink:#ff62b0;--nc-blue:#69aaff;--nc-violet:#a58bff;
      --nc-bg:#101b31;--nc-glass:rgba(17,31,53,.90);--nc-glass2:rgba(25,43,68,.94);
      --nc-line:rgba(89,242,238,.46);--nc-shadow:rgba(0,0,0,.28);
     }
     html,body {min-height:100%;background:#14233b!important;color:var(--nc-ink)!important;color-scheme:dark!important}
     body {
      background:
       radial-gradient(ellipse at 12% 18%,rgba(255,98,176,.28),transparent 33%),
       radial-gradient(ellipse at 86% 23%,rgba(57,179,228,.27),transparent 37%),
       radial-gradient(ellipse at 52% 78%,rgba(255,193,72,.14),transparent 40%),
       linear-gradient(145deg,#1b2948 0%,#172b42 43%,#26324b 72%,#17243b 100%)!important;
      background-attachment:fixed!important;color:var(--nc-ink)!important;
      font-family:-apple-system,BlinkMacSystemFont,"SF Pro Text",sans-serif!important;
     }
     /* A layered city panorama: colored haze, high-rises, lit windows, holographic billboards. */
     .nc-world {position:fixed;inset:0;z-index:0;overflow:hidden;pointer-events:none;contain:strict}
     .nc-world:before {
      content:"";position:absolute;left:-5%;right:-5%;bottom:0;height:43%;
      background:
       repeating-linear-gradient(90deg,transparent 0 13px,rgba(5,14,29,.78) 14px 48px,transparent 49px 56px,rgba(11,24,43,.92) 57px 104px,transparent 105px 113px),
       repeating-linear-gradient(0deg,transparent 0 12px,rgba(255,222,85,.34) 13px 14px,transparent 15px 24px),
       linear-gradient(180deg,rgba(30,49,74,.18),rgba(7,15,30,.80));
      -webkit-mask-image:linear-gradient(to top,black 0%,black 55%,transparent 100%);
      mask-image:linear-gradient(to top,black 0%,black 55%,transparent 100%);
     }
     .nc-world:after {
      content:"";position:absolute;inset:0;
      background:repeating-linear-gradient(0deg,transparent 0 5px,rgba(145,211,255,.025) 6px 7px);
      opacity:.55;
     }
     .nc-sign {
      position:absolute;display:flex;align-items:center;justify-content:center;text-align:center;
      padding:8px 11px;min-height:37px;box-sizing:border-box;
      color:#eaffff;font:800 9px/1.35 ui-monospace,Menlo,monospace;letter-spacing:1.5px;
      background:linear-gradient(110deg,rgba(18,52,76,.9),rgba(65,27,75,.82));
      border:1px solid rgba(89,242,238,.88);border-left:4px solid var(--nc-cyan);
      box-shadow:0 0 7px rgba(89,242,238,.55),0 0 24px rgba(89,242,238,.24),inset 0 0 16px rgba(89,242,238,.12);
      text-shadow:0 0 9px rgba(89,242,238,.9);transform:perspective(180px) rotateY(-7deg);
      opacity:.83;
     }
     .nc-sign.a {top:17%;right:-8px;width:122px;min-height:66px;color:#fff1fb;border-color:var(--nc-pink);border-left-color:var(--nc-pink);background:linear-gradient(130deg,rgba(79,24,66,.92),rgba(27,36,67,.9));box-shadow:0 0 9px rgba(255,98,176,.6),0 0 28px rgba(255,98,176,.25);text-shadow:0 0 10px var(--nc-pink)}
     .nc-sign.b {top:39%;left:-13px;width:105px;min-height:54px;transform:perspective(180px) rotateY(8deg);border-color:var(--nc-yellow);border-left-color:var(--nc-yellow);background:linear-gradient(130deg,rgba(82,61,25,.94),rgba(27,36,67,.9));box-shadow:0 0 9px rgba(255,223,85,.55),0 0 24px rgba(255,223,85,.2);text-shadow:0 0 9px var(--nc-yellow)}
     #root,#__next,body>div:not(.nc-world) {position:relative;z-index:1}
     main,[role=main],#thread,[data-testid*=conversation], [data-testid*=conversation-turns],
     [class*=conversation], [class*=Conversation] {background:transparent!important}
     body:before {content:"";position:fixed;top:0;left:0;right:0;height:3px;z-index:99999;pointer-events:none;background:linear-gradient(90deg,var(--nc-pink),var(--nc-violet),var(--nc-cyan),var(--nc-yellow));box-shadow:0 0 13px rgba(89,242,238,.7)}
     body :where(p,li,h1,h2,h3,h4,h5,h6,strong,em,b,i,label,small,blockquote,td,th,time,figcaption,span) {color:var(--nc-ink)}
     body :where(a) {color:var(--nc-cyan)!important}
     /* Left navigation: readable glass panels, luminous dividers, clear labels. */
     nav,aside,[role=navigation],[data-testid*=sidebar] {
      color:#f0f8ff!important;background:linear-gradient(145deg,rgba(29,43,68,.98),rgba(19,35,57,.98))!important;
      border-color:rgba(105,170,255,.42)!important;box-shadow:8px 0 32px rgba(3,9,20,.28)!important;
     }
     nav :where(span,p,a,button,div),aside :where(span,p,a,button,div),
     [role=navigation] :where(span,p,a,button,div),[data-testid*=sidebar] :where(span,p,a,button,div) {color:#edf7ff!important}
     nav button,aside button,[role=navigation] button,[data-testid*=sidebar] button {
      background:rgba(91,154,202,.10)!important;border:1px solid rgba(125,190,225,.16)!important;border-radius:8px!important;
     }
     nav button:active,aside button:active,[role=navigation] button:active {background:rgba(89,242,238,.22)!important}
     /* Chat messages become floating glass panels, not black slabs. */
     [data-message-author-role] {position:relative!important;isolation:isolate;padding:15px 16px!important;backdrop-filter:blur(12px);border-radius:14px!important}
     [data-message-author-role=user] {
      background:linear-gradient(120deg,rgba(104,76,29,.90),rgba(54,52,63,.91))!important;
      border:1px solid rgba(255,223,85,.65)!important;border-right:4px solid var(--nc-yellow)!important;
      box-shadow:0 8px 22px var(--nc-shadow),inset 0 0 22px rgba(255,223,85,.08)!important;
      margin:16px 0 20px auto!important;max-width:min(94%,780px)!important;
     }
     [data-message-author-role=assistant] {
      background:linear-gradient(125deg,rgba(24,59,78,.93),rgba(38,43,75,.94))!important;
      border:1px solid rgba(89,242,238,.56)!important;border-left:4px solid var(--nc-cyan)!important;
      box-shadow:0 8px 24px var(--nc-shadow),0 0 18px rgba(89,242,238,.10)!important;
      margin:18px 0 24px!important;
     }
     [data-message-author-role=user] :where(p,span,div,li,strong,em,b,i),
     [data-message-author-role=assistant] :where(p,span,div,li,strong,em,b,i,blockquote,td,th) {color:#f3f8ff!important}
     [data-message-author-role=assistant] pre,[data-message-author-role=assistant] code,pre,code {
      background:rgba(8,19,37,.82)!important;color:#c7faff!important;border:1px solid rgba(89,242,238,.30)!important;border-radius:7px!important
     }
     /* Composer is a neon street kiosk with individual illuminated controls. */
     form:has(textarea),[data-testid*=composer],[class*=composer] {
      background:linear-gradient(120deg,rgba(24,43,68,.97),rgba(43,39,68,.97))!important;
      border:1px solid rgba(89,242,238,.62)!important;border-radius:13px!important;
      box-shadow:0 -5px 25px rgba(0,0,0,.25),0 0 18px rgba(89,242,238,.18),inset 0 1px rgba(255,255,255,.10)!important;
      backdrop-filter:blur(18px)!important;
     }
     textarea,[contenteditable=true] {color:#f5fbff!important;-webkit-text-fill-color:#f5fbff!important;caret-color:var(--nc-yellow)!important}
     textarea::placeholder,[contenteditable=true][data-placeholder] {color:#b4c9dc!important;-webkit-text-fill-color:#b4c9dc!important;opacity:1!important}
     /* Accessible labels let us distinguish attach, voice, send and stop without replacing their native actions. */
     .nc-neon-control {
      min-width:38px!important;min-height:38px!important;border-radius:9px!important;
      border:1px solid rgba(89,242,238,.62)!important;background:linear-gradient(145deg,rgba(36,83,105,.96),rgba(29,49,79,.96))!important;
      color:#eaffff!important;box-shadow:0 0 9px rgba(89,242,238,.20),inset 0 0 10px rgba(89,242,238,.10)!important;
      transition:transform .14s ease,filter .14s ease,box-shadow .14s ease!important;
     }
     .nc-neon-control:active {transform:scale(.92)!important;filter:brightness(1.3)!important;box-shadow:0 0 18px rgba(89,242,238,.58)!important}
     .nc-neon-control.nc-attach {border-color:rgba(105,170,255,.85)!important;background:linear-gradient(135deg,rgba(36,74,124,.98),rgba(34,53,86,.98))!important;box-shadow:0 0 12px rgba(105,170,255,.24)!important}
     .nc-neon-control.nc-voice {border-color:rgba(255,98,176,.85)!important;background:linear-gradient(135deg,rgba(111,39,91,.98),rgba(59,39,79,.98))!important;box-shadow:0 0 12px rgba(255,98,176,.27)!important}
     .nc-neon-control.nc-send {border-color:var(--nc-yellow)!important;background:linear-gradient(135deg,#ffe978,#ffb83f)!important;color:#252238!important;box-shadow:0 0 8px rgba(255,223,85,.55),0 0 20px rgba(255,185,63,.25)!important}
     .nc-neon-control.nc-stop {border-color:#ff668e!important;background:linear-gradient(135deg,#ff658c,#bd3c79)!important;color:white!important;box-shadow:0 0 10px rgba(255,75,128,.48)!important}
     .nc-neon-control svg {filter:drop-shadow(0 0 3px currentColor)}
     button:focus-visible,textarea:focus-visible,[contenteditable=true]:focus-visible {outline:2px solid var(--nc-yellow)!important;outline-offset:2px!important}
     ::selection {background:rgba(255,223,85,.38)!important;color:white!important}
     * {scrollbar-color:#5acbd6 transparent!important}
     @media(prefers-reduced-motion:reduce){*,*::before,*::after{animation:none!important;transition:none!important;scroll-behavior:auto!important}}
     `;
     const classify=()=>{
      const buttons=[...document.querySelectorAll('button')];
      buttons.forEach(b=>{
       const label=((b.getAttribute('aria-label')||'')+' '+(b.getAttribute('title')||'')+' '+(b.innerText||'')).toLowerCase();
       const inComposer=!!b.closest('form,[data-testid*=composer],[class*=composer]');
       if(!inComposer)return;
       b.classList.add('nc-neon-control');
       if(/attach|upload|file|image|photo|添加|附件|上传|照片|图片/.test(label)) b.classList.add('nc-attach');
       else if(/voice|microphone|dictation|语音|麦克风/.test(label)) b.classList.add('nc-voice');
       else if(/stop|停止|cancel|取消/.test(label)) b.classList.add('nc-stop');
       else if(/send|发送/.test(label)||b.matches('[data-testid*=send]')) b.classList.add('nc-send');
      });
     };
     const install=()=>{
      if(!document.documentElement)return;
      if(!document.getElementById('night-city-v2-style')){
       const s=document.createElement('style');s.id='night-city-v2-style';s.textContent=css;(document.head||document.documentElement).appendChild(s);
      }
      if(document.body&&!document.querySelector('.nc-world')){
       const world=document.createElement('div');world.className='nc-world';world.setAttribute('aria-hidden','true');
       const a=document.createElement('div');a.className='nc-sign a';a.textContent='NIGHT CITY\A CITY LIGHTS';a.style.whiteSpace='pre-line';
       const b=document.createElement('div');b.className='nc-sign b';b.textContent='AFTERLIFE\A NETRUNNER BAR';b.style.whiteSpace='pre-line';
       world.append(a,b);document.body.insertBefore(world,document.body.firstChild);
      }
      classify();
     };
     install();
     new MutationObserver(()=>{install();classify()}).observe(document,{childList:true,subtree:true,attributes:true,attributeFilter:['aria-label','title']});
    })();
    """#
}
