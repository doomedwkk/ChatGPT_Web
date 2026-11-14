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
          color-scheme:light;
          --nc-yellow:#bd8500; --nc-cyan:#007b8d; --nc-magenta:#a92f68;
          --nc-bg:#e9eef2; --nc-panel:#f9fbfc; --nc-panel-2:#dce6eb;
          --nc-text:#14212b; --nc-muted:#52616d; --nc-border:rgba(0,105,125,.30);
          --nc-user-bg:linear-gradient(125deg,#fff3c7 0%,#fffaf0 72%);
          --nc-ai-bg:linear-gradient(135deg,#fbfeff 0%,#e8f4f6 100%);
          --nc-composer:#f7fafb; --nc-shadow:rgba(15,38,52,.13);
          --nc-grid:rgba(0,104,121,.075); --nc-glow:rgba(0,126,145,.18);
        }
        @media (prefers-color-scheme:dark) {
          :root {
            color-scheme:dark;
            --nc-yellow:#ffd43b; --nc-cyan:#42dce8; --nc-magenta:#ff4f9a;
            --nc-bg:#070b11; --nc-panel:#101923; --nc-panel-2:#172633;
            --nc-text:#f2f7fa; --nc-muted:#b2c2cc; --nc-border:rgba(66,220,232,.34);
            --nc-user-bg:linear-gradient(125deg,rgba(67,49,10,.82),rgba(25,25,22,.98) 72%);
            --nc-ai-bg:linear-gradient(135deg,rgba(12,34,44,.98),rgba(11,20,30,.99));
            --nc-composer:#0d1721; --nc-shadow:rgba(0,0,0,.40);
            --nc-grid:rgba(66,220,232,.075); --nc-glow:rgba(66,220,232,.22);
          }
        }
        html,body { min-height:100%; background:var(--nc-bg)!important; color:var(--nc-text)!important; }
        html { color-scheme:light; }
        @media (prefers-color-scheme:dark) { html { color-scheme:dark; } }
        body {
          background-image:
            radial-gradient(ellipse at 12% 0%,rgba(169,47,104,.10),transparent 36%),
            radial-gradient(ellipse at 92% 18%,var(--nc-glow),transparent 34%),
            repeating-linear-gradient(0deg,transparent 0,transparent 31px,var(--nc-grid) 32px),
            repeating-linear-gradient(90deg,transparent 0,transparent 31px,var(--nc-grid) 32px)!important;
          font-family:-apple-system,BlinkMacSystemFont,"SF Pro Text",sans-serif!important;
        }
        body::before {
          content:""; position:fixed; inset:0; z-index:9997; pointer-events:none;
          opacity:.16;
          background:repeating-linear-gradient(to bottom,transparent 0,transparent 3px,rgba(90,170,180,.12) 4px);
        }
        body::after {
          content:""; position:fixed; top:0; left:0; right:0; height:2px; z-index:9998;
          pointer-events:none;
          background:linear-gradient(90deg,transparent,var(--nc-cyan) 22%,var(--nc-magenta) 52%,var(--nc-yellow) 78%,transparent);
          box-shadow:0 0 12px var(--nc-glow);
        }
        body :where(p,li,h1,h2,h3,h4,h5,h6,strong,em,b,i,label,small,blockquote,td,th,time,figcaption) {
          color:var(--nc-text)!important;
        }
        body :where(a) { color:var(--nc-cyan)!important; text-decoration-color:var(--nc-border)!important; }
        header,nav,[data-testid*=sidebar] {
          background:var(--nc-panel)!important; color:var(--nc-text)!important;
          border-color:var(--nc-border)!important;
        }
        main { background:transparent!important; }
        [data-message-author-role] {
          position:relative!important; isolation:isolate;
          padding:15px 16px 14px!important;
          transition:background-color .2s ease,border-color .2s ease,box-shadow .2s ease!important;
        }
        [data-message-author-role]::before {
          display:block; margin:0 0 9px;
          font:700 9px/1.2 ui-monospace,SFMono-Regular,Menlo,monospace;
          letter-spacing:1.7px; opacity:.82;
        }
        [data-message-author-role=user] {
          background:var(--nc-user-bg)!important; color:var(--nc-text)!important;
          border:1px solid rgba(189,133,0,.55)!important;
          border-left:1px solid rgba(189,133,0,.55)!important;
          border-right:4px solid var(--nc-yellow)!important;
          border-radius:14px 3px 14px 3px!important;
          margin:18px 0 20px auto!important;
          box-shadow:inset 0 1px 0 rgba(255,255,255,.18),0 8px 24px var(--nc-shadow)!important;
          max-width:min(94%,780px)!important;
        }
        [data-message-author-role=user]::before {
          content:"YOU  //  OUTGOING TRANSMISSION";
          color:var(--nc-yellow)!important; text-align:right;
        }
        [data-message-author-role=assistant] {
          background:var(--nc-ai-bg)!important; color:var(--nc-text)!important;
          border:1px solid var(--nc-border)!important;
          border-left:4px solid var(--nc-cyan)!important;
          border-radius:3px 14px 3px 14px!important;
          margin:20px 0 24px!important;
          box-shadow:inset 0 1px 0 rgba(255,255,255,.08),0 9px 26px var(--nc-shadow),0 0 18px var(--nc-glow)!important;
        }
        [data-message-author-role=assistant]::before {
          content:"NIGHT CITY AI  //  SECURE CHANNEL";
          color:var(--nc-cyan)!important;
        }
        [data-message-author-role=user] :where(p,span,div,li,strong,em,b,i),
        [data-message-author-role=assistant] :where(p,span,div,li,strong,em,b,i,blockquote,td,th) {
          color:var(--nc-text)!important;
        }
        [data-message-author-role=assistant] :where(pre,code) {
          background:var(--nc-panel-2)!important; border:1px solid var(--nc-border)!important;
          border-radius:6px!important;
        }
        [data-message-author-role=assistant] blockquote {
          border-left:3px solid var(--nc-magenta)!important;
          background:rgba(169,47,104,.075)!important; padding:9px 12px!important;
        }
        form:has(textarea),[data-testid*=composer],[class*=composer] {
          background:var(--nc-composer)!important; color:var(--nc-text)!important;
          border:1px solid var(--nc-border)!important;
          border-radius:7px 18px 7px 18px!important;
          box-shadow:0 -5px 28px var(--nc-shadow),0 0 0 1px rgba(0,126,145,.06),0 0 22px var(--nc-glow)!important;
          transition:border-color .2s ease,box-shadow .2s ease,background-color .2s ease!important;
        }
        form:has(textarea):focus-within,[data-testid*=composer]:focus-within {
          border-color:var(--nc-cyan)!important;
          box-shadow:0 0 0 2px var(--nc-glow),0 0 26px var(--nc-glow)!important;
        }
        textarea,[contenteditable=true] {
          color:var(--nc-text)!important; caret-color:var(--nc-yellow)!important;
          -webkit-text-fill-color:var(--nc-text)!important;
        }
        textarea::placeholder,[contenteditable=true][data-placeholder] {
          color:var(--nc-muted)!important; -webkit-text-fill-color:var(--nc-muted)!important; opacity:1!important;
        }
        [data-testid*=composer] button,[class*=composer] button {
          border:1px solid var(--nc-border)!important; border-radius:7px!important;
          transition:transform .14s ease,filter .14s ease,box-shadow .14s ease!important;
        }
        [data-testid*=composer] button:active,[class*=composer] button:active {
          transform:scale(.94)!important; filter:brightness(1.14)!important;
          box-shadow:0 0 15px var(--nc-glow)!important;
        }
        button[data-testid*=send],button[aria-label*=Send],button[aria-label*=发送] {
          background:var(--nc-yellow)!important; color:#171717!important;
          -webkit-text-fill-color:#171717!important; border:1px solid var(--nc-yellow)!important;
          border-radius:7px 13px 7px 13px!important;
          box-shadow:0 0 15px rgba(244,196,48,.30)!important;
        }
        button[data-testid*=send] svg,button[aria-label*=Send] svg,button[aria-label*=发送] svg {
          color:#171717!important; fill:currentColor!important;
        }
        pre,code {
          background-color:var(--nc-panel-2)!important; color:var(--nc-text)!important;
          border-color:var(--nc-border)!important;
        }
        ::placeholder { color:var(--nc-muted)!important; opacity:1!important; }
        ::selection { background:rgba(244,196,48,.38)!important; color:var(--nc-text)!important; }
        * { scrollbar-color:var(--nc-cyan) transparent!important; }
        @media (prefers-reduced-motion:reduce) {
          *,*::before,*::after { animation:none!important; transition:none!important; scroll-behavior:auto!important; }
        }
      
      const install=()=>{ if(!document.documentElement)return; let s=document.getElementById('night-city-terminal-theme'); if(!s){s=document.createElement('style');s.id='night-city-terminal-theme';s.textContent=css;(document.head||document.documentElement).appendChild(s);} };
      install();
      new MutationObserver(install).observe(document,{childList:true,subtree:true});
      if(window.matchMedia){const q=window.matchMedia('(prefers-color-scheme: dark)');const refresh=()=>{document.documentElement.style.colorScheme=q.matches?'dark':'light';install();};if(q.addEventListener)q.addEventListener('change',refresh);else if(q.addListener)q.addListener(refresh);refresh();}
    })();
    """#
}
