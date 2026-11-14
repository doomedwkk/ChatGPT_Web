import UIKit
import WebKit

final class WebViewController: UIViewController {
    private static let homeURL = URL(string: "https://chatgpt.com/")!

    private let webView = WebViewFactory.makeWebView()
    private let errorView = WebErrorView()
    private let launchOverlay = FuturisticLaunchOverlay()
    private var progressObservation: NSKeyValueObservation?
    private var loadingObservation: NSKeyValueObservation?
    private lazy var navigationCoordinator = NavigationCoordinator(
        presentingViewController: self,
        webView: webView,
        errorView: errorView
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        observeInitialPageLoad()
        navigationCoordinator.start()
        loadHomePage()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        launchOverlay.isVisible ? .lightContent :
            (traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    private func configureView() {
        view.backgroundColor = .systemBackground

        webView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        launchOverlay.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        view.addSubview(errorView)
        view.addSubview(launchOverlay)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorView.topAnchor.constraint(equalTo: webView.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: webView.bottomAnchor),
            launchOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            launchOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            launchOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            launchOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        errorView.isHidden = true
        errorView.onRetry = { [weak self] in
            self?.navigationCoordinator.retryAfterFailure()
        }

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPage(_:)), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControl
    }

    private func observeInitialPageLoad() {
        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            DispatchQueue.main.async {
                guard let self, self.launchOverlay.isVisible else { return }
                self.launchOverlay.setProgress(webView.estimatedProgress)
            }
        }

        loadingObservation = webView.observe(\.isLoading, options: [.new]) { [weak self] webView, _ in
            guard !webView.isLoading else { return }
            DispatchQueue.main.async {
                guard let self, self.launchOverlay.isVisible else { return }
                self.launchOverlay.finish()
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }

    private func loadHomePage() {
        var request = URLRequest(url: Self.homeURL)
        // 启动时直接复用已有页面缓存；下拉刷新仍会主动向服务器校验更新。
        request.cachePolicy = .returnCacheDataElseLoad
        request.timeoutInterval = 30.0
        webView.load(request)
    }

    @objc private func refreshPage(_ sender: UIRefreshControl) {
        webView.reload()
    }
}

// MARK: - Futuristic first-load overlay

private final class FuturisticLaunchOverlay: UIView {
    private let backgroundGradient = CAGradientLayer()
    private let outerRing = CAShapeLayer()
    private let innerRing = CAShapeLayer()
    private let progressTrack = CALayer()
    private let progressFill = CAGradientLayer()
    private let scanLine = CALayer()
    private let progressLabel = UILabel()
    private let statusLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let logoContainer = UIView()
    private let logoLabel = UILabel()
    private var progressWidthConstraint: NSLayoutConstraint!
    private var startedAt = Date()
    private(set) var isVisible = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradient.frame = bounds
        let center = CGPoint(x: logoContainer.bounds.midX, y: logoContainer.bounds.midY)
        let outerRect = CGRect(x: center.x - 61, y: center.y - 61, width: 122, height: 122)
        let innerRect = CGRect(x: center.x - 49, y: center.y - 49, width: 98, height: 98)
        outerRing.path = UIBezierPath(ovalIn: outerRect).cgPath
        innerRing.path = UIBezierPath(ovalIn: innerRect).cgPath
    }

    private func configureAppearance() {
        backgroundColor = UIColor(red: 0.018, green: 0.035, blue: 0.085, alpha: 1)

        backgroundGradient.colors = [
            UIColor(red: 0.015, green: 0.025, blue: 0.070, alpha: 1).cgColor,
            UIColor(red: 0.025, green: 0.075, blue: 0.155, alpha: 1).cgColor,
            UIColor(red: 0.010, green: 0.020, blue: 0.060, alpha: 1).cgColor
        ]
        backgroundGradient.startPoint = CGPoint(x: 0.1, y: 0)
        backgroundGradient.endPoint = CGPoint(x: 0.9, y: 1)
        layer.insertSublayer(backgroundGradient, at: 0)

        outerRing.fillColor = UIColor.clear.cgColor
        outerRing.strokeColor = UIColor(red: 0.12, green: 0.82, blue: 1, alpha: 0.9).cgColor
        outerRing.lineWidth = 2
        outerRing.lineDashPattern = [3, 7]
        outerRing.shadowColor = UIColor.cyan.cgColor
        outerRing.shadowRadius = 12
        outerRing.shadowOpacity = 0.8
        outerRing.shadowOffset = .zero
        layer.addSublayer(outerRing)

        innerRing.fillColor = UIColor.clear.cgColor
        innerRing.strokeColor = UIColor(red: 0.34, green: 0.55, blue: 1, alpha: 0.65).cgColor
        innerRing.lineWidth = 1.5
        innerRing.lineDashPattern = [42, 12]
        layer.addSublayer(innerRing)

        logoContainer.translatesAutoresizingMaskIntoConstraints = false
        logoContainer.backgroundColor = UIColor(red: 0.04, green: 0.12, blue: 0.24, alpha: 0.9)
        logoContainer.layer.cornerRadius = 43
        logoContainer.layer.borderWidth = 1
        logoContainer.layer.borderColor = UIColor(red: 0.24, green: 0.82, blue: 1, alpha: 0.8).cgColor
        logoContainer.layer.shadowColor = UIColor.cyan.cgColor
        logoContainer.layer.shadowOpacity = 0.55
        logoContainer.layer.shadowRadius = 24
        logoContainer.layer.shadowOffset = .zero

        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.text = "GPT"
        logoLabel.font = .systemFont(ofSize: 25, weight: .bold, design: .rounded)
        logoLabel.textColor = UIColor(red: 0.72, green: 0.96, blue: 1, alpha: 1)
        logoLabel.textAlignment = .center
        logoContainer.addSubview(logoLabel)

        titleLabel.text = "CHATGPT WEB"
        titleLabel.font = .systemFont(ofSize: 19, weight: .semibold, design: .rounded)
        titleLabel.textColor = UIColor(red: 0.88, green: 0.96, blue: 1, alpha: 1)
        titleLabel.textAlignment = .center
        titleLabel.letterSpacing(3)

        subtitleLabel.text = "YOUR AI INTERFACE"
        subtitleLabel.font = .monospacedSystemFont(ofSize: 10, weight: .medium)
        subtitleLabel.textColor = UIColor(red: 0.37, green: 0.69, blue: 0.86, alpha: 1)
        subtitleLabel.textAlignment = .center
        subtitleLabel.letterSpacing(2)

        statusLabel.text = "ESTABLISHING SECURE CONNECTION"
        statusLabel.font = .monospacedSystemFont(ofSize: 10, weight: .medium)
        statusLabel.textColor = UIColor(red: 0.42, green: 0.83, blue: 0.98, alpha: 1)
        statusLabel.textAlignment = .center
        statusLabel.letterSpacing(1)

        progressLabel.text = "0%"
        progressLabel.font = .monospacedDigitSystemFont(ofSize: 12, weight: .semibold)
        progressLabel.textColor = .white
        progressLabel.textAlignment = .right

        let track = UIView()
        track.translatesAutoresizingMaskIntoConstraints = false
        track.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        track.layer.cornerRadius = 3
        track.clipsToBounds = true
        progressTrack.backgroundColor = UIColor.clear.cgColor
        track.layer.addSublayer(progressFill)
        progressFill.colors = [
            UIColor(red: 0.10, green: 0.90, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.30, green: 0.48, blue: 1, alpha: 1).cgColor
        ]
        progressFill.startPoint = CGPoint(x: 0, y: 0.5)
        progressFill.endPoint = CGPoint(x: 1, y: 0.5)
        progressFill.shadowColor = UIColor.cyan.cgColor
        progressFill.shadowRadius = 8
        progressFill.shadowOpacity = 0.8
        progressFill.shadowOffset = .zero
        track.layer.addSublayer(progressFill)

        scanLine.backgroundColor = UIColor.white.withAlphaComponent(0.65).cgColor
        scanLine.shadowColor = UIColor.cyan.cgColor
        scanLine.shadowRadius = 5
        scanLine.shadowOpacity = 1
        progressFill.addSublayer(scanLine)

        let stack = UIStackView(arrangedSubviews: [
            titleLabel, subtitleLabel, statusLabel, track, progressLabel
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 13

        addSubview(logoContainer)
        addSubview(stack)

        NSLayoutConstraint.activate([
            logoContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoContainer.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -70),
            logoContainer.widthAnchor.constraint(equalToConstant: 86),
            logoContainer.heightAnchor.constraint(equalToConstant: 86),
            logoLabel.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.topAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: 48),
            stack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.68),
            track.heightAnchor.constraint(equalToConstant: 6),
            progressLabel.heightAnchor.constraint(equalToConstant: 16)
        ])

        progressWidthConstraint = progressFill.widthAnchor.constraint(equalToConstant: 0)
        progressWidthConstraint.isActive = false
        track.layoutIfNeeded()
        progressFill.frame = CGRect(x: 0, y: 0, width: 0, height: 6)
        scanLine.frame = CGRect(x: 0, y: 0, width: 3, height: 6)
        animateRings()
        animateScanLine()
    }

