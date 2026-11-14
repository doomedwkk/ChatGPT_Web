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
      :root {color-scheme:dark!important;--nc-ink:#f1f7ff;--nc-yellow:#ffe16b;--nc-cyan:#63f4ed;--nc-pink:#ff70c2;--nc-blue:#83baff;--nc-violet:#b49aff}
      html,body {min-height:100%;background:transparent!important;color:var(--nc-ink)!important;color-scheme:dark!important}
      body {background:transparent!important;color:var(--nc-ink)!important;font-family:-apple-system,BlinkMacSystemFont,"SF Pro Text",sans-serif!important}
      .nc-world {position:fixed;inset:0;z-index:0;overflow:hidden;pointer-events:none;contain:strict;
        background-color:#080b14;
        background-image:linear-gradient(180deg,rgba(5,8,17,.92) 0%,rgba(5,8,17,.76) 38%,rgba(5,8,17,.28) 68%,rgba(5,8,17,.40) 100%),url("https://cdn.mos.cms.futurecdn.net/C4VE97yVxb2GaQtzYN8ukM.jpg");
        background-size:100% 100%,100% auto;background-position:center,center bottom;background-repeat:no-repeat}
      .nc-world:before {content:"";position:absolute;inset:0;background:linear-gradient(90deg,rgba(5,8,17,.34),transparent 34%,transparent 70%,rgba(5,8,17,.34));}
      .nc-world:after {content:"";position:absolute;inset:0;background:linear-gradient(180deg,transparent 54%,rgba(5,8,17,.08) 70%,rgba(5,8,17,.48) 100%);}
      #root,#__next,body>div:not(.nc-world) {position:relative;z-index:1;background:transparent!important}
      main,[role=main],#thread,[data-testid*=conversation],[data-testid*=conversation-turns],[class*=conversation],[class*=Conversation],[class*=scrollArea],[class*=scroll-area],[class*=bg-token-main-surface],[class*=bg-token-sidebar-surface] {background-color:transparent!important;background-image:none!important}
      main>div,[role=main]>div,[data-testid*=conversation]>div {background:transparent!important}
      body:before {content:"";position:fixed;top:0;left:0;right:0;height:3px;z-index:99999;pointer-events:none;background:linear-gradient(90deg,var(--nc-pink),var(--nc-violet),var(--nc-cyan),var(--nc-yellow));box-shadow:0 0 13px rgba(89,242,238,.75)}
      body :where(p,li,h1,h2,h3,h4,h5,h6,strong,em,b,i,label,small,blockquote,td,th,time,figcaption,span) {color:var(--nc-ink)}
      body a {color:var(--nc-cyan)!important}
      nav,aside,[role=navigation],[data-testid*=sidebar] {color:#f0f8ff!important;background:linear-gradient(145deg,rgba(35,52,79,.98),rgba(20,39,64,.98))!important;border-color:rgba(131,186,255,.48)!important;box-shadow:8px 0 32px rgba(3,9,20,.32)!important}
      nav :where(span,p,a,button,div),aside :where(span,p,a,button,div),[role=navigation] :where(span,p,a,button,div),[data-testid*=sidebar] :where(span,p,a,button,div) {color:#f1f8ff!important}
      nav button,aside button,[role=navigation] button,[data-testid*=sidebar] button {background:rgba(91,154,202,.13)!important;border:1px solid rgba(125,190,225,.20)!important;border-radius:8px!important}
      [data-message-author-role] {position:relative!important;isolation:isolate;box-sizing:border-box!important;padding:18px 15px 14px!important;border-radius:12px 3px 12px 3px!important;backdrop-filter:blur(12px)!important;overflow-wrap:anywhere!important}
      [data-message-author-role]:before {position:absolute;top:5px;left:13px;z-index:2;font:800 7px/1.2 ui-monospace,Menlo,monospace;letter-spacing:1.2px;opacity:.72;pointer-events:none}
      [data-message-author-role]:after {content:"";position:absolute;top:8px;right:12px;width:18px;height:2px;background:currentColor;opacity:.72;box-shadow:0 0 6px currentColor;pointer-events:none}
      [data-message-author-role=user] {background:linear-gradient(115deg,rgba(28,24,25,.84),rgba(18,20,31,.88))!important;border:1px solid rgba(255,220,65,.44)!important;border-right:2px solid #fcee0a!important;box-shadow:0 6px 18px rgba(0,0,0,.24),0 0 12px rgba(252,238,10,.08)!important;margin:14px 0 18px auto!important;max-width:min(94%,780px)!important}
      [data-message-author-role=user]:before {content:"YOU";color:#fcee0a;text-shadow:0 0 7px rgba(252,238,10,.55)}
      [data-message-author-role=assistant] {background:linear-gradient(125deg,rgba(12,29,38,.88),rgba(22,19,34,.91))!important;border:1px solid rgba(0,229,255,.38)!important;border-left:2px solid #00e5ff!important;box-shadow:0 6px 20px rgba(0,0,0,.25),0 0 12px rgba(0,229,255,.08)!important;margin:16px 0 20px!important}
      [data-message-author-role=assistant]:before {content:"NET";color:#00e5ff;text-shadow:0 0 7px rgba(0,229,255,.55)}
      [data-message-author-role=user] :where(p,span,div,li,strong,em,b,i),[data-message-author-role=assistant] :where(p,span,div,li,strong,em,b,i,blockquote,td,th) {color:#f4f5f8!important}
      [data-message-author-role] pre,pre {max-width:100%!important;overflow-x:auto!important;white-space:pre!important}
      [data-message-author-role] code,[data-message-author-role] pre,pre,code {background:rgba(7,11,19,.90)!important;color:#d8faff!important;border:1px solid rgba(0,229,255,.25)!important;border-radius:6px!important}
      form:has(textarea),[data-testid*=composer],[class*=composer] {background:rgba(9,13,23,.90)!important;border:1px solid rgba(0,229,255,.38)!important;border-radius:12px 3px 12px 3px!important;box-shadow:0 -5px 22px rgba(0,0,0,.28),0 0 12px rgba(0,229,255,.10)!important;backdrop-filter:blur(18px)!important}
      form:has(textarea) {padding:7px!important}
      textarea,[contenteditable=true] {color:#f5f7fa!important;-webkit-text-fill-color:#f5f7fa!important;caret-color:#fcee0a!important}
      textarea::placeholder,[contenteditable=true][data-placeholder] {color:#aab4c2!important;-webkit-text-fill-color:#aab4c2!important;opacity:1!important}
      .nc-neon-control {position:relative!important;display:inline-flex!important;flex:0 0 auto!important;align-items:center!important;justify-content:center!important;box-sizing:border-box!important;min-width:36px!important;min-height:36px!important;width:auto!important;height:36px!important;max-width:100%!important;padding:0 9px!important;overflow:hidden!important;white-space:nowrap!important;border:1px solid transparent!important;border-radius:8px 2px 8px 2px!important;background:rgba(255,255,255,.035)!important;color:#dce6ef!important;box-shadow:none!important;text-shadow:none!important;line-height:1!important;font-size:12px!important;transition:background-color .14s ease,color .14s ease,transform .14s ease!important}
      .nc-neon-control.nc-icon-only {width:36px!important;height:36px!important;min-width:36px!important;padding:0!important}
      .nc-neon-control svg {display:block!important;flex:0 0 auto!important;width:18px!important;height:18px!important;max-width:100%!important;max-height:100%!important;overflow:visible!important;filter:none!important}
      .nc-neon-control :where(span,div) {position:relative!important;z-index:1;max-width:100%!important;white-space:nowrap!important;overflow:hidden!important;text-overflow:ellipsis!important}
      .nc-neon-control.nc-attach {color:#00e5ff!important;background:rgba(0,229,255,.07)!important;border-color:rgba(0,229,255,.16)!important}
      .nc-neon-control.nc-voice {color:#ff4fd8!important;background:rgba(255,79,216,.07)!important;border-color:rgba(255,79,216,.16)!important}
      .nc-neon-control.nc-send {width:38px!important;height:38px!important;min-width:38px!important;padding:0!important;color:#101116!important;background:#fcee0a!important;border:1px solid #fcee0a!important;border-radius:9px 2px 9px 2px!important;box-shadow:0 0 12px rgba(252,238,10,.22)!important}
      .nc-neon-control.nc-send svg {filter:none!important}
      .nc-neon-control.nc-stop {color:#ff5577!important;background:rgba(255,85,119,.08)!important;border-color:rgba(255,85,119,.18)!important}
      .nc-neon-control:active {transform:scale(.94)!important;background-color:rgba(255,255,255,.12)!important}
      button:focus-visible,textarea:focus-visible,[contenteditable=true]:focus-visible {outline:2px solid var(--nc-yellow)!important;outline-offset:2px!important}
      ::selection {background:rgba(255,225,107,.38)!important;color:white!important}
      * {scrollbar-color:#5acbd6 transparent!important}
      @media(prefers-reduced-motion:reduce){*,*::before,*::after{animation:none!important;transition:none!important;scroll-behavior:auto!important}}
      `;
      const classify=()=>{
        document.querySelectorAll('button').forEach(b=>{
          const composer=b.closest('form,[data-testid*=composer],[class*=composer]');
          if(!composer)return;
          const label=((b.getAttribute('aria-label')||'')+' '+(b.getAttribute('title')||'')+' '+(b.innerText||'')).toLowerCase();
          b.classList.add('nc-neon-control');
          const visibleText=(b.innerText||'').trim();
          if(!visibleText && b.querySelector('svg')) b.classList.add('nc-icon-only');
          if(/attach|upload|file|image|photo|添加|附件|上传|照片|图片/.test(label)) b.classList.add('nc-attach');
          else if(/voice|microphone|dictation|语音|麦克风/.test(label)) b.classList.add('nc-voice');
          else if(/stop|停止|cancel|取消/.test(label)) b.classList.add('nc-stop');
          else if(/send|发送/.test(label)||b.matches('[data-testid*=send]')) b.classList.add('nc-send');
        });
      };
      const install=()=>{
        if(!document.documentElement)return;
        if(!document.getElementById('night-city-v4-style')){
          const s=document.createElement('style');s.id='night-city-v4-style';s.textContent=css;(document.head||document.documentElement).appendChild(s);
        }
        if(document.body&&!document.querySelector('.nc-world')){
          const world=document.createElement('div');world.className='nc-world';world.setAttribute('aria-hidden','true');
          document.body.insertBefore(world,document.body.firstChild);
        }
        classify();
      };
      let scheduled=false;
      const schedule=()=>{
        if(scheduled)return;
        scheduled=true;
        requestAnimationFrame(()=>{scheduled=false;install();});
      };
      install();
      new MutationObserver(schedule).observe(document,{childList:true,subtree:true,attributes:true,attributeFilter:['aria-label','title']});
    })();
    """#
}
