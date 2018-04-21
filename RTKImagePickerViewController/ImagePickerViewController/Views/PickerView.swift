// MARK: Frameworks

import Photos
import UIKit

// MARK: PickerViewDelegate

protocol PickerViewDelegate: class {
    func pickerView(_ pickerView: PickerView, didSelectImage image: UIImage?, with coordinate: CLLocationCoordinate2D?)
}

// MARK: PickerView

class PickerView: UIView {
    
    // MARK: Delegate
    
    weak var delegate: PickerViewDelegate?
    
    // MARK: Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: Variables
    
    var imageAssets = [PHAsset]()
    var imageSize: CGSize?
    
    // MARK: Constants
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    
    // MARK: View Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCells()
    }
    
    // MARK: Helper Methods
    
    func setupImagesArray() {
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        assets.enumerateObjects({ (object, _, _) in
            self.imageAssets.append(object)
        })
        // Reverse the imageAsset array order so most recent photos are first
        self.imageAssets.reverse()
        // Reload our PickerView
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func selectImageAtIndex(_ index: Int) {
        // Check that we have some image assets
        if let imageSize = imageSize,
               imageAssets.count > 0 {
            let asset = imageAssets[index]
            
            // Dispatch the request to the user initiated thread,
            // which is the 2nd priority behind the main thread
            DispatchQueue.global(qos: .userInitiated).async {
                // Make photo request for image
                let options = PHImageRequestOptions()
                options.isNetworkAccessAllowed = true
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: imageSize,
                                                      contentMode: .aspectFill,
                                                      options: options) { (result, _) in
                    DispatchQueue.main.async {
                        self.delegate?.pickerView(self, didSelectImage: result, with: asset.location?.coordinate)
                    }
                }
            }
        }
    }
    
    private func registerCells() {
        collectionView!.register(UINib(nibName: String(describing: PhotoCollectionCell.self), bundle: nil), forCellWithReuseIdentifier: "cell")
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

extension PickerView: UICollectionViewDataSource, UICollectionViewDelegate {
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionCell
        let asset = imageAssets[indexPath.row]
        cell.configure(with: asset, indexPath: indexPath)
        return cell
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectImageAtIndex(indexPath.row)
    }
}

// MARK: UICollectionViewDelegateFlowLayout Methods

extension PickerView: UICollectionViewDelegateFlowLayout {
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
