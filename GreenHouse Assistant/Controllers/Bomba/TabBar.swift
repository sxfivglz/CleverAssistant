import UIKit

class CustomTabBar : UITabBar {
    @IBInspectable var height: CGFloat = 0.0

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height
        }
        return sizeThatFits
    }
        override var traitCollection: UITraitCollection {
           guard UIDevice.current.userInterfaceIdiom == .pad else {
             return super.traitCollection
           }

           return UITraitCollection(horizontalSizeClass: .compact)
         }
    }

