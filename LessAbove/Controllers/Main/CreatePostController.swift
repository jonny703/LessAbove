//
//  CreateContentController.swift
//  LESSABOVE
//
//  Created by John Nik on 9/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase
import KRProgressHUD


class CreatePostController: UIViewController {
    
    var hypeDatesControllerDelegate: HypeDatesControllerDelegate?
    
    let cellId = "cellId"
    let linkCellId = "linkCellId"
    
    var postImageTableViewConstraint: NSLayoutConstraint!
    var postLinkTableViewConstraint: NSLayoutConstraint!
    fileprivate var imageUrls: [String] = [""]
    fileprivate var links: [String] = [""]
    fileprivate var selectedCellIndex: Int?
    
    var selectedPostChildName = String()
    fileprivate var isSelectedPhotos: [Bool] = [false]
    
    var datePicker = GMDatePicker()
    var dateFormatter = DateFormatter()
    
    var backgroundScrollViewConstraint: NSLayoutConstraint?
    
    //vars for image zooming
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    
    lazy var postImageTableView: UITableView = {
        var tableView = UITableView();
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        return tableView;
    }()
    
    lazy var postLinkTableView: UITableView = {
        var tableView = UITableView();
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        return tableView;
    }()
    
    let backgroundScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.alwaysBounceVertical = true
        scrollView.contentSize = CGSize(width: DEVICE_WIDTH, height: DEVICE_HEIGHT)
        return scrollView
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "wed"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDatePicker)))
        return label
    }()
    
    let seperateDateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        let str = NSAttributedString(string: "Type title here", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        textField.attributedPlaceholder = str
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .white
        return textField
        
    }()
    
    let imageSourceTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        let str = NSAttributedString(string: "Type Image Source here", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        textField.attributedPlaceholder = str
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .white
        return textField
        
    }()
    
    let imageUrlTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        let str = NSAttributedString(string: "Type Link here", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        textField.attributedPlaceholder = str
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .white
        return textField
        
    }()
    
    let priceTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        let str = NSAttributedString(string: "Type Price($) here", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        textField.attributedPlaceholder = str
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .white
        textField.keyboardType = .decimalPad
        return textField
        
    }()
    
    let styleCodeTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        let str = NSAttributedString(string: "Type Style Code here", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.keyboardType = .numbersAndPunctuation
        textField.attributedPlaceholder = str
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .white
        
        return textField
        
    }()
    
    let colorSchemeTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        let str = NSAttributedString(string: "Type Color Scheme here", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        textField.attributedPlaceholder = str
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .white
        return textField
        
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setupViews()
        setupKeyboardObservers()
    }

}

//MARK: handle tableview delegate
extension CreatePostController: UITableViewDelegate, UITableViewDataSource, PostImageCellDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == postImageTableView {
            return imageUrls.count
        } else {
            return links.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == postImageTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostImageCell
            cell.postImageCellDelegate = self
            cell.createPostController = self
            cell.selectedIndex = indexPath.row
            cell.postImageCellStatus = .createPost
            
            self.selectedCellIndex = indexPath.row
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: linkCellId, for: indexPath) as! PostLinkTextFieldCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == postImageTableView {
            return IMAGE_HEIGHT
        } else {
            return TEXTFEILD_HEIGHT
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == postImageTableView {
            
            if self.imageUrls.count == 1 {
                self.showErrorAlertWith("Delete Error!", message: "You should add one image at least")
            } else {
                self.showErrorAlertWithOKCancel("Are you sure you want to delete this image?", message: "", action: { (action) in
                    self.isSelectedPhotos.remove(at: indexPath.row)
                    self.imageUrls.remove(at: indexPath.row)
                    self.postImageTableViewConstraint.constant -= IMAGE_HEIGHT
                    self.backgroundScrollView.contentSize.height -= IMAGE_HEIGHT
                    self.postImageTableView.reloadData()
                }, completion: nil)
            }
            
            
        } else {
            
            if self.links.count == 1 {
                self.showErrorAlertWith("Delete Error!", message: "You should add one link at least")
            } else {
                self.showErrorAlertWithOKCancel("Are you sure you want to delete?", message: "", action: { (action) in
                    self.links.remove(at: indexPath.row)
                    self.postLinkTableViewConstraint.constant -= TEXTFEILD_HEIGHT
                    self.backgroundScrollView.contentSize.height -= TEXTFEILD_HEIGHT
                    self.postLinkTableView.reloadData()
                }, completion: nil)
            }
        }
    }
    
    //postImageDelegate
    func didClickAddPhoto(selectedIndex: Int) {
        self.selectedCellIndex = selectedIndex
        self.handleSelectPostImageView()
    }
    
    func didClickDeletePhoto(selectedIndex: Int) {
        
        self.showErrorAlertWithOKCancel("Are you sure you want to delete this image?", message: "", action: { (action) in
            self.selectedCellIndex = selectedIndex
            self.handleDeletePostImageView()
        }, completion: nil)
        
        
    }
    
}

