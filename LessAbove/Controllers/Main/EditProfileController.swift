//
//  EditProfileController.swift
//  LESSABOVE
//
//  Created by John Nik on 9/12/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase
import KRProgressHUD

class EditProfileController: UIViewController {
    
    var profileControllerDelegate: ProfileControllerDelegate?
    
    var lessAboveUser: LessAboveUser? {
        didSet {
            
            fetchUserProfile()
            
        }
    }
    
    var backgroundScrollViewConstraint: NSLayoutConstraint?
    
    let backgroundScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = StyleGuideManager.profileScrollViewColor
        scrollView.alwaysBounceVertical = true
        scrollView.contentSize = CGSize(width: DEVICE_WIDTH, height: DEVICE_HEIGHT * 1.7 / 3 + 380)
        return scrollView
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AssetName.profileBackground.rawValue)
        imageView.alpha = 0.2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AssetName.profile.rawValue)
        imageView.layer.cornerRadius = DEVICE_WIDTH * 0.35 / 2
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Share your Bio"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("EDIT YOUR PROFILE PICTURE", for: .normal)
        button.backgroundColor = StyleGuideManager.editProfileButtonColor
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSelectProfileImageView), for: .touchUpInside)
        return button
    }()
    
    let fullnameLabel : UILabel = {
        let label = UILabel()
        label.text = "Full Name"
        label.textColor = .gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let fullnameTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Full Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .gray
        return textField
        
    }()
    
    let biobottomLabel : UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.textColor = .gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let bioTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Bio entered by user"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .gray
        return textField
        
    }()
    
    let usernameBottomLabel : UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.textColor = .gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let usernameTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "User Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .gray
        return textField
        
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.textColor = .gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let locationTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Location entered by user"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .gray
        return textField
        
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupKeyboardObservers()
        fetchUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
    }
    
}

//MARK: fetch user profile

extension EditProfileController {
    
    fileprivate func fetchUserProfile() {
        
        KRProgressHUD.show()
        
        let checkConnection = RKCommon.checkInternetConnection()
        if !checkConnection {
            KRProgressHUD.dismiss()
            self.showErrorAlertWith("Connection Error", message: "Please check your internet connection")
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            KRProgressHUD.dismiss()
            return
        }
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.usernameTextField.text = dictionary["username"] as? String
                self.usernameLabel.text = dictionary["username"] as? String
                self.fullnameTextField.text = dictionary["fullname"] as? String
//                self.emailTextField.text = dictionary["email"] as? String
                
                if let location = dictionary["location"] as? String {
                    
                    self.locationTextField.text = location
                }
                
                if let bio = dictionary["bio"] as? String {
                    
                    if bio != "" {
                        self.bioTextField.text = bio
                        self.bioLabel.text = bio
                    }
                    
                }
                let profileImageUrl = dictionary["profilePictureURL"] as? String
                if profileImageUrl != "" {
                    
                    self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
                    self.backgroundImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
                }
                KRProgressHUD.dismiss()
            }
        }, withCancel: nil)
        
        
    }
    
}


//MARK: - handleKeyboard
extension EditProfileController {
    func setupKeyboardObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.backgroundScrollViewConstraint?.constant = 0
            } else {
                self.backgroundScrollViewConstraint?.constant = -(endFrame?.size.height)!
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}


//MARK: handle dismiss, save profile
extension EditProfileController {
    
    @objc fileprivate func handleDismiss() {
        self.dismiss(animated: false, completion: nil)
    }
}

//MARK: handle Photo galary

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @objc fileprivate func handleSelectProfileImageView() {
        
        let alertController = UIAlertController(title: "What would you like?", message: "", preferredStyle: .actionSheet)
        
        let photoGalleryAction = UIAlertAction(title: "Choose a Photo", style: .default) { (action) in
            
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.sourceType = .savedPhotosAlbum
            
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                
                picker.modalPresentationStyle = .popover
                picker.popoverPresentationController?.delegate = self
                //                picker.popoverPresentationController?.sourceView = self.view
                self.navigationController?.present(picker, animated: true, completion: nil)
                
            } else {
                self.navigationController?.present(picker, animated: true, completion: nil)
            }
            
            
        }
        
        let cameraAction = UIAlertAction(title: "Take a Picture", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                
                
                if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                    
                    picker.modalPresentationStyle = .popover
                    picker.popoverPresentationController?.delegate = self
                    //                    picker.popoverPresentationController?.sourceView = self.view
                    self.navigationController?.present(picker, animated: true, completion: nil)
                    
                } else {
                    self.navigationController?.present(picker, animated: true, completion: nil)
                }
                
                
                
            } else {
                self.noCamera()
            }
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(photoGalleryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            
            alertController.modalPresentationStyle = .popover
            alertController.popoverPresentationController?.delegate = self
            //            alertController.popoverPresentationController?.sourceView = view
            present(alertController, animated: true, completion: nil)
            
            
        } else {
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        
        popoverPresentationController.sourceView = self.profileImageView
        popoverPresentationController.sourceRect = self.profileImageView.bounds
        popoverPresentationController.permittedArrowDirections = .up
    }
    
    func noCamera() {
        
        showAlertMessage(vc: self, titleStr: "No Camera", messageStr: "Sorry, this device has no camera")
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImmageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            selectedImmageFromPicker = editedImage
            
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImmageFromPicker = originalImage
            
        }
        
        if let selectedImage = selectedImmageFromPicker {
            
            self.profileImageView.image = selectedImage
            self.backgroundImageView.image = selectedImage
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
}


