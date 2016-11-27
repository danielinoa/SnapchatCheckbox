//
//  Created by Daniel Inoa on 11/19/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import UIKit

@IBDesignable final class SnapchatCheckbox: UIControl {
    
    private(set) var isChecked: Bool = false
    
    func setChecked(_ checked: Bool, animated: Bool = false) {
        let fromValue: Float = isChecked ? 1 : 0
        let toValue: Float = isChecked ? 0 : 1
        if animated {
            let animation = CAKeyframeAnimation(keyPath: "path")
            let byValue: Float = 0.01 * ( !isChecked ? 1 : -1)
            let pathValues = stride(from: fromValue, to: toValue, by: byValue).map({ piePath(withFraction: $0).cgPath })
            animation.values = pathValues
            animation.duration = 0.5
            shapeLayer.add(animation, forKey: "pathAnimation")
        }
        shapeLayer.path = piePath(withFraction: toValue).cgPath
        isChecked = checked
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        clipsToBounds = true
        layer.cornerRadius = 5
        layer.borderColor = tintColor.cgColor
        layer.borderWidth = 4
        layer.addSublayer(shapeLayer)
    }
    
    // MARK: - Appearance
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? tintColor.withAlphaComponent(0.2) : .clear
        }
    }
    
    override var clipsToBounds: Bool {
        didSet {
            // workaround
            if !clipsToBounds {
                clipsToBounds = true
            }
        }
    }
    
    private lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = self.tintColor.cgColor
        let fraction: Float = self.isChecked ? 1 : 0
        layer.path = self.piePath(withFraction: fraction).cgPath
        return layer
    }()
    
    private func piePath(withFraction fraction: Float) -> UIBezierPath {
        let fraction = min(max(0, fraction), 1)
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius = max(bounds.width, bounds.height)
        let path = UIBezierPath()
        path.move(to: center)
        path.addArc(withCenter: center,
                    radius: radius,
                    startAngle: -CGFloat(M_PI_2),
                    endAngle: -CGFloat(M_PI * 2) * CGFloat(fraction) - CGFloat(M_PI_2),
                    clockwise: false)
        path.addLine(to: center)
        return path
    }
    
    // MARK: - Auto Layout
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    // MARK: - Tracking
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        if let touchLocation = touch?.location(in: self), bounds.contains(touchLocation) {
            setChecked(!isChecked, animated: true)
            sendActions(for: .valueChanged)
        }
    }
    
    // MARK: - Interface Builder
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setNeedsDisplay()
    }
    
}
