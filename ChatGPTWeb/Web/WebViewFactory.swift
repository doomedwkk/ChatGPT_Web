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
          color-scheme: light dark;
          --nc-yellow:#f4c430; --nc-cyan:#087f91; --nc-magenta:#bd286c;
          --nc-bg:#edf1f4; --nc-panel:#ffffff; --nc-panel-2:#e4ebef;
          --nc-text:#17212a; --nc-muted:#53616d; --nc-border:rgba(0,104,121,.28);
          --nc-user-bg:linear-gradient(110deg,#fff5d2,#fffaf0);
          --nc-ai-bg:linear-gradient(120deg,#ffffff,#eaf5f6);
          --nc-composer:#f8fafb; --nc-shadow:rgba(10,35,48,.12);
          --nc-grid:rgba(0,104,121,.055);
        }
        @media (prefers-color-scheme: dark) {
          :root {
            color-scheme:dark;
            --nc-bg:#080d13; --nc-panel:#101923; --nc-panel-2:#172431;
            --nc-text:#f1f5f7; --nc-muted:#aebdc8; --nc-border:rgba(67,220,232,.30);
            --nc-user-bg:linear-gradient(115deg,rgba(75,55,12,.58),rgba(30,27,19,.92));
            --nc-ai-bg:linear-gradient(120deg,rgba(13,34,43,.96),rgba(12,22,32,.98));
            --nc-composer:#0e1822; --nc-shadow:rgba(0,0,0,.34);
            --nc-grid:rgba(68,211,226,.055);
          }
        }
        html,body { min-height:100%; background:var(--nc-bg)!important; color:var(--nc-text)!important; }
        body {
          background-image:
            radial-gradient(ellipse at 50% -18%,rgba(189,40,108,.10),transparent 48%),
            linear-gradient(115deg,rgba(244,196,48,.035),transparent 38%),
            repeating-linear-gradient(0deg,transparent 0,transparent 35px,var(--nc-grid) 36px),
            repeating-linear-gradient(90deg,transparent 0,transparent 35px,var(--nc-grid) 36px)!important;
          font-family:-apple-system,BlinkMacSystemFont,"SF Pro Text",sans-serif!important;
        }
        body :where(p,li,h1,h2,h3,h4,h5,h6,strong,em,b,i,label,small,blockquote,td,th,time,figcaption) {
          color:var(--nc-text)!important;
        }
        body :where(a) { color:var(--nc-cyan)!important; text-decoration-color:rgba(8,127,145,.45)!important; }
        header,nav,[data-testid*=sidebar] {
          background:var(--nc-panel)!important; color:var(--nc-text)!important;
          border-color:var(--nc-border)!important;
        }
        main { background:transparent!important; }
        [data-message-author-role] {
          position:relative!important; isolation:isolate;
          transition:background-color .22s ease,border-color .22s ease,box-shadow .22s ease;
        }
        [data-message-author-role=user] {
          background:var(--nc-user-bg)!important; color:var(--nc-text)!important;
          border:1px solid rgba(244,196,48,.58)!important;
          border-left:4px solid var(--nc-yellow)!important;
          border-radius:3px 14px 14px 3px!important;
          margin:16px 0 18px auto!important; padding:13px 15px!important;
          box-shadow:inset 0 1px 0 rgba(255,255,255,.06),0 7px 22px var(--nc-shadow)!important;
          max-width:min(92%,760px)!important;
        }
        [data-message-author-role=assistant] {
          background:var(--nc-ai-bg)!important; color:var(--nc-text)!important;
          border:1px solid var(--nc-border)!important;
          border-left:3px solid var(--nc-cyan)!important;
          border-radius:2px 14px 14px 2px!important;
          margin:18px 0 22px!important; padding:14px 15px!important;
          box-shadow:inset 0 1px 0 rgba(255,255,255,.035),0 8px 24px var(--nc-shadow)!important;
        }
        [data-message-author-role=user] :where(p,span,div,li,strong,em,b,i) ,
        [data-message-author-role=assistant] :where(p,span,div,li,strong,em,b,i,blockquote,td,th) {
          color:var(--nc-text)!important;
        }
        [data-message-author-role=assistant] :where(pre,code) {
          background:var(--nc-panel-2)!important; border:1px solid var(--nc-border)!important;
          border-radius:7px!important;
        }
        [data-message-author-role=assistant] blockquote {
          border-left:3px solid var(--nc-magenta)!important;
          background:rgba(189,40,108,.055)!important; padding:8px 12px!important;
        }
        form:has(textarea),[data-testid*=composer],[class*=composer] {
          background:var(--nc-composer)!important; color:var(--nc-text)!important;
          border:1px solid var(--nc-border)!important; border-radius:14px!important;
          box-shadow:0 -5px 26px var(--nc-shadow),0 0 0 1px rgba(8,127,145,.045)!important;
          transition:border-color .2s ease,box-shadow .2s ease,background-color .2s ease!important;
        }
        form:has(textarea):focus-within,[data-testid*=composer]:focus-within {
          border-color:var(--nc-cyan)!important;
          box-shadow:0 0 0 2px rgba(8,127,145,.14),0 0 22px rgba(8,127,145,.13)!important;
        }
        textarea,[contenteditable=true] {
          color:var(--nc-text)!important; caret-color:var(--nc-yellow)!important;
          -webkit-text-fill-color:var(--nc-text)!important;
        }
        textarea::placeholder,[contenteditable=true][data-placeholder] {
          color:var(--nc-muted)!important; -webkit-text-fill-color:var(--nc-muted)!important; opacity:1!important;
        }
        button {
          transition:transform .14s ease,filter .14s ease,box-shadow .14s ease!important;
        }
        button:active,[role=button]:active {
          transform:scale(.96)!important; filter:brightness(1.12)!important;
        }
        button[data-testid*=send],button[aria-label*=Send],button[aria-label*=发送] {
          background:var(--nc-yellow)!important; color:#171717!important;
          -webkit-text-fill-color:#171717!important; border:1px solid rgba(244,196,48,.9)!important;
          border-radius:8px!important; box-shadow:0 0 13px rgba(244,196,48,.22)!important;
        }
        button[data-testid*=send] svg,button[aria-label*=Send] svg,button[aria-label*=发送] svg {
          color:#171717!important; fill:currentColor!important;
        }
        [data-testid*=composer] button:not([data-testid*=send]) {
          border-radius:8px!important;
        }
        pre,code {
          background-color:var(--nc-panel-2)!important; color:var(--nc-text)!important;
          border-color:var(--nc-border)!important;
        }
        ::placeholder { color:var(--nc-muted)!important; opacity:1!important; }
        ::selection { background:rgba(244,196,48,.38)!important; color:var(--nc-text)!important; }
        * { scrollbar-color:#647986 transparent!important; }
        @media (prefers-reduced-motion:reduce) {
          *,*::before,*::after { animation:none!important; transition:none!important; scroll-behavior:auto!important; }
        }

      `;
      const install=()=>{ if(!document.documentElement)return; let s=document.getElementById('night-city-terminal-theme'); if(!s){s=document.createElement('style');s.id='night-city-terminal-theme';s.textContent=css;(document.head||document.documentElement).appendChild(s);} };
      install();
      new MutationObserver(install).observe(document,{childList:true,subtree:true});
      if(window.matchMedia){const q=window.matchMedia('(prefers-color-scheme: dark)');const refresh=()=>{document.documentElement.style.colorScheme=q.matches?'dark':'light';install();};if(q.addEventListener)q.addEventListener('change',refresh);else if(q.addListener)q.addListener(refresh);refresh();}
    })();
    """#
}