//MARK: handle update, dismiss controller

extension EditProfileController {
    
    private func handleValidCheck() {
        let checkConnection = RKCommon.checkInternetConnection()
        if !checkConnection {
            KRProgressHUD.dismiss()
            self.showErrorAlertWith("Connection Error", message: "Please check your internet connection")
            return
        }
        
        if !(checkInvalid()) {
            KRProgressHUD.dismiss()
            return
        }
    }
    
    private func handleUpdateWithFirebase() {
        guard let fullname = fullnameTextField.text, let username = usernameTextField.text  else {
            
            showAlertMessage(vc: self, titleStr: "Invalid email & password!", messageStr: "Write correct information")
            KRProgressHUD.dismiss()
            return
        }
        
        var profileImageName = String()
        if let imageName = Auth.auth().currentUser?.uid {
            profileImageName = imageName
        } else {
            profileImageName = NSUUID().uuidString
        }
        
        let storageRef = Storage.storage().reference().child("user_images").child("\(profileImageName)profileImage.jpeg")
        
        if let profileImageView = self.profileImageView.image {
            
            var image = profileImageView
            if profileImageView.size.width > 200 {
                image = profileImageView.resized(toWidth: 200.0)!
                
            }
            if let uploadData = UIImageJPEGRepresentation(image, 0.1) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        KRProgressHUD.dismiss()
                        showAlertMessage(vc: self, titleStr: "Something went wrong!", messageStr: "Try again later")
                        return
                    }
                    if let profilePictureURL = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["username": username, "fullname": fullname, "profilePictureURL": profilePictureURL, "location": self.locationTextField.text == nil ? "" : self.locationTextField.text!, "bio": self.bioTextField.text == nil ? "" : self.bioTextField.text! ]
                        
                        self.registerUserIntoDatabaseWithUid(values: values as [String : AnyObject])
                    }
                })
                
            }
        }
    }
    
    @objc fileprivate func handleUpdate() {
        
        self.showErrorAlertActionStringsWith("Update Profile", message: "Please make sure you made your profile changes", okActionStr: "Yes", cancelActionStr: "No", action: { (action) in
            KRProgressHUD.show()
            self.handleValidCheck()
            self.handleUpdateWithFirebase()
        }, completion: nil)
        
    }
    
    private func registerUserIntoDatabaseWithUid(values: [String: AnyObject]) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("users").child(uid)
        ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                KRProgressHUD.dismiss()
                showAlertMessage(vc: self, titleStr: "Something went wrong!", messageStr: "Try again later")
                return
            }
            KRProgressHUD.dismiss()
            self.dismiss(animated: false, completion: {
                self.profileControllerDelegate?.reloadProfileData()
            })
        })
    }
    
}


//MARK: check invalid

extension EditProfileController {
    fileprivate func checkInvalid() -> Bool {
        
        if (fullnameTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Full Name!", messageStr: "")
            return false
        }
//        if (emailTextField.text?.isEmpty)! {
//            showAlertMessage(vc: self, titleStr: "Write Email!", messageStr: "ex: Anders703@oulook.com")
//            return false
//        }
        
        if (usernameTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Username!", messageStr: "")
            return false
        }
        return true
    }
    
}



//MARK: setup background and views

