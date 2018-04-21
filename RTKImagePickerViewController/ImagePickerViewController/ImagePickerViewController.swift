// MARK: Frameworks

import Photos

// MARK: ImagePickerViewControllerDelegate

protocol ImagePickerViewControllerDelegate: class {
    func imagePickerViewController(_ imagePickerViewController: ImagePickerViewController, didSelect image: UIImage, for index: Int, at coordinate: CLLocationCoordinate2D?)
    func imagePickerViewControllerDidCancel(_ imagePickerViewController: ImagePickerViewController)
    func imagePickerViewControllerNotAuthorized(_ imagePickerViewController: ImagePickerViewController)
}

// MARK: ImagePickerViewController

class ImagePickerViewController: UIViewController {
    
    // MARK: Delegate
    
    weak var delegate: ImagePickerViewControllerDelegate?
    
    // MARK: Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var pickerView: PickerView!
    
    // MARK: Variables
    
    var originalImage: UIImage? {
        didSet {
            finishedImage = originalImage
        }
    }
    
    var filteredImage: UIImage? {
        didSet {
            finishedImage = filteredImage
        }
    }
    
    var croppedImage: UIImage? {
        didSet {
            imageView.image = croppedImage
        }
    }
    
    var finishedImage: UIImage? {
        didSet {
            imageView.image = finishedImage
        }
    }

    var coordinate: CLLocationCoordinate2D?
    var index: Int?
    
    // MARK: View Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        checkPhotoLibraryPermission()
        setupViewController()
        setupPickerView()
    }
    
    // MARK: Cell Methods
    
    private func setupViewController() {
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
    }
    
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.imageSize = imageView.frame.size
        pickerView.setupImagesArray()
        pickerView.selectImageAtIndex(0)
    }
    
    // MARK: Action Methods

    @IBAction func done(_ sender: Any?) {
        guard let image = finishedImage,
              let index = index else {
            return
        }
        
        delegate?.imagePickerViewController(self, didSelect: image, for: index, at: coordinate)
    }
    
    @IBAction func cancel(_ sender: Any?) {
        delegate?.imagePickerViewControllerDidCancel(self)
    }
    
    @IBAction func filter(_ sender: Any?) {
        presentImageFilterViewController()
    }
    
    // MARK: Helper Methods
    
    private func presentImageFilterViewController() {
        let storyboard = UIStoryboard(name: "PickerViewControllers", bundle: nil)
        guard let imageFilterViewController = storyboard.instantiateViewController(withIdentifier: "ImageFilterViewController") as? ImageFilterViewController else {
            return
        }
        imageFilterViewController.delegate = self
        imageFilterViewController.originalImage = originalImage
        present(imageFilterViewController, animated: true, completion: nil)
    }
    
    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            break
        case .denied, .restricted :
            delegate?.imagePickerViewControllerNotAuthorized(self)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ status in
                switch status {
                case .authorized:
                    self.setupPickerView()
                case .denied, .restricted:
                    self.delegate?.imagePickerViewControllerNotAuthorized(self)
                case .notDetermined:
                    self.delegate?.imagePickerViewControllerNotAuthorized(self)
                }
            })
        }
    }
}

// MARK: PickerViewDelegate Methods

extension ImagePickerViewController: PickerViewDelegate {
    func pickerView(_ pickerView: PickerView, didSelectImage image: UIImage?, with coordinate: CLLocationCoordinate2D?) {
        self.originalImage = image
        self.coordinate = coordinate
    }
}

// MARK: ImageFilterViewControllerDelegate

extension ImagePickerViewController: ImageFilterViewControllerDelegate {
    func imageFilterViewController(_ imageFilterViewController: ImageFilterViewController, didSelectFilteredImage filteredImage: UIImage) {
        self.filteredImage = filteredImage
        imageFilterViewController.dismiss(animated: true, completion: nil)
    }
    
    func imageFilterViewControllerDidCancel(_ imageFilterViewController: ImageFilterViewController) {
        imageFilterViewController.dismiss(animated: true, completion: nil)
    }
}
