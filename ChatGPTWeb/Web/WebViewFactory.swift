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
      --nc-bg:#17233d;--nc-glass:rgba(24,39,66,.78);--nc-glass2:rgba(31,49,79,.84);
      --nc-line:rgba(89,242,238,.58);--nc-shadow:rgba(0,0,0,.28);
     }
     html,body {min-height:100%;background:transparent!important;color:var(--nc-ink)!important;color-scheme:dark!important}
     body {
      background:radial-gradient(ellipse at 50% 42%,rgba(43,78,116,.10),transparent 62%)!important;
      background-attachment:fixed!important;color:var(--nc-ink)!important;
      font-family:-apple-system,BlinkMacSystemFont,"SF Pro Text",sans-serif!important;
     }
     /* Full-screen Night City panorama: layered skyline, window grids, rain haze and holographic light. */
     .nc-world {position:fixed;inset:0;z-index:0;overflow:hidden;pointer-events:none;contain:strict;
      background:
       radial-gradient(ellipse at 12% 22%,rgba(255,67,166,.38),transparent 31%),
       radial-gradient(ellipse at 88% 29%,rgba(36,205,231,.34),transparent 34%),
       radial-gradient(ellipse at 52% 66%,rgba(111,85,220,.28),transparent 46%),
       linear-gradient(180deg,#18213c 0%,#253552 38%,#34445c 67%,#17243a 100%);
     }
     .nc-world:before {
      content:"";position:absolute;left:-8%;right:-8%;bottom:0;height:57%;
      background:
       repeating-linear-gradient(90deg,transparent 0 11px,rgba(255,213,91,.78) 12px 14px,transparent 15px 22px,rgba(78,224,238,.55) 23px 25px,transparent 26px 38px),
       repeating-linear-gradient(0deg,transparent 0 15px,rgba(255,196,83,.38) 16px 18px,transparent 19px 31px),
       repeating-linear-gradient(90deg,rgba(7,17,34,.94) 0 32px,rgba(20,36,59,.98) 33px 67px,rgba(8,17,34,.94) 68px 104px,transparent 105px 119px);
      clip-path:polygon(0 28%,8% 28%,8% 13%,16% 13%,16% 36%,23% 36%,23% 5%,31% 5%,31% 27%,39% 27%,39% 17%,47% 17%,47% 0,56% 0,56% 31%,64% 31%,64% 11%,72% 11%,72% 35%,80% 35%,80% 8%,88% 8%,88% 24%,100% 24%,100% 100%,0 100%);
      -webkit-mask-image:linear-gradient(to top,black 0%,black 78%,transparent 100%);
      mask-image:linear-gradient(to top,black 0%,black 78%,transparent 100%);
      filter:drop-shadow(0 -8px 18px rgba(70,217,235,.15));
     }
     .nc-world:after {
      content:"";position:absolute;inset:0;
      background:
       linear-gradient(112deg,transparent 0 24%,rgba(255,74,176,.09) 25%,transparent 39%),
       linear-gradient(72deg,transparent 0 57%,rgba(68,231,239,.10) 58%,transparent 76%),
       repeating-linear-gradient(0deg,transparent 0 5px,rgba(190,225,255,.045) 6px 7px);
      opacity:.82;
     }
     .nc-world .nc-haze {position:absolute;inset:35% -10% 0;background:linear-gradient(180deg,transparent,rgba(67,189,211,.13) 48%,rgba(15,24,43,.55));filter:blur(18px)}
     .nc-world .nc-sign.c {top:58%;right:9%;width:94px;min-height:43px;border-color:#68a9ff;background:linear-gradient(130deg,rgba(22,53,104,.95),rgba(32,39,82,.94));box-shadow:0 0 12px rgba(105,170,255,.65),0 0 28px rgba(105,170,255,.28);text-shadow:0 0 10px #69aaff;transform:perspective(180px) rotateY(-5deg)}
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
     #root,#__next,body>div:not(.nc-world) {position:relative;z-index:1;background:transparent!important}
     main,[role=main],#thread,[data-testid*=conversation],[data-testid*=conversation-turns],
     [class*=conversation],[class*=Conversation],[class*=scrollArea],[class*=scroll-area] {background:transparent!important}
     main>div, [role=main]>div {background-color:transparent!important}
     [data-testid*=conversation] :where(section,article) {background-color:transparent!important}
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
     /* Composer is one coherent neon street terminal; all controls share the same chassis. */
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
      position:relative!important;display:inline-flex!important;align-items:center!important;justify-content:center!important;
      min-width:40px!important;min-height:40px!important;width:40px!important;height:40px!important;
      padding:0!important;overflow:visible!important;border-radius:7px!important;
      border:1px solid rgba(117,238,245,.88)!important;
      background:linear-gradient(145deg,rgba(21,62,87,.98),rgba(23,35,66,.98))!important;
      color:#eaffff!important;
      box-shadow:0 0 0 2px rgba(34,198,218,.12),0 0 9px rgba(89,242,238,.38),0 0 20px rgba(89,242,238,.16),inset 0 0 12px rgba(89,242,238,.17)!important;
      text-shadow:0 0 8px currentColor!important;
      transition:transform .14s ease,filter .14s ease,box-shadow .14s ease!important;
     }
     .nc-neon-control:before {content:"";position:absolute;inset:3px;border:1px solid rgba(219,255,255,.20);border-radius:4px;pointer-events:none}
     .nc-neon-control:after {content:"";position:absolute;left:7px;right:7px;bottom:-3px;height:2px;background:currentColor;opacity:.85;box-shadow:0 0 7px currentColor;pointer-events:none}
     .nc-neon-control:active {transform:translateY(1px) scale(.94)!important;filter:brightness(1.35)!important;box-shadow:0 0 16px currentColor,inset 0 0 15px rgba(255,255,255,.18)!important}
     .nc-neon-control.nc-attach,.nc-neon-control.nc-voice,.nc-neon-control.nc-send,.nc-neon-control.nc-stop {background:linear-gradient(145deg,rgba(21,62,87,.98),rgba(23,35,66,.98))!important}
     .nc-neon-control.nc-attach {color:#8ec7ff!important;border-color:#8ec7ff!important;box-shadow:0 0 0 2px rgba(105,170,255,.12),0 0 12px rgba(105,170,255,.42),inset 0 0 12px rgba(105,170,255,.16)!important}
     .nc-neon-control.nc-voice {color:#ff8bc8!important;border-color:#ff8bc8!important;box-shadow:0 0 0 2px rgba(255,98,176,.12),0 0 12px rgba(255,98,176,.42),inset 0 0 12px rgba(255,98,176,.16)!important}
     .nc-neon-control.nc-send {color:#ffe77a!important;border-color:#ffe77a!important;box-shadow:0 0 0 2px rgba(255,223,85,.12),0 0 14px rgba(255,223,85,.48),inset 0 0 12px rgba(255,223,85,.17)!important}
     .nc-neon-control.nc-stop {color:#ff829d!important;border-color:#ff829d!important;box-shadow:0 0 0 2px rgba(255,75,128,.12),0 0 12px rgba(255,75,128,.42),inset 0 0 12px rgba(255,75,128,.16)!important}
     .nc-neon-control svg {filter:drop-shadow(0 0 4px currentColor)!important}
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