extension EditProfileController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupProfileStuff()
        setupLocationView()
    }
    
    private func setupProfileStuff() {
        
        view.addSubview(backgroundScrollView)
        
        backgroundScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundScrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        backgroundScrollViewConstraint = backgroundScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        backgroundScrollViewConstraint?.isActive = true
        
        backgroundScrollView.addSubview(backgroundImageView)
        backgroundScrollView.addSubview(profileImageView)
        backgroundScrollView.addSubview(usernameLabel)
        backgroundScrollView.addSubview(bioLabel)
        backgroundScrollView.addSubview(editProfileButton)
        
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: DEVICE_HEIGHT * 1.7 / 3).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: self.backgroundScrollView.topAnchor, constant: 0).isActive = true
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        profileImageView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.35).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.35).isActive = true
        profileImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 40).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        usernameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30).isActive = true
        
        bioLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bioLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10).isActive = true
        
        editProfileButton.widthAnchor.constraint(equalToConstant: 220).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        editProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editProfileButton.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 15).isActive = true
        
    }
    
    private func setupLocationView() {
        let locationContainerView = UIView()
        locationContainerView.backgroundColor = .white
        locationContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundScrollView.addSubview(locationContainerView)
        locationContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        locationContainerView.heightAnchor.constraint(equalToConstant: 380).isActive = true
        locationContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        locationContainerView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor).isActive = true
        
        locationContainerView.addSubview(fullnameLabel)
        locationContainerView.addSubview(fullnameTextField)
        locationContainerView.addSubview(usernameBottomLabel)
        locationContainerView.addSubview(usernameTextField)
        locationContainerView.addSubview(locationLabel)
        locationContainerView.addSubview(locationTextField)
        locationContainerView.addSubview(biobottomLabel)
        locationContainerView.addSubview(bioTextField)
        
        fullnameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35).isActive = true
        fullnameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -35).isActive = true
        fullnameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        fullnameLabel.topAnchor.constraint(equalTo: locationContainerView.topAnchor, constant: 30).isActive = true
        
        fullnameTextField.leftAnchor.constraint(equalTo: fullnameLabel.leftAnchor).isActive = true
        fullnameTextField.rightAnchor.constraint(equalTo: fullnameLabel.rightAnchor).isActive = true
        fullnameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fullnameTextField.topAnchor.constraint(equalTo: fullnameLabel.bottomAnchor, constant: 0).isActive = true
        
        usernameBottomLabel.leftAnchor.constraint(equalTo: fullnameLabel.leftAnchor).isActive = true
        usernameBottomLabel.rightAnchor.constraint(equalTo: fullnameLabel.rightAnchor).isActive = true
        usernameBottomLabel.heightAnchor.constraint(equalTo: fullnameLabel.heightAnchor).isActive = true
        usernameBottomLabel.topAnchor.constraint(equalTo: fullnameTextField.bottomAnchor, constant: 30).isActive = true
        
        usernameTextField.leftAnchor.constraint(equalTo: fullnameLabel.leftAnchor).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: fullnameLabel.rightAnchor).isActive = true
        usernameTextField.heightAnchor.constraint(equalTo: fullnameTextField.heightAnchor).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: usernameBottomLabel.bottomAnchor, constant: 0).isActive = true
        
        locationLabel.leftAnchor.constraint(equalTo: fullnameLabel.leftAnchor).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: fullnameLabel.rightAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalTo: fullnameLabel.heightAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 30).isActive = true
        
        locationTextField.leftAnchor.constraint(equalTo: fullnameLabel.leftAnchor).isActive = true
        locationTextField.rightAnchor.constraint(equalTo: fullnameLabel.rightAnchor).isActive = true
        locationTextField.heightAnchor.constraint(equalTo: fullnameTextField.heightAnchor).isActive = true
        locationTextField.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 0).isActive = true
        
        biobottomLabel.leftAnchor.constraint(equalTo: fullnameLabel.leftAnchor).isActive = true
        biobottomLabel.rightAnchor.constraint(equalTo: fullnameLabel.rightAnchor).isActive = true
        biobottomLabel.heightAnchor.constraint(equalTo: fullnameLabel.heightAnchor).isActive = true
        biobottomLabel.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 30).isActive = true
        
        bioTextField.leftAnchor.constraint(equalTo: fullnameLabel.leftAnchor).isActive = true
        bioTextField.rightAnchor.constraint(equalTo: fullnameLabel.rightAnchor).isActive = true
        bioTextField.heightAnchor.constraint(equalTo: fullnameTextField.heightAnchor).isActive = true
        bioTextField.topAnchor.constraint(equalTo: biobottomLabel.bottomAnchor, constant: 0).isActive = true
        
    }
    
    private func setupBackground() {
        
        view.backgroundColor = StyleGuideManager.profileControllerBackgroundColor
        
    }
    
    fileprivate func setupNavBar() {
        
        navigationItem.title = "Profile"
        
        let closeImage = UIImage(named: AssetName.cross.rawValue)?.withRenderingMode(.alwaysTemplate)
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(handleDismiss))
        closeButton.tintColor = .white
        navigationItem.leftBarButtonItem = closeButton
        
        let saveImage = UIImage(named: AssetName.save.rawValue)?.withRenderingMode(.alwaysTemplate)
        let saveButton = UIBarButtonItem(image: saveImage, style: .plain, target: self, action: #selector(handleUpdate))
        saveButton.tintColor = .white
        navigationItem.rightBarButtonItem = saveButton
    }
    
}
