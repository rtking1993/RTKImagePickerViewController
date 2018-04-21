// MARK: Frameworks

import UIKit

// MARK: UIImage Methods

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let scale = size.width / size.height
        let canvasSize = CGSize(width: width, height: ceil(width * scale))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func filter(with filterType: FilterType) -> UIImage? {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: self)
        if let filter = CIFilter(name: filterType.rawValue) {
            filter.setDefaults()
            filter.setValue(coreImage, forKey: kCIInputImageKey)
            if let filteredImageData = filter.value(forKey: kCIOutputImageKey) as? CIImage,
               let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent) {
                return UIImage(cgImage: filteredImageRef)
            }
        }
        return self
    }
}
