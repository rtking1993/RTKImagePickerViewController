// MARK: Frameworks

import UIKit

// MARK: ImageFilterViewControllerDelegate

protocol ImageFilterViewControllerDelegate: class {
    func imageFilterViewController(_ imageFilterViewController: ImageFilterViewController, didSelectFilteredImage filteredImage: UIImage)
    func imageFilterViewControllerDidCancel(_ imageFilterViewController: ImageFilterViewController)
}

// MARK: ImageFilterViewController

class ImageFilterViewController: UIViewController {
    
    // MARK: Delegate
    
    weak var delegate: ImageFilterViewControllerDelegate?
    
    // MARK: Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var filterView: FilterView!
    
    // MARK: Variables
    
    var originalImage: UIImage?
    
    var filteredImage: UIImage? {
        didSet {
            imageView.image = filteredImage
        }
    }
    
    // MARK: Constants
    
    private let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    private let itemsPerRow: CGFloat = 4
    
    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        imageView.image = originalImage
        setupFilterView()
    }
    
    // MARK: Helper Methods
    
    private func setupViewController() {
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
    }
    
    private func setupFilterView() {
        filterView.delegate = self
        filterView.originalImage = originalImage
    }
    
    // MARK: Action Methods
    
    @IBAction func done(sender: Any?) {
        guard let image = filteredImage else {
            return
        }
        
        delegate?.imageFilterViewController(self, didSelectFilteredImage: image)
    }
    
    @IBAction func cancel(sender: Any?) {
        delegate?.imageFilterViewControllerDidCancel(self)
    }
}

// MARK: FilterViewDelegate

extension ImageFilterViewController: FilterViewDelegate {
    func filterView(_ filterView: FilterView, didSelect filterType: FilterType) {
        filteredImage = originalImage?.filter(with: filterType)
    }
}
