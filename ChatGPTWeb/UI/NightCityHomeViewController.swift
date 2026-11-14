import UIKit

final class NightCityHomeViewController: UIViewController {
    private let cyan = UIColor(red: 0.20, green: 0.88, blue: 1.00, alpha: 1)
    private let violet = UIColor(red: 0.48, green: 0.38, blue: 1.00, alpha: 1)
    private let warning = UIColor(red: 1.00, green: 0.82, blue: 0.20, alpha: 1)

    private let backgroundGradient = CAGradientLayer()
    private let gridLayer = CAShapeLayer()
    private let orbitOuter = CAShapeLayer()
    private let orbitInner = CAShapeLayer()
    private let coreGlow = UIView()

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildInterface()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
        gridLayer.frame = view.bounds
        gridLayer.path = makeGridPath(in: view.bounds).cgPath
        let center = CGPoint(x: view.bounds.midX, y: view.safeAreaInsets.top + view.bounds.height * 0.30)
        orbitOuter.path = UIBezierPath(ovalIn: CGRect(x: center.x - 77, y: center.y - 77, width: 154, height: 154)).cgPath
        orbitInner.path = UIBezierPath(ovalIn: CGRect(x: center.x - 61, y: center.y - 61, width: 122, height: 122)).cgPath
    }

    private func buildInterface() {
        view.backgroundColor = UIColor(red: 0.012, green: 0.020, blue: 0.052, alpha: 1)
        backgroundGradient.colors = [
            UIColor(red: 0.025, green: 0.045, blue: 0.105, alpha: 1).cgColor,
            UIColor(red: 0.035, green: 0.025, blue: 0.095, alpha: 1).cgColor,
            UIColor(red: 0.008, green: 0.016, blue: 0.040, alpha: 1).cgColor
        ]
        backgroundGradient.startPoint = CGPoint(x: 0.05, y: 0)
        backgroundGradient.endPoint = CGPoint(x: 0.95, y: 1)
        view.layer.insertSublayer(backgroundGradient, at: 0)

        gridLayer.strokeColor = cyan.withAlphaComponent(0.10).cgColor
        gridLayer.lineWidth = 0.6
        view.layer.addSublayer(gridLayer)

        configureOrbits()
        buildContent()
    }

    private func configureOrbits() {
        orbitOuter.fillColor = UIColor.clear.cgColor
        orbitOuter.strokeColor = cyan.withAlphaComponent(0.72).cgColor
        orbitOuter.lineWidth = 1.4
        orbitOuter.lineDashPattern = [3, 7]
        orbitOuter.shadowColor = cyan.cgColor
        orbitOuter.shadowRadius = 10
        orbitOuter.shadowOpacity = 0.7
        view.layer.addSublayer(orbitOuter)

        orbitInner.fillColor = UIColor.clear.cgColor
        orbitInner.strokeColor = violet.withAlphaComponent(0.8).cgColor
        orbitInner.lineWidth = 1.2
        orbitInner.lineDashPattern = [30, 9]
        view.layer.addSublayer(orbitInner)

        coreGlow.translatesAutoresizingMaskIntoConstraints = false
        coreGlow.backgroundColor = UIColor(red: 0.035, green: 0.12, blue: 0.22, alpha: 0.96)
        coreGlow.layer.cornerRadius = 43
        coreGlow.layer.borderWidth = 1.2
        coreGlow.layer.borderColor = cyan.withAlphaComponent(0.85).cgColor
        coreGlow.layer.shadowColor = cyan.cgColor
        coreGlow.layer.shadowRadius = 22
        coreGlow.layer.shadowOpacity = 0.75
        coreGlow.layer.shadowOffset = .zero

        let mark = UILabel()
        mark.translatesAutoresizingMaskIntoConstraints = false
        mark.text = "GPT"
        mark.font = .systemFont(ofSize: 25, weight: .heavy)
        mark.textColor = UIColor(red: 0.83, green: 0.98, blue: 1, alpha: 1)
        mark.textAlignment = .center
        coreGlow.addSubview(mark)
        view.addSubview(coreGlow)
        NSLayoutConstraint.activate([
            coreGlow.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coreGlow.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height * 0.30),
            coreGlow.widthAnchor.constraint(equalToConstant: 86),
            coreGlow.heightAnchor.constraint(equalToConstant: 86),
            mark.centerXAnchor.constraint(equalTo: coreGlow.centerXAnchor),
            mark.centerYAnchor.constraint(equalTo: coreGlow.centerYAnchor)
        ])

        guard !UIAccessibility.isReduceMotionEnabled else { return }
        let spin = CABasicAnimation(keyPath: "transform.rotation.z")
        spin.fromValue = 0
        spin.toValue = Double.pi * 2
        spin.duration = 24
        spin.repeatCount = .infinity
        orbitOuter.add(spin, forKey: "orbitSpin")

        let counterSpin = CABasicAnimation(keyPath: "transform.rotation.z")
        counterSpin.fromValue = 0
        counterSpin.toValue = -Double.pi * 2
        counterSpin.duration = 17
        counterSpin.repeatCount = .infinity
        orbitInner.add(counterSpin, forKey: "orbitCounterSpin")

        let pulse = CABasicAnimation(keyPath: "opacity")
        pulse.fromValue = 0.72
        pulse.toValue = 1
        pulse.duration = 1.8
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        coreGlow.layer.add(pulse, forKey: "corePulse")
    }

    private func buildContent() {
        let header = UIStackView()
        header.axis = .horizontal
        header.alignment = .center
        header.distribution = .equalSpacing
        header.translatesAutoresizingMaskIntoConstraints = false

        let brand = makeLabel("NIGHT CITY  /  AI TERMINAL", size: 10, weight: .bold, color: cyan)
        brand.font = .monospacedSystemFont(ofSize: 10, weight: .bold)
        let live = makeLabel("● SYSTEM ONLINE", size: 9, weight: .bold, color: warning)
        live.font = .monospacedSystemFont(ofSize: 9, weight: .bold)
        header.addArrangedSubview(brand)
        header.addArrangedSubview(live)
        view.addSubview(header)

        let title = makeLabel("GPT NIGHT CITY", size: 29, weight: .black, color: .white)
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.8

        let subtitle = makeLabel("YOUR GATEWAY TO THE NEXT INTELLIGENCE", size: 9, weight: .medium, color: cyan.withAlphaComponent(0.8))
        subtitle.font = .monospacedSystemFont(ofSize: 9, weight: .medium)
        subtitle.textAlignment = .center
        subtitle.numberOfLines = 2

        let systemCard = makePanel()
        let cardStack = UIStackView()
        cardStack.axis = .vertical
        cardStack.spacing = 12
        cardStack.translatesAutoresizingMaskIntoConstraints = false

        let cardHeader = makeLabel("NEURAL LINK STATUS", size: 10, weight: .bold, color: warning)
        cardHeader.font = .monospacedSystemFont(ofSize: 10, weight: .bold)
        let divider = UIView()
        divider.backgroundColor = cyan.withAlphaComponent(0.35)
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true

        let status1 = statusRow("CORE NETWORK", value: "CONNECTED")
        let status2 = statusRow("ENCRYPTION", value: "ACTIVE")
        let status3 = statusRow("INTERFACE", value: "READY")

        cardStack.addArrangedSubview(cardHeader)
        cardStack.addArrangedSubview(divider)
        cardStack.addArrangedSubview(status1)
        cardStack.addArrangedSubview(status2)
        cardStack.addArrangedSubview(status3)
        systemCard.addSubview(cardStack)
        NSLayoutConstraint.activate([
            cardStack.topAnchor.constraint(equalTo: systemCard.topAnchor, constant: 16),
            cardStack.bottomAnchor.constraint(equalTo: systemCard.bottomAnchor, constant: -16),
            cardStack.leadingAnchor.constraint(equalTo: systemCard.leadingAnchor, constant: 16),
            cardStack.trailingAnchor.constraint(equalTo: systemCard.trailingAnchor, constant: -16)
        ])

        let enterButton = UIButton(type: .system)
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.backgroundColor = warning
        enterButton.tintColor = UIColor(red: 0.04, green: 0.05, blue: 0.10, alpha: 1)
        enterButton.layer.cornerRadius = 8
        enterButton.layer.shadowColor = warning.cgColor
        enterButton.layer.shadowOpacity = 0.35
        enterButton.layer.shadowRadius = 14
        enterButton.layer.shadowOffset = .zero
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "ENTER CHATGPT"
        buttonConfig.image = UIImage(systemName: "arrow.up.right")
        buttonConfig.imagePlacement = .trailing
        buttonConfig.imagePadding = 12
        buttonConfig.baseBackgroundColor = warning
        buttonConfig.baseForegroundColor = UIColor(red: 0.04, green: 0.05, blue: 0.10, alpha: 1)
        buttonConfig.cornerStyle = .medium
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 22, bottom: 17, trailing: 22)
        enterButton.configuration = buttonConfig
        enterButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .heavy)
        enterButton.addTarget(self, action: #selector(enterChat), for: .touchUpInside)

        let footer = makeLabel("UNOFFICIAL WEB INTERFACE  •  iOS 16+", size: 8, weight: .medium, color: UIColor.white.withAlphaComponent(0.42))
        footer.font = .monospacedSystemFont(ofSize: 8, weight: .medium)
        footer.textAlignment = .center

        let content = UIStackView(arrangedSubviews: [title, subtitle, systemCard, enterButton, footer])
        content.axis = .vertical
        content.alignment = .fill
        content.spacing = 17
        content.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(content)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            content.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height * 0.49),
            content.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: view.bounds.height * 0.20),
            systemCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 142),
            enterButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 54)
        ])
    }

    private func makePanel() -> UIView {
        let panel = UIView()
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.backgroundColor = UIColor(red: 0.025, green: 0.075, blue: 0.13, alpha: 0.78)
        panel.layer.cornerRadius = 10
        panel.layer.borderWidth = 1
        panel.layer.borderColor = cyan.withAlphaComponent(0.32).cgColor
        panel.layer.shadowColor = violet.cgColor
        panel.layer.shadowOpacity = 0.16
        panel.layer.shadowRadius = 12
        panel.layer.shadowOffset = .zero
        return panel
    }

    private func statusRow(_ name: String, value: String) -> UIView {
        let row = UIStackView()
        row.axis = .horizontal
        row.alignment = .center
        row.distribution = .equalSpacing
        let left = makeLabel(name, size: 9, weight: .medium, color: UIColor.white.withAlphaComponent(0.62))
        left.font = .monospacedSystemFont(ofSize: 9, weight: .medium)
        let right = makeLabel("● " + value, size: 9, weight: .bold, color: cyan)
        right.font = .monospacedSystemFont(ofSize: 9, weight: .bold)
        row.addArrangedSubview(left)
        row.addArrangedSubview(right)
        return row
    }

    private func makeLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        return label
    }

    private func makeGridPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        stride(from: CGFloat(0), through: rect.width, by: 32).forEach { x in
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        stride(from: CGFloat(0), through: rect.height, by: 32).forEach { y in
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        return path
    }

    @objc private func enterChat() {
        let chat = WebViewController()
        navigationController?.pushViewController(chat, animated: true)
    }
}
