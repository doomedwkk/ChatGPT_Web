import WebKit

enum WebViewFactory {
    static func makeConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        // Use the persistent website store so sign-in survives app relaunches.
        configuration.websiteDataStore = .default()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        let preferences = WKPreferences()
        preferences.isFraudulentWebsiteWarningEnabled = true
        configuration.preferences = preferences

        // Presentation-only CSS; ChatGPT's own DOM and interaction logic remain intact.
        let theme = WKUserScript(
            source: Self.nightCityTheme,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
        configuration.userContentController.addUserScript(theme)
        return configuration
    }

    static func makeWebView(configuration: WKWebViewConfiguration? = nil) -> WKWebView {
        let webView = WKWebView(
            frame: .zero,
            configuration: configuration ?? makeConfiguration()
        )
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        webView.scrollView.keyboardDismissMode = .interactive
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        return webView
    }

    private static let nightCityTheme = #"""
    (() => {
      const css = ":root{color-scheme:dark!important;--nc-yellow:#f8c62d;--nc-cyan:#39d9ec;--nc-magenta:#f04491;--nc-bg:#080b10;--nc-panel:#101720}\nhtml,body,body main,#__next{background:var(--nc-bg)!important;color:#e9edf2!important}\nheader,nav,[data-testid*='sidebar']{background:rgba(8,11,16,.97)!important;border-color:rgba(57,217,236,.18)!important}\nmain{background-image:linear-gradient(180deg,rgba(240,68,145,.035),transparent 24%,rgba(57,217,236,.025))!important}\n[data-message-author-role='user']{background:linear-gradient(110deg,rgba(248,198,45,.105),rgba(248,198,45,.035))!important;border:1px solid rgba(248,198,45,.30)!important;border-left:3px solid var(--nc-yellow)!important;border-radius:4px 12px 12px 4px!important;margin-top:12px!important;margin-bottom:12px!important}\n[data-message-author-role='assistant']{background:linear-gradient(110deg,rgba(57,217,236,.055),rgba(16,23,32,.30))!important;border-left:2px solid rgba(57,217,236,.72)!important;border-radius:2px 10px 10px 2px!important;margin-top:12px!important;margin-bottom:12px!important}\nform,[data-testid*='composer'],[class*='composer']{background:rgba(12,18,25,.97)!important;border-color:rgba(57,217,236,.35)!important;box-shadow:0 -8px 30px rgba(0,0,0,.28)!important}\ntextarea,[contenteditable='true']{color:#f2f4f7!important;caret-color:var(--nc-yellow)!important}\ntextarea::placeholder,[contenteditable='true'][data-placeholder]{color:rgba(215,225,235,.48)!important}\nbutton{accent-color:var(--nc-yellow)!important}\nbutton[data-testid*='send'],button[aria-label*='Send'],button[aria-label*='发送']{background:var(--nc-yellow)!important;color:#101318!important;border:1px solid rgba(255,230,150,.7)!important;border-radius:6px!important}\na{color:#65ddec!important}::selection{background:rgba(248,198,45,.32)!important}*{scrollbar-color:#344653 #090d13!important}";
      const install = () => {
        if (!document.documentElement) return;
        let style = document.getElementById('night-city-terminal-theme');
        if (!style) {
          style = document.createElement('style');
          style.id = 'night-city-terminal-theme';
          style.textContent = css;
          (document.head || document.documentElement).appendChild(style);
        }
      };
      install();
      new MutationObserver(install).observe(document, {childList: true, subtree: true});
    })();
    """#
}
