import UIKit

final class NightCityHomeViewController: UIViewController {
    private let yellow = UIColor(red: 1.00, green: 0.78, blue: 0.12, alpha: 1)
    private let cyan = UIColor(red: 0.16, green: 0.86, blue: 0.96, alpha: 1)
    private let magenta = UIColor(red: 0.96, green: 0.18, blue: 0.58, alpha: 1)
    private let skyline = CAShapeLayer()
    private let distantSkyline = CAShapeLayer()
    private let grid = CAShapeLayer()
    private let scanline = CALayer()
    private let backgroundGradient = CAGradientLayer()
    private let horizonGlow = CAGradientLayer()
    private let windowLights = CAShapeLayer()
    private let billboard = CAShapeLayer()
    private let billboardLabel = CATextLayer()

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildScene()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
        horizonGlow.frame = CGRect(x: 0, y: view.bounds.height * 0.43, width: view.bounds.width, height: view.bounds.height * 0.38)
        skyline.frame = view.bounds
        windowLights.frame = view.bounds
        windowLights.path = windowPath(in: view.bounds).cgPath
        billboard.frame = view.bounds
        let boardRect = CGRect(x: view.bounds.width * 0.57, y: view.bounds.height * 0.29, width: view.bounds.width * 0.37, height: 66)
        billboard.path = UIBezierPath(roundedRect: boardRect, cornerRadius: 4).cgPath
        billboardLabel.frame = boardRect.insetBy(dx: 8, dy: 20)
        skyline.path = skylinePath(in: view.bounds, seed: 19).cgPath
        distantSkyline.frame = view.bounds
        distantSkyline.path = skylinePath(in: view.bounds, seed: 7).cgPath
        grid.frame = view.bounds
        grid.path = gridPath(in: view.bounds).cgPath
    }

    private func buildScene() {
        view.backgroundColor = UIColor(red: 0.018, green: 0.020, blue: 0.030, alpha: 1)
        backgroundGradient.colors = [
            UIColor(red: 0.10, green: 0.035, blue: 0.075, alpha: 1).cgColor,
            UIColor(red: 0.025, green: 0.035, blue: 0.055, alpha: 1).cgColor,
            UIColor(red: 0.008, green: 0.012, blue: 0.020, alpha: 1).cgColor
        ]
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0)
        backgroundGradient.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(backgroundGradient, at: 0)

        horizonGlow.colors = [
            magenta.withAlphaComponent(0.20).cgColor,
            cyan.withAlphaComponent(0.06).cgColor,
            UIColor.clear.cgColor
        ]
        horizonGlow.startPoint = CGPoint(x: 0.5, y: 0)
        horizonGlow.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.addSublayer(horizonGlow)

        distantSkyline.fillColor = UIColor(red: 0.10, green: 0.13, blue: 0.19, alpha: 0.55).cgColor
        distantSkyline.strokeColor = cyan.withAlphaComponent(0.18).cgColor
        distantSkyline.lineWidth = 1
        view.layer.addSublayer(distantSkyline)
        skyline.fillColor = UIColor(red: 0.018, green: 0.025, blue: 0.040, alpha: 0.96).cgColor
        skyline.strokeColor = magenta.withAlphaComponent(0.34).cgColor
        skyline.lineWidth = 1
        view.layer.addSublayer(skyline)

        windowLights.fillColor = UIColor.clear.cgColor
        windowLights.strokeColor = yellow.withAlphaComponent(0.46).cgColor
        windowLights.lineWidth = 2
        view.layer.addSublayer(windowLights)

        billboard.fillColor = UIColor(red: 0.02, green: 0.09, blue: 0.13, alpha: 0.72).cgColor
        billboard.strokeColor = cyan.withAlphaComponent(0.78).cgColor
        billboard.lineWidth = 1.2
        billboard.shadowColor = cyan.cgColor
        billboard.shadowRadius = 13
        billboard.shadowOpacity = 0.55
        billboard.shadowOffset = .zero
        view.layer.addSublayer(billboard)
        billboardLabel.string = "NIGHT CITY  //  LIVE FEED"
        billboardLabel.font = UIFont.monospacedSystemFont(ofSize: 9, weight: .bold)
        billboardLabel.fontSize = 9
        billboardLabel.foregroundColor = cyan.cgColor
        billboardLabel.alignmentMode = .center
        billboardLabel.contentsScale = UIScreen.main.scale
        billboard.addSublayer(billboardLabel)

        grid.strokeColor = cyan.withAlphaComponent(0.07).cgColor
        grid.lineWidth = 0.5
        view.layer.addSublayer(grid)

        scanline.backgroundColor = cyan.withAlphaComponent(0.30).cgColor
        scanline.shadowColor = cyan.cgColor
        scanline.shadowRadius = 7
        scanline.shadowOpacity = 0.8
        view.layer.addSublayer(scanline)
        if !UIAccessibility.isReduceMotionEnabled {
            let sweep = CABasicAnimation(keyPath: "position.y")
            sweep.fromValue = -2
            sweep.toValue = UIScreen.main.bounds.height
            sweep.duration = 7
            sweep.repeatCount = .infinity
            scanline.add(sweep, forKey: "cityScan")
        }
        buildOverlay()
    }

    private func buildOverlay() {
        let top = UIStackView()
        top.axis = .horizontal
        top.distribution = .equalSpacing
        top.translatesAutoresizingMaskIntoConstraints = false
        top.addArrangedSubview(label("NC-07  //  NIGHT CITY", size: 10, color: yellow, bold: true))
        top.addArrangedSubview(label("NCN  •  LIVE", size: 9, color: cyan, bold: true))
        view.addSubview(top)

        let warning = label("UNAUTHORIZED ACCESS IS A CRIME", size: 9, color: yellow, bold: true)
        warning.font = .monospacedSystemFont(ofSize: 9, weight: .bold)
        warning.textAlignment = .center
        warning.backgroundColor = yellow.withAlphaComponent(0.10)
        warning.layer.borderColor = yellow.withAlphaComponent(0.55).cgColor
        warning.layer.borderWidth = 1
        warning.layer.cornerRadius = 4
        warning.clipsToBounds = true

        let kicker = label("WELCOME TO THE CITY OF DREAMS", size: 9, color: cyan, bold: true)
        kicker.textAlignment = .center
        kicker.font = .monospacedSystemFont(ofSize: 9, weight: .bold)
        let title = label("NIGHT CITY", size: 38, color: .white, bold: true)
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.75
        title.layer.shadowColor = magenta.cgColor
        title.layer.shadowRadius = 16
        title.layer.shadowOpacity = 0.75
        title.layer.shadowOffset = .zero
        let subtitle = label("NETRUNNER ACCESS TERMINAL", size: 10, color: yellow, bold: true)
        subtitle.textAlignment = .center
        subtitle.font = .monospacedSystemFont(ofSize: 10, weight: .bold)

        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor(red: 0.025, green: 0.045, blue: 0.065, alpha: 0.92)
        card.layer.borderWidth = 1
        card.layer.borderColor = cyan.withAlphaComponent(0.45).cgColor
        card.layer.cornerRadius = 5
        card.layer.shadowColor = cyan.cgColor
        card.layer.shadowRadius = 14
        card.layer.shadowOpacity = 0.18
        card.layer.shadowOffset = .zero
        let cardStack = UIStackView()
        cardStack.axis = .vertical
        cardStack.spacing = 11
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        let cardTitle = label("/// LOCAL NETWORK DIAGNOSTICS", size: 9, color: yellow, bold: true)
        cardTitle.font = .monospacedSystemFont(ofSize: 9, weight: .bold)
        cardStack.addArrangedSubview(cardTitle)
        cardStack.addArrangedSubview(rule())
        cardStack.addArrangedSubview(statusRow("NEURAL LINK", "ESTABLISHED"))
        cardStack.addArrangedSubview(statusRow("ICE DETECTION", "BYPASSED"))
        cardStack.addArrangedSubview(statusRow("DAEMON", "STANDING BY"))
        card.addSubview(cardStack)
        NSLayoutConstraint.activate([
            cardStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 15),
            cardStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -15),
            cardStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 15),
            cardStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -15)
        ])

        let enter = UIButton(type: .system)
        enter.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.title = "JACK IN  //  OPEN TERMINAL"
        config.baseBackgroundColor = yellow
        config.baseForegroundColor = UIColor(red: 0.035, green: 0.035, blue: 0.045, alpha: 1)
        config.cornerStyle = .small
        config.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 16, bottom: 17, trailing: 16)
        enter.configuration = config
        enter.titleLabel?.font = .monospacedSystemFont(ofSize: 12, weight: .black)
        enter.layer.shadowColor = yellow.cgColor
        enter.layer.shadowOpacity = 0.38
        enter.layer.shadowRadius = 13
        enter.layer.shadowOffset = .zero
        enter.addTarget(self, action: #selector(enterChat), for: .touchUpInside)

        let footer = label("NIGHT CITY NETWORK  //  SECURE CHANNEL", size: 8, color: UIColor.white.withAlphaComponent(0.48), bold: false)
        footer.font = .monospacedSystemFont(ofSize: 8, weight: .medium)
        footer.textAlignment = .center
        let content = UIStackView(arrangedSubviews: [warning, kicker, title, subtitle, card, enter, footer])
        content.axis = .vertical
        content.alignment = .fill
        content.spacing = 14
        content.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(content)

        NSLayoutConstraint.activate([
            top.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            top.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            top.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            content.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 75),
            warning.heightAnchor.constraint(equalToConstant: 28),
            card.heightAnchor.constraint(greaterThanOrEqualToConstant: 142),
            enter.heightAnchor.constraint(equalToConstant: 54)
        ])
    }

    private func statusRow(_ key: String, _ value: String) -> UIView {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .equalSpacing
        let name = label(key, size: 9, color: UIColor.white.withAlphaComponent(0.62), bold: false)
        let state = label("● " + value, size: 9, color: cyan, bold: true)
        name.font = .monospacedSystemFont(ofSize: 9, weight: .medium)
        state.font = .monospacedSystemFont(ofSize: 9, weight: .bold)
        row.addArrangedSubview(name)
        row.addArrangedSubview(state)
        return row
    }

    private func rule() -> UIView {
        let line = UIView()
        line.backgroundColor = cyan.withAlphaComponent(0.35)
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return line
    }

    private func label(_ text: String, size: CGFloat, color: UIColor, bold: Bool) -> UILabel {
        let item = UILabel()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.text = text
        item.textColor = color
        item.font = .systemFont(ofSize: size, weight: bold ? .bold : .regular)
        return item
    }

    private func windowPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        var column = 0
        stride(from: CGFloat(8), through: rect.width, by: 19).forEach { x in
            stride(from: rect.height * 0.60, through: rect.height - 24, by: 24).forEach { y in
                if (column * 7 + Int(y / 24)) % 4 != 0 {
                    path.move(to: CGPoint(x: x, y: y))
                    path.addLine(to: CGPoint(x: x + 5, y: y))
                }
            }
            column += 1
        }
        return path
    }

    private func gridPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        stride(from: CGFloat(0), through: rect.width, by: 30).forEach { x in
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        stride(from: CGFloat(0), through: rect.height, by: 30).forEach { y in
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        return path
    }

    private func skylinePath(in rect: CGRect, seed: Int) -> UIBezierPath {
        let path = UIBezierPath()
        let baseY = rect.height * 0.62
        let widths: [CGFloat] = [0.10, 0.13, 0.08, 0.16, 0.11, 0.14, 0.09, 0.17, 0.12]
        var x: CGFloat = -12
        var index = seed
        while x < rect.width + 30 {
            let w = rect.width * widths[index % widths.count]
            let h = rect.height * CGFloat(0.10 + Double((index * 17) % 23) / 100.0)
            let building = CGRect(x: x, y: baseY - h, width: w, height: rect.height - baseY + h + 30)
            path.append(UIBezierPath(rect: building))
            x += w + 4
            index += 3
        }
        return path
    }

    @objc private func enterChat() {
        let chat = WebViewController()
        navigationController?.pushViewController(chat, animated: true)
    }
}
