import UIKit

extension UIView {
    public func setTopAnchor(_ top: NSLayoutYAxisAnchor?, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: constant).isActive = true
        }
    }

    public func setLeftAnchor(_ left: NSLayoutXAxisAnchor?, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: constant).isActive = true
        }
    }

    public func setBottomAnchor(_ bottom: NSLayoutYAxisAnchor?, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: constant).isActive = true
        }
    }

    public func setRightAnchor(_ right: NSLayoutXAxisAnchor?, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: constant).isActive = true
        }
    }

    public func setLeadingAnchor(_ leading: NSLayoutXAxisAnchor?) {
        translatesAutoresizingMaskIntoConstraints = false
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading).isActive = true
        }
    }

    public func setTrailingAnchor(_ trailing: NSLayoutXAxisAnchor?) {
        translatesAutoresizingMaskIntoConstraints = false
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing).isActive = true
        }
    }

    public func setAnchors(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        setTopAnchor(top, constant: topConstant)
        setLeftAnchor(left, constant: leftConstant)
        setBottomAnchor(bottom, constant: bottomConstant)
        setRightAnchor(right, constant: rightConstant)
    }

    public func setConstantDimensions(width widthConstant: CGFloat = 0, height heightConstant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if widthConstant > 0 {
            widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        }
        
        if heightConstant > 0 {
            heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        }
    }

    public func setDimensionAnchors(widthAnchor width: NSLayoutDimension?, heightAnchor height: NSLayoutDimension? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let wA = width {
            widthAnchor.constraint(equalTo: wA).isActive = true
        }
        
        if let hA = height {
            heightAnchor.constraint(equalTo: hA).isActive = true
        }
    }
}
