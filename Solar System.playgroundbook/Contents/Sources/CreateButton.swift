import UIKit

extension UIViewController {
    func ControlButton(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.cornerRadius = 30
        btn.layer.borderWidth = 2
        btn.layer.backgroundColor = UIColor.white.cgColor
        btn.setTitle(title, for: .normal)
        return btn
    }

    func PlanetButton(name: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "buttons/\(name)"), for: .normal) // all btns are having suffix btn : IMPORTANT
        btn.setTitle(name, for: .normal)
        return btn
    }

    public func setupPlanetTray(tray: [String]) -> [UIButton] {
        var buttons: [UIButton] = []

        for (index, name) in tray.enumerated() {
            let button = PlanetButton(name: name)
            button.alpha = 0.3
            button.setConstantDimensions(width: 60, height: 60)
            buttons.append(button)
        }

        return buttons
    }

    public func setupControlTray(tray: [String]) -> [UIButton] {
        var buttons: [UIButton] = []

        for (index, title) in tray.enumerated() {
            let button = ControlButton(title: title)
            button.setConstantDimensions(width: 60, height: 60)
            buttons.append(button)
        }

        return buttons
    }

    public func generateStack(tray1: [UIButton], tray2: [UIButton]) -> UIStackView {

        let view = UIStackView(arrangedSubviews: tray1)

        for button in tray2 {
            view.addArrangedSubview(button)
        }

        view.alignment = .center
        view.distribution = .equalSpacing
        view.axis = .vertical
        view.spacing = 10
        //view.anchor(top: layoutGuide.topAnchor, left: nil, bottom: layoutGuide.bottomAnchor, right: layoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 0)
		
        return view
    }

    public func setupAnchors(scroller: UIScrollView, stack: UIStackView, anchors: UILayoutGuide) {
        scroller.setAnchors(top: anchors.topAnchor, left: nil, bottom: anchors.bottomAnchor, right: anchors.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: -15, rightConstant: 0)
        scroller.setConstantDimensions(width: 100, height: 0)

        stack.setAnchors(top: scroller.topAnchor, left: nil, bottom: scroller.bottomAnchor, right: nil)//, topConstant: 100, leftConstant: 0, bottomConstant: 100, rightConstant: 0)
        stack.setLeadingAnchor(scroller.leadingAnchor)
        stack.setTrailingAnchor(scroller.trailingAnchor)
        
        stack.setDimensionAnchors(widthAnchor: scroller.widthAnchor)
    }
}