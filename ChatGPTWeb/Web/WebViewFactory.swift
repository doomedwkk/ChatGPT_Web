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
        :root { --nc-yellow:#f2bd22; --nc-cyan:#087f91; --nc-magenta:#bd286c; }
        @media (prefers-color-scheme: dark) { :root { color-scheme:dark!important; --nc-bg:#090d13; --nc-panel:#111a24; --nc-panel-raised:#172330; --nc-text:#f3f5f7; --nc-muted:#c0cbd5; --nc-border:rgba(76,211,226,.34); --nc-user-bg:#282313; --nc-assistant-bg:#111d27; --nc-input-bg:#111923; } }
        @media (prefers-color-scheme: light) { :root { color-scheme:light!important; --nc-bg:#eef1f3; --nc-panel:#fff; --nc-panel-raised:#e2e8ec; --nc-text:#151a20; --nc-muted:#414d58; --nc-border:rgba(0,104,121,.34); --nc-user-bg:#fff4cf; --nc-assistant-bg:#e4f2f4; --nc-input-bg:#fff; } }
        html,body,#__next,main { background:var(--nc-bg)!important; color:var(--nc-text)!important; }
        body { background-image:linear-gradient(135deg,rgba(242,189,34,.035),transparent 36%),repeating-linear-gradient(0deg,transparent 0,transparent 31px,rgba(8,127,145,.035) 32px)!important; }
        body :where(p,span,div,li,h1,h2,h3,h4,h5,h6,strong,em,b,i,label,small,blockquote,td,th,time,figcaption,button,[role=button],code,pre,kbd,samp) { color:var(--nc-text)!important; }
        body :where(a) { color:var(--nc-cyan)!important; }
        ::placeholder { color:var(--nc-muted)!important; opacity:1!important; }
        header,nav,[data-testid*=sidebar] { background:var(--nc-panel)!important; color:var(--nc-text)!important; border-color:var(--nc-border)!important; }
        main { background-image:linear-gradient(180deg,rgba(189,40,108,.035),transparent 22%,rgba(8,127,145,.025))!important; }
        [data-message-author-role=user] { background:var(--nc-user-bg)!important; color:var(--nc-text)!important; border:1px solid rgba(242,189,34,.48)!important; border-left:4px solid var(--nc-yellow)!important; border-radius:3px 12px 12px 3px!important; margin:12px 0!important; padding-top:8px!important; padding-bottom:8px!important; }
        [data-message-author-role=assistant] { background:var(--nc-assistant-bg)!important; color:var(--nc-text)!important; border-left:3px solid var(--nc-cyan)!important; border-radius:2px 10px 10px 2px!important; margin:12px 0!important; padding-top:8px!important; padding-bottom:8px!important; }
        [data-message-author-role=user] *,[data-message-author-role=assistant] * { color:var(--nc-text)!important; }
        form,[data-testid*=composer],[class*=composer] { background:var(--nc-input-bg)!important; color:var(--nc-text)!important; border:1px solid var(--nc-border)!important; box-shadow:0 -8px 28px rgba(0,0,0,.12)!important; }
        textarea,[contenteditable=true] { color:var(--nc-text)!important; caret-color:var(--nc-yellow)!important; -webkit-text-fill-color:var(--nc-text)!important; }
        textarea::placeholder,[contenteditable=true][data-placeholder] { color:var(--nc-muted)!important; -webkit-text-fill-color:var(--nc-muted)!important; }
        button[data-testid*=send],button[aria-label*=Send],button[aria-label*=发送] { background:var(--nc-yellow)!important; color:#171717!important; -webkit-text-fill-color:#171717!important; border:1px solid rgba(242,189,34,.85)!important; border-radius:6px!important; }
        pre,code { background-color:var(--nc-panel-raised)!important; border-color:var(--nc-border)!important; }
        ::selection { background:rgba(242,189,34,.38)!important; }
        * { scrollbar-color:#667985 transparent!important; }
      `;
      const install=()=>{ if(!document.documentElement)return; let s=document.getElementById('night-city-terminal-theme'); if(!s){s=document.createElement('style');s.id='night-city-terminal-theme';s.textContent=css;(document.head||document.documentElement).appendChild(s);} };
      install();
      new MutationObserver(install).observe(document,{childList:true,subtree:true});
      if(window.matchMedia){const q=window.matchMedia('(prefers-color-scheme: dark)');const refresh=()=>{document.documentElement.style.colorScheme=q.matches?'dark':'light';install();};if(q.addEventListener)q.addEventListener('change',refresh);else if(q.addListener)q.addListener(refresh);refresh();}
    })();
    """#
}