    private func animateRings() {
        let outer = CABasicAnimation(keyPath: "transform.rotation.z")
        outer.fromValue = 0
        outer.toValue = Double.pi * 2
        outer.duration = 18
        outer.repeatCount = .infinity
        outerRing.add(outer, forKey: "outerRotation")

        let inner = CABasicAnimation(keyPath: "transform.rotation.z")
        inner.fromValue = 0
        inner.toValue = -Double.pi * 2
        inner.duration = 12
        inner.repeatCount = .infinity
        innerRing.add(inner, forKey: "innerRotation")

        let pulse = CABasicAnimation(keyPath: "opacity")
        pulse.fromValue = 0.65
        pulse.toValue = 1
        pulse.duration = 1.2
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        logoContainer.layer.add(pulse, forKey: "logoPulse")
    }

    private func animateScanLine() {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = 0
        animation.toValue = 220
        animation.duration = 1.4
        animation.repeatCount = .infinity
        scanLine.add(animation, forKey: "scan")
    }

    func setProgress(_ value: Double) {
        let progress = min(max(value, 0.04), 0.94)
        let percent = Int(progress * 100)
        progressLabel.text = "\(percent)%"
        let width = bounds.width * 0.68 * progress
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.18)
        progressFill.frame = CGRect(x: 0, y: 0, width: width, height: 6)
        CATransaction.commit()
    }

    func finish() {
        guard isVisible else { return }
        let remaining = max(0, 0.85 - Date().timeIntervalSince(startedAt))
        DispatchQueue.main.asyncAfter(deadline: .now() + remaining) { [weak self] in
            guard let self, self.isVisible else { return }
            self.progressLabel.text = "100%"
            self.statusLabel.text = "CONNECTION READY"
            self.progressFill.frame.size.width = self.bounds.width * 0.68
            UIView.animate(withDuration: 0.35, delay: 0.18, options: .curveEaseOut) {
                self.alpha = 0
            } completion: { _ in
                self.isVisible = false
                self.isHidden = true
                self.removeFromSuperview()
            }
        }
    }
}

private extension UILabel {
    func letterSpacing(_ value: CGFloat) {
        guard let text else { return }
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttribute(.kern, value: value, range: NSRange(location: 0, length: attributed.length))
        attributedText = attributed
    }
}
