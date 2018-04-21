// MARK: Frameworks

import UIKit
import CoreLocation

// MARK: ImageViewController

class ImageViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imagePickerButton: UIButton!
    
    // MARK: Action Methods
    
    @IBAction func pickImage(_ sender: Any?) {
        presentImagePickerViewController()
    }
    
    // MARK: Helper Methods
    
    private func presentImagePickerViewController() {
        let storyboard = UIStoryboard(name: "PickerViewControllers", bundle: nil)
        guard let imagePickerViewController = storyboard.instantiateViewController(withIdentifier: "ImagePickerViewController") as? ImagePickerViewController else {
            return
        }
        imagePickerViewController.index = 0
        imagePickerViewController.delegate = self
        present(imagePickerViewController, animated: true, completion: nil)
    }
}


// MARK: ImagePickerViewControllerDelegate Methods

extension ImageViewController: ImagePickerViewControllerDelegate {
    func imagePickerViewController(_ imagePickerViewController: ImagePickerViewController, didSelect image: UIImage, for index: Int, at coordinate: CLLocationCoordinate2D?) {
        imageView.image = image
        imagePickerViewController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerViewControllerDidCancel(_ imagePickerViewController: ImagePickerViewController) {
        imagePickerViewController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerViewControllerNotAuthorized(_ imagePickerViewController: ImagePickerViewController) {
        imagePickerViewController.dismiss(animated: true) {
            let alert = UIAlertController(title: "Photo Permission Warning", message: "Go to settings and allow this app to access photos to continue.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: ""),
                                          style: .default, handler: { _ in
                if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
