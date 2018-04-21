// MARK: Frameworks

import UIKit

// MARK: GradientView

class GradientView: UIView {
    
    // MARK: Variables

    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    // MARK: View Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let gradientLayer = layer as? CAGradientLayer else {
            return
        }
        
        gradientLayer.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
                                UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor,
                                UIColor(red: 1, green: 1, blue: 1, alpha: 0.8).cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.95)
    }
}