//MARK: - handleKeyboard
extension CreatePostController {
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

//MARK: uiImagePickerDelegate, handle post Image

extension CreatePostController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc fileprivate func handleDeletePostImageView() {
        
        let indexPath = IndexPath(row: self.selectedCellIndex!, section: 0)
        let postImageCell = self.postImageTableView.cellForRow(at: indexPath) as! PostImageCell
        postImageCell.postImageView.image = nil
        postImageCell.addPictureButton.isHidden = false
        postImageCell.deletePictureButton.isHidden = true
        self.isSelectedPhotos[self.selectedCellIndex!] = false
    }
    
    @objc func handleSelectPostImageView() {
        
        self.showActionSheetWith("What would you like to?", message: "", galleryAction: { (galleryAction) in
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.sourceType = .savedPhotosAlbum
            
            self.present(picker, animated: true, completion: nil)

        }, cameraAction: { (cameraAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                
                
                self.present(picker, animated: true, completion: nil)
            } else {
                self.noCamera()
            }
        }, completion: nil)
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
//            postImageView.image = selectedImage
            
            let indexPath = IndexPath(row: self.selectedCellIndex!, section: 0)
            let postImageCell = self.postImageTableView.cellForRow(at: indexPath) as! PostImageCell
            postImageCell.postImageView.image = selectedImage
            postImageCell.addPictureButton.isHidden = true
            postImageCell.deletePictureButton.isHidden = false
            
            self.isSelectedPhotos[self.selectedCellIndex!] = true
        }
        
        dismiss(animated: true, completion: nil)
        
        self.handlePostImage()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
}



//MARK: handle calendar
extension CreatePostController: GMDatePickerDelegate {
    
    func gmDatePicker(_ gmDatePicker: GMDatePicker, didSelect date: Date){
        print(date)
        
        print(dateFormatter.string(from: date))
        
        dateLabel.text = dateFormatter.string(from: date)
    }
    func gmDatePickerDidCancelSelection(_ gmDatePicker: GMDatePicker) {
        
    }
    
    func setupDatePicker() {
        
        dateFormatter.dateFormat = "E, MMM d, yyyy"
        
        datePicker.delegate = self
        
        datePicker.config.startDate = Date()
        
        datePicker.config.animationDuration = 0.5
        
        datePicker.config.cancelButtonTitle = "Cancel"
        datePicker.config.confirmButtonTitle = "Confirm"
        
        datePicker.config.contentBackgroundColor = StyleGuideManager.gradientSecondColor
        datePicker.config.headerBackgroundColor = StyleGuideManager.gradientFirstColor
        
        datePicker.config.confirmButtonColor = UIColor.white
        datePicker.config.cancelButtonColor = UIColor.white
        
    }
    @objc fileprivate func handleDatePicker() {
        
        self.imageUrlTextField.resignFirstResponder()
        self.priceTextField.resignFirstResponder()
        self.priceTextField.resignFirstResponder()
        self.styleCodeTextField.resignFirstResponder()
        self.colorSchemeTextField.resignFirstResponder()
        self.imageSourceTextField.resignFirstResponder()
        
        datePicker.show(inVC: self)
    }
}


//MARK: handle dismiss, save profile
extension CreatePostController {
    
    @objc fileprivate func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func handlePost() {
        
        if !checkInvalid() {
            return
        }
        
        KRProgressHUD.show()
        
        let checkConnection = RKCommon.checkInternetConnection()
        if !checkConnection {
            KRProgressHUD.dismiss()
            self.showErrorAlertWith("Connection Error", message: "Please check your internet connection")
            return
        }
        
        self.sendMessageWithProperties()
    }
    
