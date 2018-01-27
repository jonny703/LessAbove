//
//  ProfileController.swift
//  LESSABOVE
//
//  Created by John Nik on 9/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase
import KRProgressHUD

protocol ProfileControllerDelegate {
    
    func reloadProfileData()
    
}

class ProfileController: UIViewController {
    
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
        button.setTitle("EDIT YOUR PROFILE", for: .normal)
        button.backgroundColor = StyleGuideManager.editProfileButtonColor
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goingToEditProfileController), for: .touchUpInside)
        return button
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Share your Location"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
        
    }

}

//MARK: handle profilecontrollerDelegate, reload profileData
extension ProfileController: ProfileControllerDelegate {
    func reloadProfileData() {
        self.fetchUserProfile()
    }
}

//MARK: handle setting, going to eidtprofileController

extension ProfileController {
    
    @objc func handleSetting() {
        let settingController = SettingController(style: .grouped)
//        self.navigationController?.pushViewController(settingController, animated: true)
        
        let navController = UINavigationController(rootViewController: settingController)
        self.present(navController, animated: true, completion: nil)
        
        navController.navigationBar.setGradientBackground(colors: StyleGuideManager.gradientColors)

        navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    @objc fileprivate func goingToEditProfileController() {
        let editProfileController = EditProfileController()
        editProfileController.profileControllerDelegate = self
        let navController = UINavigationController(rootViewController: editProfileController)
        self.present(navController, animated: false, completion: nil)
        navController.navigationBar.setGradientBackground(colors: StyleGuideManager.gradientColors)
        
        navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

    }
}

//MARK: fetch user profile

extension ProfileController {
    
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
                
//                self.usernameTextField.text = dictionary["username"] as? String
                self.usernameLabel.text = dictionary["username"] as? String
//                self.fullnameTextField.text = dictionary["fullname"] as? String
                //                self.emailTextField.text = dictionary["email"] as? String
                
                if let location = dictionary["location"] as? String {
                    
                    if location != "" {
                        self.locationLabel.text = location
                    }
                    
                    
                }
                
                if let bio = dictionary["bio"] as? String {
                    
                    if bio != "" {
//                        self.bioTextField.text = bio
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


//MARK: setup background and views

extension ProfileController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupProfileStuff()
        setupLocationView()
    }
    
    private func setupProfileStuff() {
        
        view.addSubview(backgroundImageView)
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(bioLabel)
        view.addSubview(editProfileButton)
        
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: DEVICE_HEIGHT * 1.7 / 3).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
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
        
        editProfileButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        editProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editProfileButton.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 15).isActive = true
        
        
        
    }
    
    private func setupLocationView() {
        let locationContainerView = UIView()
        locationContainerView.backgroundColor = .white
        locationContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(locationContainerView)
        locationContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        locationContainerView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        locationContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        locationContainerView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor).isActive = true
        
        let locationTitelLabel = UILabel()
        locationTitelLabel.text = "Location"
        locationTitelLabel.textColor = StyleGuideManager.editProfileButtonColor
        locationTitelLabel.textAlignment = .left
        locationTitelLabel.font = UIFont.systemFont(ofSize: 16)
        locationTitelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        locationContainerView.addSubview(locationTitelLabel)
        
        locationTitelLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        locationTitelLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        locationTitelLabel.leftAnchor.constraint(equalTo: locationContainerView.leftAnchor, constant: 10).isActive = true
        locationTitelLabel.bottomAnchor.constraint(equalTo: locationContainerView.bottomAnchor, constant: -45).isActive = true
        
        locationContainerView.addSubview(locationLabel)
        
        locationLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        locationLabel.topAnchor.constraint(equalTo: locationContainerView.topAnchor, constant: 45).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: locationTitelLabel.leftAnchor).isActive = true

    }
    
    private func setupBackground() {
        
        view.backgroundColor = StyleGuideManager.profileControllerBackgroundColor
        
    }
    
    fileprivate func setupNavBar() {
        
        let image = UIImage(named: AssetName.setting.rawValue)
        
        let settingButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleSetting))
        settingButton.tintColor = .white
        self.tabBarController?.navigationItem.rightBarButtonItem = settingButton
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        
    }
    
}
