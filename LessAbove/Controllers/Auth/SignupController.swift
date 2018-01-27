//
//  SignupController.swift
//  LESSABOVE
//
//  Created by John Nik on 9/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase
import KRProgressHUD

class SignupController: UIViewController {
    
    
    //MARK: set UI
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        let str = NSAttributedString(string: "Full Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.attributedPlaceholder = str
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .white
        return textField
        
    }()
    
    let emailTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        let str = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        textField.attributedPlaceholder = str
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .white

        return textField
        
    }()
    
    let usernameTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        let str = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        textField.attributedPlaceholder = str
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .white

        return textField
        
    }()
    
    let passwordTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        let str = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        textField.attributedPlaceholder = str
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .white
        textField.isSecureTextEntry = true
        return textField
        
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SIGN UP", for: .normal)
        button.backgroundColor = StyleGuideManager.signupButtonColor
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    let backButton: UIButton = {
        
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.back.rawValue)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        button.tintColor = .white
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

//MARK handle signup

extension SignupController {
    @objc func handleSignup() {
        if !(checkInvalid()) {
            return
        }
        
        KRProgressHUD.show()
        
        let checkConnection = RKCommon.checkInternetConnection()
        if !checkConnection {
            KRProgressHUD.dismiss()
            self.showErrorAlertWith("Connection Error", message: "Please check your internet connection")
            return
        }
        
        
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let fullname = nameTextField.text, let username = usernameTextField.text  else {
            
            KRProgressHUD.dismiss()
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                
                showAlertMessage(vc: self, titleStr: "Fail!", messageStr: "Write correct information")
                
                print(error!)
                
                KRProgressHUD.dismiss()
                
                return
            } else {
                
                
                guard let uid = user?.uid else {
                    KRProgressHUD.dismiss()
                    return
                }
                
                //successfluly authenticated user
                
                let values = ["username": username, "email": email, "fullname": fullname]
                
                self.registerUserIntoDatabaseWithUid(uid: uid, values: values as [String : AnyObject])
            }
        })
    }
    
    private func registerUserIntoDatabaseWithUid(uid: String, values: [String: AnyObject]) {
        
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)
        
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                KRProgressHUD.dismiss()
                showAlertMessage(vc: self, titleStr: "Something went wrong!", messageStr: "Try again later")
                return
            }
            KRProgressHUD.dismiss()
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                
                
                self.showErrorAlert("Success!", message: "Please check your email", action: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }, completion: nil)
            })
            
        })
    }
}

//MARK: check invalid

extension SignupController {
    fileprivate func checkInvalid() -> Bool {
        
        if (nameTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Full Name!", messageStr: "ex: Saulius Anders")
            return false
        }
        if (emailTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Email!", messageStr: "ex: Anders703@oulook.com")
            return false
        }
        
        if (usernameTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Username!", messageStr: "ex: Anders703@oulook.com")
            return false
        }
        
        if (passwordTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Password!", messageStr: "t.ex: Belle@703")
            return false
        }
        return true
    }

}


//MARK: Setup views

extension SignupController {
    
    fileprivate func setupViews() {
        setupNavigationBarAndBackground()
        setupTextFields()
        setupButtons()
        setupButtons()
        setupBackButton()
    }
    
    private func setupTextFields() {
        
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        
        nameTextField.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        
        emailTextField.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 0).isActive = true
        
        usernameTextField.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 0).isActive = true
        
    }
    
    private func setupButtons() {
        view.addSubview(signupButton)
        
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signupButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
    }
    
    private func setupBackButton() {
        view.addSubview(backButton)
        
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    }
    
    private func setupNavigationBarAndBackground() {
        
        view.setGradientBackgroundUIView(colors: StyleGuideManager.gradientColors)
        
        
        
        view.addSubview(titleLabel)
        
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        
//        navigationController?.isNavigationBarHidden = false
//        navigationItem.title = "Sign Up"
//        navigationController?.navigationBar.barTintColor = UIColor(r: 85, g: 113, b: 153, a: 0.6)
//        navigationController?.navigationBar.setGradientBackground(colors: StyleGuideManager.gradientColors)

        
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        view.backgroundColor = .white
//        
//        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissController))
//        backButton.tintColor = .white
//        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }
    
}


