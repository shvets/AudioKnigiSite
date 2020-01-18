import Foundation
import UIKit
import TVSetKit

extension UIImage {
    convenience init?(imageName: String) {
        self.init(named: imageName)
        accessibilityIdentifier = imageName
    }

    // https://stackoverflow.com/a/40177870/4488252
    func imageWithColor (newColor: UIColor?) -> UIImage? {

        if let newColor = newColor {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)

            let context = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(.normal)

            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context.clip(to: rect, mask: cgImage!)

            newColor.setFill()
            context.fill(rect)

            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            newImage.accessibilityIdentifier = accessibilityIdentifier
            return newImage
        }

        if let accessibilityIdentifier = accessibilityIdentifier {
            return UIImage(imageName: accessibilityIdentifier)
        }

        return self
    }
}

public struct CellConfigurator<Model> {
  public let titleKeyPath: KeyPath<Model, String?>
  public let imageKeyPath: KeyPath<Model, String?>
  
  public func configure(_ cell: UITableViewCell, for model: Model, localizer: Localizer, applyColor: Bool = true) {
    cell.textLabel?.text = localizer.getLocalizedName(model[keyPath: titleKeyPath])
    
    if let imageName = model[keyPath: imageKeyPath] {
      //cell.imageView?.image = UIImage(named: imageName)
      
      if applyColor {
        let color = cell.imageView?.traitCollection.userInterfaceStyle == .dark ? UIColor.lightText : UIColor.darkText

        cell.imageView?.image = UIImage(named: imageName)?.imageWithColor(newColor: color)
      }
      else {
        cell.imageView?.image = UIImage(named: imageName)
      }
    }
  }
}
