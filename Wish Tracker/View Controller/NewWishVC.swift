//
//  NewWishVC.swift
//  Wish Tracker

// Author name : Vivek Chodvadiya
// This View controller is used for add new wish
// input is Title, Location, Wish image and description
// insert on database on click of save button
// Required input is title and description, Location and Wish image is optional field


import UIKit
import CoreData
import MobileCoreServices
import LocationPicker
import MapKit

class NewWishVC: UIViewController  {
    
    // MARK: - Outlets
    @IBOutlet private weak var btnBack: UIButton!
    @IBOutlet private weak var btnSave: UIButton!
    
    @IBOutlet private weak var txtTitle: UITextField!
    @IBOutlet private weak var txtDescription: UITextView!
    
    @IBOutlet weak var txtLocationPicker: UITextField!
    // MARK: - Properties
    
    @IBOutlet weak var txtSelectImage: UITextField!
    
    var selectedImage : Data?
    
    // MARK: - VC Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVIew()
    }
    
    func initVIew(){
        txtDescription.layer.borderColor = UIColor.lightGray.cgColor
        txtDescription.layer.borderWidth = 0.8
     
        txtSelectImage.delegate = self
        txtSelectImage.inputView = UIView()
        txtSelectImage.inputAccessoryView = UIView()
        txtLocationPicker.delegate = self
        txtLocationPicker.inputView = UIView()
        txtLocationPicker.inputAccessoryView = UIView()
    }
    
    // MARK: - Action
    @IBAction func onBtnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBtnSave(_ sender: UIButton) {
        if txtTitle.text!.isEmpty {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter title.")
        } else if txtDescription.text!.isEmpty {
            AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Please enter description.")
        } else {
            view.endEditing(true)
            
            let context = AppDelegate.shared.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "WishList", in: context)
            let addWish = NSManagedObject(entity: entity!, insertInto: context)
            
            let userId = UserDefaults.standard.object(forKey: "userId") as! String
            
            addWish.setValue(String(Date().timeIntervalSince1970), forKey: "wishId")
            addWish.setValue(txtTitle.text, forKey: "title")
            addWish.setValue(txtDescription.text, forKey: "desc")
            addWish.setValue(userId, forKey: "userId")
            addWish.setValue(Date(), forKey: "date")
            addWish.setValue(false, forKey: "isComplete")
            addWish.setValue(txtLocationPicker.text, forKey: "location")
            addWish.setValue(selectedImage, forKey: "wishImage")
            
            do {
                try context.save()
                
                let alertController = UIAlertController(title: "Wish Tracker", message: "Wish added successfully.", preferredStyle: UIAlertController.Style.alert)

                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                { action -> Void in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alertController, animated: true, completion: nil)
                
            } catch {
                AppDelegate.shared.showErrorAlertView(vc: self, messageString: "Unknown Error")
                print("Failed saving")
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate and Take a Photo or Choose from Gallery Methods
extension NewWishVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        _ = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        _ = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            let fileName = url.lastPathComponent
//                var fileType = url.pathExtension
                self.txtSelectImage.text = fileName
            guard let userPickedImage = info[.editedImage] as? UIImage else { return }
            let imgData = userPickedImage.jpegData(compressionQuality: 1)
            selectedImage = imgData
        }
//        imgCovePhoto.image = editedImage
//        viewModel.foodData = editedImage?.jpegData(compressionQuality: 1.0)
        
        picker.dismiss(animated: true, completion: nil)
    }

    //Photo selection methods
    private func selectImage() {
        view.endEditing(true)
        
        var alertController = UIAlertController()
//        alertController.popoverPresentationController?.sourceView = imgCovePhoto
//        alertController.popoverPresentationController?.sourceRect = imgCovePhoto.bounds
        alertController = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: { (action) -> Void in
            DispatchQueue.main.async {
                self.loadCameraView()
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "From Gallery", style: .default, handler: { (action) -> Void in
            DispatchQueue.main.async {
                self.loadPhotoGalleryView()
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel".uppercased(), style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadCameraView() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.navigationBar.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            imagePickerController.sourceType = .camera
            imagePickerController.mediaTypes = [kUTTypeImage as String]
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            imagePickerController.showsCameraControls = true
            present(imagePickerController, animated: true, completion: nil)
        } else {
//            showMessageAlert(title: "Warning", andMessage: "Camera option does not available with this device.", withOkButtonTitle: "OK")
        }
    }
    
    func loadPhotoGalleryView() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.mediaTypes = [kUTTypeImage as String]
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            
            present(imagePickerController, animated: true, completion: nil)
        } else {
//            showMessageAlert(title: "Warning", andMessage: "Photo library does not available on this device.", withOkButtonTitle: "OK")
        }
    }
    
    func openPlacePicker(){
        let locationPicker = LocationPickerViewController()

        // you can optionally set initial location
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.331686, longitude: -122.030656), addressDictionary: nil)
        let location = Location(name: "1 Infinite Loop, Cupertino", location: nil, placemark: placemark)
        locationPicker.location = location

        // button placed on right bottom corner
        locationPicker.showCurrentLocationButton = true // default: true

        // default: navigation bar's `barTintColor` or `UIColor.white`
        locationPicker.currentLocationButtonBackground = .blue

        // ignored if initial location is given, shows that location instead
        locationPicker.showCurrentLocationInitially = true // default: true

        locationPicker.mapType = .standard // default: .Hybrid

        // for searching, see `MKLocalSearchRequest`'s `region` property
        locationPicker.useCurrentLocationAsHint = true // default: false

        locationPicker.searchBarPlaceholder = "Search places" // default: "Search or enter an address"

        locationPicker.searchHistoryLabel = "Previously searched" // default: "Search History"

        // optional region distance to be used for creation region when user selects place from search results
        locationPicker.resultRegionDistance = 500 // default: 600

        locationPicker.completion = { location in
            // do some awesome stuff with location
            self.txtLocationPicker.text = location?.name
        }

        navigationController?.pushViewController(locationPicker, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension NewWishVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.perform(#selector(self.view.endEditing(_:)), with: true, afterDelay: 0.0000000001)
        if textField == txtSelectImage {
            delay(time: 0.00000000000001) { [self] in
                self.txtSelectImage.resignFirstResponder()
                self.selectImage()
            }
            
        }
        if textField == txtLocationPicker {
            delay(time: 0.00000000000001) {
                self.txtLocationPicker.resignFirstResponder()
                self.openPlacePicker()
            }
        }
    }
}

func delay(time: Double, closure:
    @escaping ()->()) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
        closure()
    }
    
}