    fileprivate func handlePostImage() {
        
        KRProgressHUD.show()
        
        let checkConnection = RKCommon.checkInternetConnection()
        if !checkConnection {
            KRProgressHUD.dismiss()
            self.showErrorAlertWith("Fail to upload image to server!", message: "Please check your internet connection")
            return
        }
        
        let indexPath = IndexPath(row: self.selectedCellIndex!, section: 0)
        let postImageCell = self.postImageTableView.cellForRow(at: indexPath) as! PostImageCell
        
//        self.postImageTableView.isUserInteractionEnabled = false
        
        if let postImage = postImageCell.postImageView.image {
            var image = postImage
            
            if postImage.size.width > 400 {
                image = postImage.resized(toWidth: 400.0)!
            }
            
            uploadToFirebaseStorageUsingImage(image: image, completiion: { (imageUrl) in
                
//                self.sendMessageWithImageUrl(imageUrl: imageUrl, image: image)
                self.imageUrls[self.selectedCellIndex!] = imageUrl
                KRProgressHUD.dismiss()
                
            })
        }
        
        
    }
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage, completiion: @escaping (_ imageUrl: String) -> ()) {
        
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("post_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image", error!)
                    self.showErrorAlertWith("Sorry!, Something went wrong", message: "Please try again later")
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    completiion(imageUrl)
                    
                }
            })
        }
    }
    
    private func sendMessageWithProperties() {
        
        let childPost = self.selectedPostChildName == "all" ? "other" : self.selectedPostChildName
        
        let ref = Database.database().reference().child("posts").child(childPost)
        let allRef = Database.database().reference().child("posts").child("all")
        let childRef = ref.childByAutoId()
        let allChildRef = allRef.child(childRef.key)
        
        let title = self.titleTextField.text
        let styleCode = self.styleCodeTextField.text
        let colorScheme = self.colorSchemeTextField.text
        let price = self.priceTextField.text
        let imageSource = self.imageSourceTextField.text
        let dateStr = self.dateLabel.text
        
        for i in 0 ..< links.count {
            let indexPath = IndexPath(row: i, section: 0)
            let postLinkCell = self.postLinkTableView.cellForRow(at: indexPath) as! PostLinkTextFieldCell
            if let text = postLinkCell.linkTextField.text {
                if self.links.count == 1 {
                    self.links[i] = "Link: " + text
                } else {
                    self.links[i] = "Link\(i + 1): " + text
                }
                
            }
        }
        
        let date = dateFormatter.date(from: dateStr!)
        let timestamp = date!.timeIntervalSince1970 as NSNumber
        
        let values = ["postId": childRef.key, "title": title!, "styleCode": styleCode!, "colorScheme": colorScheme!, "price": price!, "imageSource": imageSource!, "date": dateStr!, "timestamp": timestamp, "links": self.links, "imageUrls": self.imageUrls] as [String: AnyObject]
        childRef.updateChildValues(values) { (error, childRef) in
            
            if error != nil {
                print(error!)
                KRProgressHUD.dismiss()
                self.showErrorAlertWith("Sorry!, Something went wrong", message: "Please try again later")
                return
            }
            
            allChildRef.updateChildValues(values) { (error, childRef) in
                
                if error != nil {
                    print(error!)
                    KRProgressHUD.dismiss()
                    self.showErrorAlertWith("Sorry!, Something went wrong", message: "Please try again later")
                    return
                }
                
                KRProgressHUD.dismiss()
                self.dismiss(animated: true, completion: {
                    self.hypeDatesControllerDelegate?.reloadContentsData()
                })
                
            }
        }
    }

}

//MARK: check invalid

extension CreatePostController {
    
    private func showAlertForEmptyErrorWith(index: Int, type: ErrorStatus) {
        var alertMessage = ""
        if index == 0 {
            if type == .image {
                alertMessage = "Please Select 1st Image"
            } else if type == .emptyLink {
                alertMessage = "Please Type 1st Link"
            } else {
                alertMessage = "Please Type 1st valid Link"
            }
        } else if index == 1 {
            if type == .image {
                alertMessage = "Please Select 2nd Image"
            } else if type == .emptyLink {
                alertMessage = "Please Type 2nd Link"
            } else {
                alertMessage = "Please Type 2nd valid Link"
            }
        } else if index == 2 {
            if type == .image {
                alertMessage = "Please Select 3rd Image"
            } else if type == .emptyLink {
                alertMessage = "Please Type 3rd Link"
            } else {
                alertMessage = "Please Type 3rd valid Link"
            }
        } else {
            if type == .image {
                alertMessage = "Please Select \(String(index + 1))th Image"
            } else if type == .emptyLink {
                alertMessage = "Please Type \(String(index + 1))th Link"
            } else {
                alertMessage = "Please Type \(String(index + 1))th valid Link"
            }
        }
        
        self.showErrorAlert(message: alertMessage)
    }
    
