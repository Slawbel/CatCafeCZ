import UIKit

protocol ArgumentsOfPlaceDelegate: AnyObject {
    func initializeNameOfPlace(name: String)
    func initializeLocationOfPlace(location: String?)
    func initializeTypeOfPlace( type: String?)
    func initializeRating(rating: Double!)
}

class AddingNewPlace: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, ArgumentsOfPlaceDelegate {

    
    private var tableView = UITableView()
    
    private var selectedImage: UIImage?
    private var nameOfPlace: String = ""
    private var locationOfPlace: String?
    private var typeOfPlace: String?
    private var rating: Double = 0.0
    
    var currentCafe: Cafe?
    
    weak var delegateToUpdateTableView: AddingNewPlaceDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // to hide keyboard when user taps on background
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        // Check If editing text was existed and transfer it for editing
        checkForExistedText()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellForAddingNewPlace.self, forCellReuseIdentifier: "CellForAddingNewPlace")
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .black
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        // calling of methods to show textField when keyboard covers textField
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                
        view.addSubview(tableView)
        view.addGestureRecognizer(tapGesture)
        
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view)
            make.top.equalTo(view)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - save and close methods
    @objc private func cancelTapped() {
        Coordinator.closeAnotherScreen(from: self)
    }
    
    // adding of content to DB
    @objc private func saveTapped() {
        let imageData = selectedImage?.pngData()

        let newPlace = Cafe(name: nameOfPlace, location: locationOfPlace, type: typeOfPlace, imageData: imageData, rating: rating)
        if let currentCafe = currentCafe {
            do {
                try realm.write {
                    currentCafe.name = newPlace.name
                    currentCafe.location = newPlace.location
                    currentCafe.type = newPlace.type
                    currentCafe.imageData = newPlace.imageData
                    currentCafe.rating = newPlace.rating
                }
            } catch {
                print("Error updating currentCafe: \(error)")
            }
        } else {
            StoreManager.saveObject(newPlace)
        }
        delegateToUpdateTableView?.didAddNewPlace()
        cancelTapped()
    }
    
    
    // MARK: - UITableView setting
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CellForAddingNewPlace.cellForIndexPath(indexPath: indexPath)
        
        // if currentCafe != nil then screen is opened for editing, else it is opened for new cafe
        if currentCafe != nil {
            setupSaveButtonEditing()
            if let name = currentCafe?.name {
                if let customCellName = cell as? CustomCellName {
                    customCellName.delegate = self
                    customCellName.placeName.delegate = self
                    customCellName.placeName.text = name
                } else if let customCellLocation = cell as? CustomCellLocation {
                    customCellLocation.delegate = self
                    customCellLocation.placeLocation.delegate = self
                    customCellLocation.placeLocation.text = currentCafe?.location
                    customCellLocation.mapButton.addTarget(self, action: #selector(findAddress), for: .touchUpInside)
                } else if let customCellPlace = cell as? CustomCellPlace {
                    customCellPlace.delegate = self
                    customCellPlace.placeType.delegate = self
                    customCellPlace.placeType.text = currentCafe?.type
                } else if let ratingControl = cell as? RatingControl {
                    ratingControl.delegate = self
                    ratingControl.rating = Int(currentCafe!.rating)
                } else if let customCellImage = cell as? CustomCellImage {
                    if currentCafe?.imageData != nil {
                        let data = currentCafe?.imageData
                        let image = UIImage(data: data!)
                        customCellImage.setupImageByImage(image: image!)
                    } else {
                        customCellImage.setupImageByText(text: "Photo")
                    }
                    customCellImage.placeImage.clipsToBounds = true
                    customCellImage.buttonMap.addTarget(self, action: #selector(buttonMapTapped), for: .touchUpInside)
                }
            }
            
        } else {
            // Inside cellForRowAt method
            if let customCellName = cell as? CustomCellName {
                customCellName.delegate = self
                customCellName.placeName.delegate = self
                customCellName.placeName.text = nameOfPlace
            } else if let customCellLocation = cell as? CustomCellLocation {
                customCellLocation.delegate = self
                customCellLocation.placeLocation.delegate = self
                customCellLocation.placeLocation.text = locationOfPlace
                customCellLocation.mapButton.addTarget(self, action: #selector(findAddress), for: .touchUpInside)
            } else if let ratingControl = cell as? RatingControl {
                ratingControl.delegate = self
                ratingControl.rating = 1
            } else if let customCellPlace = cell as? CustomCellPlace {
                customCellPlace.delegate = self
                customCellPlace.placeType.delegate = self
                customCellPlace.placeType.text = typeOfPlace
            }
            
        }
        
        // the first cell will have template image or downloaded image
        if let customCellImage = cell as? CustomCellImage {
            if selectedImage == nil {
                customCellImage.setupImageByText(text: "Photo")
            } else {
                customCellImage.setupImageByImage(image: selectedImage!)
            }
            customCellImage.buttonMap.addTarget(self, action: #selector(buttonMapTapped), for: .touchUpInside)
        }
        
        // blocking of button Save
        if indexPath.row == 1 {
            (cell as? CustomCellName)?.placeName.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }

        //cell.layer.cornerRadius = 20
        cell.backgroundColor = .systemGray6
        
        return cell
    }
    
    @objc func buttonMapTapped() {
        let mapVC = MapViewController()
        mapVC.place.name = self.nameOfPlace
        mapVC.place.location = self.locationOfPlace
        mapVC.place.type = self.typeOfPlace
        mapVC.place.imageData = selectedImage?.pngData() 
        mapVC.pinView.isHidden = true
        mapVC.addressLabel.isHidden = true
        mapVC.buttonDone.isHidden = true
        Coordinator.openAnotherScreen(from: self, to: mapVC)
    }
    
    @objc func findAddress() {
        let mapVC = MapViewController()
        mapVC.showUserLocation()
        mapVC.buttonDirection.isHidden = true
        Coordinator.openAnotherScreen(from: self, to: mapVC)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        } else if indexPath.row == 4 {
            return 75
        } else {
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cameraIcon = UIImage(imageLiteralResourceName: "camera")
            let photoIcon = UIImage(imageLiteralResourceName: "photo1")
            
            // setting of menu for downloading if image from camera or album
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
            
            let clear = UIAlertAction(title: "Clear Picture", style: .destructive) {_ in
                self.selectedImage = nil
                tableView.reloadData()
            }
            
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            if self.selectedImage != nil {
                actionSheet.addAction(clear)
            }
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
        }
    }
    
    
// MARK: - hide keyboard, and show textField when keyboard covers it
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
    
    // makes button Save visible (and unvisible again when textField for name of place is empty)
    @objc private func textFieldDidChange(textFromTF: UITextField) {
        if let text = textFromTF.text, !text.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}


// MARK: - connection to camera
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
    
    // updating of picture that is shown on the first cell
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let editedImage = info[.editedImage] as? UIImage {
            self.selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.selectedImage = originalImage
        }
        
        self.tableView.reloadData()
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
    
    func initializeRating(rating: Double!) {
        self.rating = rating
    }


    // MARK: - Setting of content for editing
    private func setupSaveButtonEditing() {
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItem = nil
        title = currentCafe?.name
    }
    
    // changes title to bigger size
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = currentCafe != nil
        navigationItem.largeTitleDisplayMode = .always
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
    // returns normal size of title
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func checkForExistedText () {
        if let currentCafe =  self.currentCafe {
            self.nameOfPlace = currentCafe.name
            self.locationOfPlace = currentCafe.location
            self.typeOfPlace = currentCafe.type
            if let data = currentCafe.imageData {
                self.selectedImage = UIImage(data: data)
            }
        }
    }
}

extension AddingNewPlace: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


