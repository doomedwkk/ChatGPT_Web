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
          color-scheme:dark;
          --nc-yellow:#ffd43b; --nc-cyan:#49e7f2; --nc-magenta:#ff4d9a;
          --nc-bg:#050910; --nc-panel:rgba(10,19,30,.94); --nc-panel2:#142433;
          --nc-text:#f3f7fa; --nc-muted:#a9bac6; --nc-border:rgba(73,231,242,.38);
          --nc-user:linear-gradient(125deg,rgba(72,53,9,.96),rgba(22,23,27,.98) 76%);
          --nc-ai:linear-gradient(135deg,rgba(9,30,42,.97),rgba(8,17,28,.98));
          --nc-glow:rgba(73,231,242,.22); --nc-shadow:rgba(0,0,0,.48);
        }
        html { color-scheme:dark!important; background:var(--nc-bg)!important; }
        html,body { min-height:100%; background-color:var(--nc-bg)!important; color:var(--nc-text)!important; }
        body {
          background-image:
            radial-gradient(ellipse at 15% 8%,rgba(255,77,154,.17),transparent 33%),
            radial-gradient(ellipse at 88% 18%,rgba(28,126,174,.20),transparent 38%),
            radial-gradient(ellipse at 50% 100%,rgba(255,190,40,.08),transparent 42%),
            linear-gradient(180deg,#090d18 0%,#07111d 54%,#050910 100%)!important;
          background-attachment:fixed!important;
          font-family:-apple-system,BlinkMacSystemFont,"SF Pro Text",sans-serif!important;
          color:var(--nc-text)!important;
        }
        .nc-cityscape {
          position:fixed; inset:0; z-index:0; overflow:hidden; pointer-events:none;
          background:
            radial-gradient(ellipse at 73% 54%,rgba(255,65,143,.16),transparent 23%),
            radial-gradient(ellipse at 23% 66%,rgba(35,211,235,.12),transparent 25%);
          contain:strict;
        }
        .nc-cityscape::before {
          content:""; position:absolute; left:-2%; right:-2%; bottom:0; height:43%;
          background:
            repeating-linear-gradient(90deg,transparent 0 10px,rgba(8,17,29,.98) 10px 49px,transparent 49px 57px,rgba(13,26,42,.98) 57px 105px,transparent 105px 116px),
            repeating-linear-gradient(0deg,transparent 0 17px,rgba(73,231,242,.13) 18px 19px,transparent 20px 29px),
            linear-gradient(180deg,rgba(11,24,39,.90),rgba(3,8,15,.98));
          background-size:auto,auto,auto;
          -webkit-mask-image:linear-gradient(to top,black 0%,black 48%,transparent 100%);
          mask-image:linear-gradient(to top,black 0%,black 48%,transparent 100%);
          opacity:.82;
        }
        .nc-cityscape::after {
          content:""; position:absolute; left:0; right:0; bottom:0; height:25%;
          background:repeating-linear-gradient(90deg,transparent 0 18px,rgba(255,212,59,.36) 19px 20px,transparent 21px 37px,rgba(73,231,242,.34) 38px 39px,transparent 40px 66px);
          -webkit-mask-image:linear-gradient(to top,rgba(0,0,0,.8),transparent 90%);
          mask-image:linear-gradient(to top,rgba(0,0,0,.8),transparent 90%);
          opacity:.46;
        }
        .nc-holo {
          position:absolute; border:1px solid rgba(73,231,242,.42);
          background:linear-gradient(135deg,rgba(13,38,55,.34),rgba(255,77,154,.08));
          box-shadow:0 0 22px rgba(73,231,242,.12),inset 0 0 18px rgba(73,231,242,.08);
          transform:skewY(-7deg); opacity:.54;
        }
        .nc-holo::before {
          content:attr(data-label); display:block; padding:8px 10px;
          color:rgba(73,231,242,.88); font:700 9px ui-monospace,Menlo,monospace;
          letter-spacing:2px; text-shadow:0 0 9px rgba(73,231,242,.6);
        }
        .nc-holo.one { top:22%; right:-5%; width:38%; height:86px; }
        .nc-holo.two { top:39%; left:-9%; width:31%; height:64px; border-color:rgba(255,77,154,.38); }
        .nc-holo.two::before { color:rgba(255,77,154,.86); }
        #root,#__next,body>div:not(.nc-cityscape) { position:relative; z-index:1; }
        main,[role=main],[data-testid*=conversation],#thread { background:transparent!important; }
        body::after {
          content:"";position:fixed;top:0;left:0;right:0;height:2px;z-index:9998;pointer-events:none;
          background:linear-gradient(90deg,transparent,var(--nc-cyan) 22%,var(--nc-magenta) 52%,var(--nc-yellow) 78%,transparent);
          box-shadow:0 0 13px var(--nc-glow);
        }
        body :where(p,li,h1,h2,h3,h4,h5,h6,strong,em,b,i,label,small,blockquote,td,th,time,figcaption) { color:var(--nc-text)!important; }
        body :where(a) { color:var(--nc-cyan)!important; text-decoration-color:var(--nc-border)!important; }
        header,nav,[data-testid*=sidebar] {
          background:rgba(8,16,27,.94)!important;color:var(--nc-text)!important;border-color:var(--nc-border)!important;
          backdrop-filter:blur(16px);
        }
        [data-message-author-role] {
          position:relative!important;isolation:isolate;padding:15px 16px 14px!important;
          transition:box-shadow .18s ease,border-color .18s ease!important;
        }
        [data-message-author-role]::before {
          display:block;margin:0 0 9px;font:700 9px/1.2 ui-monospace,SFMono-Regular,Menlo,monospace;
          letter-spacing:1.7px;opacity:.9;
        }
        [data-message-author-role=user] {
          background:var(--nc-user)!important;color:var(--nc-text)!important;
          border:1px solid rgba(255,212,59,.44)!important;border-right:4px solid var(--nc-yellow)!important;
          border-radius:13px 3px 13px 3px!important;margin:18px 0 20px auto!important;
          box-shadow:inset 0 1px 0 rgba(255,255,255,.08),0 8px 25px var(--nc-shadow)!important;
          max-width:min(94%,780px)!important;
        }
        [data-message-author-role=user]::before { content:"YOU  //  OUTGOING TRANSMISSION";color:var(--nc-yellow)!important;text-align:right; }
        [data-message-author-role=assistant] {
          background:var(--nc-ai)!important;color:var(--nc-text)!important;
          border:1px solid var(--nc-border)!important;border-left:4px solid var(--nc-cyan)!important;
          border-radius:3px 13px 3px 13px!important;margin:20px 0 24px!important;
          box-shadow:inset 0 1px 0 rgba(255,255,255,.05),0 9px 26px var(--nc-shadow),0 0 18px var(--nc-glow)!important;
        }
        [data-message-author-role=assistant]::before { content:"NIGHT CITY AI  //  SECURE CHANNEL";color:var(--nc-cyan)!important; }
        [data-message-author-role=user] :where(p,span,div,li,strong,em,b,i),
        [data-message-author-role=assistant] :where(p,span,div,li,strong,em,b,i,blockquote,td,th) { color:var(--nc-text)!important; }
        [data-message-author-role=assistant] :where(pre,code) {
          background:var(--nc-panel2)!important;border:1px solid var(--nc-border)!important;border-radius:6px!important;
        }
        [data-message-author-role=assistant] blockquote {
          border-left:3px solid var(--nc-magenta)!important;background:rgba(255,77,154,.08)!important;padding:9px 12px!important;
        }
        form:has(textarea),[data-testid*=composer],[class*=composer] {
          background:rgba(7,16,26,.97)!important;color:var(--nc-text)!important;
          border:1px solid var(--nc-border)!important;border-radius:7px 17px 7px 17px!important;
          box-shadow:0 -5px 28px var(--nc-shadow),0 0 22px var(--nc-glow)!important;
          backdrop-filter:blur(18px);
          transition:border-color .18s ease,box-shadow .18s ease!important;
        }
        form:has(textarea):focus-within,[data-testid*=composer]:focus-within {
          border-color:var(--nc-cyan)!important;box-shadow:0 0 0 2px var(--nc-glow),0 0 27px var(--nc-glow)!important;
        }
        textarea,[contenteditable=true] {
          color:var(--nc-text)!important;caret-color:var(--nc-yellow)!important;-webkit-text-fill-color:var(--nc-text)!important;
        }
        textarea::placeholder,[contenteditable=true][data-placeholder] {
          color:var(--nc-muted)!important;-webkit-text-fill-color:var(--nc-muted)!important;opacity:1!important;
        }
        [data-testid*=composer] button,[class*=composer] button {
          border:1px solid rgba(73,231,242,.25)!important;border-radius:7px!important;
          transition:transform .14s ease,filter .14s ease,box-shadow .14s ease!important;
        }
        [data-testid*=composer] button:active,[class*=composer] button:active {
          transform:scale(.94)!important;filter:brightness(1.14)!important;box-shadow:0 0 15px var(--nc-glow)!important;
        }
        button[data-testid*=send],button[aria-label*=Send],button[aria-label*=发送] {
          background:var(--nc-yellow)!important;color:#171717!important;-webkit-text-fill-color:#171717!important;
          border:1px solid var(--nc-yellow)!important;border-radius:7px 13px 7px 13px!important;
          box-shadow:0 0 15px rgba(244,196,48,.30)!important;
        }
        button[data-testid*=send] svg,button[aria-label*=Send] svg,button[aria-label*=发送] svg { color:#171717!important;fill:currentColor!important; }
        pre,code { background-color:var(--nc-panel2)!important;color:var(--nc-text)!important;border-color:var(--nc-border)!important; }
        ::placeholder { color:var(--nc-muted)!important;opacity:1!important; }
        ::selection { background:rgba(255,212,59,.38)!important;color:var(--nc-text)!important; }
        * { scrollbar-color:var(--nc-cyan) transparent!important; }
        @media (prefers-reduced-motion:reduce) { *,*::before,*::after { animation:none!important;transition:none!important;scroll-behavior:auto!important; } }
      `;
      const install=()=>{
        if(!document.documentElement)return;
        if(!document.getElementById('night-city-theme-style')){
          const style=document.createElement('style');style.id='night-city-theme-style';style.textContent=css;
          (document.head||document.documentElement).appendChild(style);
        }
        if(document.body&&!document.querySelector('.nc-cityscape')){
          const city=document.createElement('div');city.className='nc-cityscape';city.setAttribute('aria-hidden','true');
          const a=document.createElement('div');a.className='nc-holo one';a.setAttribute('data-label','NCN // CITY FEED');
          const b=document.createElement('div');b.className='nc-holo two';b.setAttribute('data-label','ARASAKA // NETWORK');
          city.append(a,b);document.body.insertBefore(city,document.body.firstChild);
        }
      };
      install();
      new MutationObserver(install).observe(document,{childList:true,subtree:true});
    })();
    """#
}