    fileprivate func checkInvalid() -> Bool {
        
        if isSelectedPhotos.count > 0 {
            
            for i in 0 ..< isSelectedPhotos.count {
                
                if isSelectedPhotos[i] == false {
                    self.showAlertForEmptyErrorWith(index: i, type: .image)
                    return false
                }
                
            }
            
        } else {
            self.showErrorAlert(message: "Please Select One Image at least")
            return false
        }
        
        if (titleTextField.text?.isEmpty)! {
            self.showErrorAlert(message: "Please Type Title")
            return false
        }
        
        if (styleCodeTextField.text?.isEmpty)! {
            self.showErrorAlert(message: "Please Type Style Code")
            return false
        }
        if (colorSchemeTextField.text?.isEmpty)! {
            self.showErrorAlert(message: "Please Type Color Scheme")
            return false
        }
        if (priceTextField.text?.isEmpty)! {
            self.showErrorAlert(message: "Please Type Price")
            return false
        }
        if (imageSourceTextField.text?.isEmpty)! {
            self.showErrorAlert(message: "Please Type Image Source")
            return false
        }
        
        if self.links.count > 0 {
            
            for i in 0 ..< links.count {
                let indexPath = IndexPath(row: i, section: 0)
                let postLinkCell = self.postLinkTableView.cellForRow(at: indexPath) as! PostLinkTextFieldCell
                if (postLinkCell.linkTextField.text?.isEmpty)! {
                    self.showAlertForEmptyErrorWith(index: i, type: .emptyLink)
                    return false
                } else {
                    let urlStr = postLinkCell.linkTextField.text
                    let isUrl = verifyUrl(urlString: urlStr)
                    if !(isUrl) {
                        self.showAlertForEmptyErrorWith(index: i, type: .invalidLink)
                        return false
                    }
                }
            }
            
        } else {
            self.showErrorAlert(message: "Please type One Link at least")
            return false
        }
        
        return true
    }
    
}

//MARK: handle addPicture
extension CreatePostController {
    
    @objc fileprivate func handleAddPictureAndLinks() {
        
        self.showActionSheetWithCustomString("What would you like to add?", message: "", firstActionTitel: "Add Picture", secondActionTitel: "Add Link", firstAction: { (pictureAction) in
            
            self.handleAddPicture()
            
        }, secondAction: { (linkAction) in
            
            self.handleAddLink()
            
        }, completion: nil)
        
    }
    
    private func handleAddPicture() {
        self.imageUrls.append("")
        self.isSelectedPhotos.append(false)
        postImageTableViewConstraint.constant += IMAGE_HEIGHT
        backgroundScrollView.contentSize.height += IMAGE_HEIGHT
        self.postImageTableView.reloadData()
        KRProgressHUD.showSuccess()
    }
    
    private func handleAddLink() {
        self.links.append("")
        postLinkTableViewConstraint.constant += TEXTFEILD_HEIGHT
        backgroundScrollView.contentSize.height += TEXTFEILD_HEIGHT
        self.postLinkTableView.reloadData()
        KRProgressHUD.showSuccess()
    }
    
}

//MARK: handle image zoom in and out
//MARK: - handleImage, Video
extension CreatePostController {
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        
        if let imageView = tapGesture.view as? UIImageView {
            
            //PRO Tip: don't perform a lot of custom logic inside of a view class
            
            self.performZoomingForStartingImageView(startingImageView: imageView)
            
            
        }
        
        
    }
    
    //my custom zooming logic
    
    func performZoomingForStartingImageView(startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.clear
        zoomingImageView.image = startingImageView.image
        
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 1
                
                let height = (self.startingImageView?.image?.size.height)! / (self.startingImageView?.image?.size.width)! * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
                
            }, completion: { (completed) in
                
                //                zoomOutImageView.removeFromSuperview()
                
            })
        }
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        
        if let zoomOutImageView = tapGesture.view {
            
            //need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.layer.masksToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                //                self.inputContainerView.alpha = 1
                
            }, completion: { (completed) in
                
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
                
            })
        }
    }
}

//MARK: setup background and views

