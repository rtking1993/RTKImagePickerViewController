// MARK: Frameworks

import UIKit

// MARK: FilterCell

class FilterCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var gradientView: GradientView!
    
    // MARK: Cell Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        imageView.image = nil
    }
    
    // MARK: Configure Methods
    
    func configure(with title: String, image: UIImage?) {
        titleLabel.text = title
        imageView.image = image
    }
}
