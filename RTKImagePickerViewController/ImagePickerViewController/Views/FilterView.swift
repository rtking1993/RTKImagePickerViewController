// MARK: Frameworks

import UIKit

// MARK: FilterViewDelegate

protocol FilterViewDelegate: class {
    func filterView(_ filterView: FilterView, didSelect filterType: FilterType)
}

// MARK: FilterView

class FilterView: UIView {
    
    // MARK: Delegate
    
    weak var delegate: FilterViewDelegate?
    
    // MARK: Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: Variables
    
    var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else {
                return
            }
            sampleImage = originalImage.resized(toWidth: imageWidth)
        }
    }
    
    var sampleImage: UIImage? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var imageWidth: CGFloat {
        let paddingSpace = (sectionInsets.left + sectionInsets.right) * itemsPerRow
        return frame.width - paddingSpace
    }
    
    // MARK: Constants
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)

    // MARK: View Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView!.register(UINib(nibName: String(describing: FilterCell.self), bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    // MARK: Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        let className = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
        Bundle.main.loadNibNamed(className, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate Methods

extension FilterView: UICollectionViewDataSource, UICollectionViewDelegate {
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilterCell
        let filter = filters[indexPath.row]
        let filteredImage = sampleImage?.filter(with: filter.filterType)
        cell.configure(with: filter.title, image: filteredImage)
        return cell
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterView(self, didSelect: filters[indexPath.row].filterType)
    }
}

// MARK: UICollectionViewDelegateFlowLayout Methods

extension FilterView: UICollectionViewDelegateFlowLayout {
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = (sectionInsets.left + sectionInsets.right) * itemsPerRow
        let availableWidth = frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
}