extension CreatePostController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupNavBar()
        setupPostViews()
    }
    

    
    private func setupPostViews() {
        
        
        
        view.addSubview(backgroundScrollView)
        
        backgroundScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundScrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        backgroundScrollViewConstraint = backgroundScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        backgroundScrollViewConstraint?.isActive = true
        
        backgroundScrollView.addSubview(postImageTableView)
        backgroundScrollView.addSubview(dateLabel)
        backgroundScrollView.addSubview(seperateDateView)
        backgroundScrollView.addSubview(titleTextField)
        backgroundScrollView.addSubview(styleCodeTextField)
        backgroundScrollView.addSubview(colorSchemeTextField)
        backgroundScrollView.addSubview(priceTextField)
        backgroundScrollView.addSubview(imageSourceTextField)
        backgroundScrollView.addSubview(postLinkTableView)
        
        postImageTableView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH).isActive = true
        postImageTableView.topAnchor.constraint(equalTo: backgroundScrollView.topAnchor, constant: 0).isActive = true
        postImageTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postImageTableViewConstraint = postImageTableView.heightAnchor.constraint(equalToConstant: IMAGE_HEIGHT)
        postImageTableViewConstraint.isActive = true
        
        postImageTableView.register(PostImageCell.self, forCellReuseIdentifier: cellId)
        
        dateLabel.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: postImageTableView.bottomAnchor, constant: 10).isActive = true
        
        let date = Date()
        dateLabel.text = dateFormatter.string(from: date)
        
        seperateDateView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        seperateDateView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        seperateDateView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        seperateDateView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 0).isActive = true
        
        titleTextField.widthAnchor.constraint(equalTo: dateLabel.widthAnchor).isActive = true
        titleTextField.heightAnchor.constraint(equalTo: dateLabel.heightAnchor).isActive = true
        titleTextField.centerXAnchor.constraint(equalTo: dateLabel.centerXAnchor).isActive = true
        titleTextField.topAnchor.constraint(equalTo: seperateDateView.bottomAnchor, constant: 0).isActive = true
        
        styleCodeTextField.widthAnchor.constraint(equalTo: titleTextField.widthAnchor).isActive = true
        styleCodeTextField.heightAnchor.constraint(equalTo: titleTextField.heightAnchor).isActive = true
        styleCodeTextField.centerXAnchor.constraint(equalTo: titleTextField.centerXAnchor).isActive = true
        styleCodeTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 0).isActive = true
        
        colorSchemeTextField.widthAnchor.constraint(equalTo: titleTextField.widthAnchor).isActive = true
        colorSchemeTextField.heightAnchor.constraint(equalTo: titleTextField.heightAnchor).isActive = true
        colorSchemeTextField.centerXAnchor.constraint(equalTo: titleTextField.centerXAnchor).isActive = true
        colorSchemeTextField.topAnchor.constraint(equalTo: styleCodeTextField.bottomAnchor, constant: 0).isActive = true
        
        priceTextField.widthAnchor.constraint(equalTo: titleTextField.widthAnchor).isActive = true
        priceTextField.heightAnchor.constraint(equalTo: titleTextField.heightAnchor).isActive = true
        priceTextField.centerXAnchor.constraint(equalTo: titleTextField.centerXAnchor).isActive = true
        priceTextField.topAnchor.constraint(equalTo: colorSchemeTextField.bottomAnchor, constant: 0).isActive = true
        
        imageSourceTextField.widthAnchor.constraint(equalTo: titleTextField.widthAnchor).isActive = true
        imageSourceTextField.heightAnchor.constraint(equalTo: titleTextField.heightAnchor).isActive = true
        imageSourceTextField.centerXAnchor.constraint(equalTo: titleTextField.centerXAnchor).isActive = true
        imageSourceTextField.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 0).isActive = true
        
        postLinkTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        postLinkTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postLinkTableView.topAnchor.constraint(equalTo: imageSourceTextField.bottomAnchor, constant: 0).isActive = true
        postLinkTableViewConstraint = postLinkTableView.heightAnchor.constraint(equalToConstant: TEXTFEILD_HEIGHT)
        postLinkTableViewConstraint.isActive = true
        
        postLinkTableView.register(PostLinkTextFieldCell.self, forCellReuseIdentifier: linkCellId)
    }
    
    private func setupBackground() {
        
//        view.backgroundColor = .white
        
        view.setGradientBackgroundUIView(colors: StyleGuideManager.gradientColors)
        
    }
    
    fileprivate func setupNavBar() {
        
        navigationItem.title = "Create Content"
        
        let closeImage = UIImage(named: AssetName.cross.rawValue)?.withRenderingMode(.alwaysTemplate)
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(handleDismiss))
        closeButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = closeButton
        
        let postImage = UIImage(named: AssetName.done.rawValue)?.withRenderingMode(.alwaysTemplate)
        let postButton = UIBarButtonItem(image: postImage, style: .plain, target: self, action: #selector(handlePost))
        postButton.tintColor = .white
        
        let addPictureImage = UIImage(named: AssetName.addPicture.rawValue)?.withRenderingMode(.alwaysTemplate)
        let addPictureButton = UIBarButtonItem(image: addPictureImage, style: .plain, target: self, action: #selector(handleAddPictureAndLinks))
        addPictureButton.tintColor = .white
        
        navigationItem.rightBarButtonItems = [postButton, addPictureButton]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
}
