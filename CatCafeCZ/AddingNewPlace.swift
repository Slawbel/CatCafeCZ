import UIKit
import PhotosUI


protocol ArgumentsOfPlaceDelegate: AnyObject {
    func initializeImageOfPlace(image: UIImage?)
    func initializeNameOfPlace(name: String)
    func initializeLocationOfPlace(location: String?)
    func initializeTypeOfPlace( type: String?)
}


class AddingNewPlace: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    private var tableView = UITableView()
    
    private var selectedImage: UIImage?
    private var nameOfPlace: String = ""
    private var locationOfPlace: String?
    private var typeOfPlace: String?
    
    weak var imageDelegate: CustomCellImage?
    weak var newPlaceDelegate: newPlaceDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellForAddingNewPlace.self, forCellReuseIdentifier: "CellForAddingNewPlace")
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .black
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.register(CellForAddingNewPlace.self, forCellReuseIdentifier: "CellForAddingNewPlace")
        
        view.addSubview(tableView)
        view.addGestureRecognizer(tapGesture)
        
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view)
            make.top.equalTo(view)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // makes button Save visible (and unvisible again when textField for name of place is empty)
    @objc private func textFieldDidChange(textFromTF: UITextField) {
        if let text = textFromTF.text, !text.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc private func saveTapped() {
        let place = Cafe(name: nameOfPlace, location: locationOfPlace, type: typeOfPlace, restaurantImage: nil, image: selectedImage)
        self.newPlaceDelegate?.addPlace(newPlace: place)
        cancelTapped()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CellForAddingNewPlace.cellForIndexPath(indexPath: indexPath)
        
        if let customCellImage = cell as? CustomCellImage {
            if selectedImage == nil {
                customCellImage.setupImageByText(text: "Photo")
                self.selectedImage = UIImage(named: "imagePlaceholder")
            } else {
                customCellImage.setupImageByImage(image: selectedImage!)
            }
        }
        
        // Inside cellForRowAt method of AddingNewPlace class
        if let customCellName = cell as? CustomCellName {
            customCellName.delegate = self
            customCellName.placeName.delegate = self
            customCellName.placeName.text = nameOfPlace
        } else if let customCellLocation = cell as? CustomCellLocation {
            customCellLocation.delegate = self
            customCellLocation.placeLocation.delegate = self
            customCellLocation.placeLocation.text = locationOfPlace
        } else if let customCellPlace = cell as? CustomCellPlace {
            customCellPlace.delegate = self
            customCellPlace.placeType.delegate = self
            customCellPlace.placeType.text = typeOfPlace
        }
        
        if indexPath.row == 1 {
            (cell as? CustomCellName)?.placeName.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }

        cell.layer.cornerRadius = 20
        cell.backgroundColor = .systemGray6
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        } else {
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cameraIcon = UIImage(imageLiteralResourceName: "camera")
            let photoIcon = UIImage(imageLiteralResourceName: "photo1")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseCameraPicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseCameraPicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
                let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }
}

extension AddingNewPlace: UIImagePickerControllerDelegate {
    func chooseCameraPicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = source
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)

            if let editedImage = info[.editedImage] as? UIImage {
                self.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                self.selectedImage = originalImage
            }


            let indexPath = IndexPath(row: 0, section: 0)
            //self.tableView.reloadRows(at: [indexPath], with: .none)
            self.tableView.reloadData()
    }
}

extension AddingNewPlace: ArgumentsOfPlaceDelegate {
    internal func initializeImageOfPlace (image: UIImage?) {
        print(image == nil)
        if image != nil {
            print("initializeImageOfPlace is working")
            self.selectedImage = image
        }
    }
    
    internal func initializeNameOfPlace (name: String) {
        self.nameOfPlace = name
    }
    
    internal func initializeLocationOfPlace (location: String?) {
        if location != nil {
            self.locationOfPlace = location
        }
    }
    
    internal func initializeTypeOfPlace (type: String?) {
        if type != nil {
            self.typeOfPlace = type
        }
    }
}

extension AddingNewPlace: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


