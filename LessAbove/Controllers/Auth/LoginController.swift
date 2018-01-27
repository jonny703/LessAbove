//
//  LoginController.swift
//  LESSABOVE
//
//  Created by John Nik on 9/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase
import KRProgressHUD

class LoginController: UIViewController {
    
    
    //MARK: set UI
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "LOGIN"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    let passwordTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        let str = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        textField.attributedPlaceholder = str
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .white
        textField.isSecureTextEntry = true
        return textField
        
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LOGIN", for: .normal)
        button.backgroundColor = StyleGuideManager.signupButtonColor
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Forgot your password?", for: .normal)
        button.tintColor  = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.04)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    
    let invalidCommandLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.05)
        label.backgroundColor = UIColor(r: 134, g: 251, b: 236, a: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
        
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

//MARK: handle forgot Password 

extension LoginController {
    @objc func handleForgotPassword() {
        
        let alert = UIAlertController(title: "Forgot password?", message: "Type your email", preferredStyle: .alert)
        
        let OkAction = UIAlertAction(title: "Ok!", style: .default) { (action) in
            KRProgressHUD.show()
            
            let textField = alert.textFields![0]
            textField.placeholder = "1"
            
            if textField.text == "" {
//                ProgressHudHelper.hideLoadingHud()
                KRProgressHUD.dismiss()
                
                self.showAlert(warnigString: "Oops! Write youremail")
            } else {
                
                let checkConnection = RKCommon.checkInternetConnection()
                if !checkConnection {
                    KRProgressHUD.dismiss()
                    self.showErrorAlertWith("Connection Error", message: "Please check your internet connection")
                    return
                }
                
                Auth.auth().sendPasswordReset(withEmail: textField.text!, completion: { (error) in
                    
                    if error != nil {
//                        ProgressHudHelper.hideLoadingHud()
                        KRProgressHUD.dismiss()
                        self.showAlert(warnigString: "Oops! Invalid email")
                    } else {
//                        ProgressHudHelper.hideLoadingHud()
                        KRProgressHUD.dismiss()
                        self.showAlert(warnigString: "Please check your email")
                    }
                })
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addTextField { (textField: UITextField) in
            
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Email"
            textField.clearButtonMode = .whileEditing
            
        }
        
        alert.addAction(OkAction)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(warnigString: String) {
        
        view.addSubview(invalidCommandLabel)
        
        invalidCommandLabel.text = warnigString
        
        invalidCommandLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        invalidCommandLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fadeViewInThenOut(view: invalidCommandLabel, delay: 3)
        
    }
    
    func fadeViewInThenOut(view : UIView, delay: TimeInterval) {
        
        let animationDuration = 0.25
        
        // Fade in the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 1
        }) { (Bool) -> Void in
            
            // After the animation completes, fade out the view after a delay
            
            UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseInOut, animations: { () -> Void in
                view.alpha = 0
            }, completion: nil)
        }
    }

}

//MARK: handle login

extension LoginController {
    
    @objc func handleLogin() {
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
        
        
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not invalid")
//            ProgressHudHelper.hideLoadingHud()
            KRProgressHUD.dismiss()
            showAlertMessage(vc: self, titleStr: "Invalid email & password!", messageStr: "Write correct information")
            
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
//                ProgressHudHelper.hideLoadingHud()
                KRProgressHUD.dismiss()
                showAlertMessage(vc: self, titleStr: "Invalid email & password!", messageStr: "Write correct information")
                return
            }
            if let user = Auth.auth().currentUser {
                

                if !user.isEmailVerified {
                    
                    let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \(email).", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                        (_) in
                        user.sendEmailVerification(completion: nil)
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    
                    alertVC.addAction(alertActionOkay)
                    alertVC.addAction(alertActionCancel)
                    self.present(alertVC, animated: true, completion: nil)
//                    ProgressHudHelper.hideLoadingHud()
                    KRProgressHUD.dismiss()
                    
                } else {
                    
                    KRProgressHUD.dismiss()
//                    ProgressHudHelper.hideLoadingHud()
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        })
        
        
    }
}


//MARK: check invalid

extension LoginController {
    fileprivate func checkInvalid() -> Bool {
        if (emailTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Email!", messageStr: "ex: Anders703@oulook.com")
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

extension LoginController {
    
    fileprivate func setupViews() {
        setupNavigationBarAndBackground()
        setupTextFields()
        setupButtons()
        setupBackButton()
    }
    
    private func setupTextFields() {
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        emailTextField.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0).isActive = true
        
    }

    
    private func setupButtons() {
        view.addSubview(loginButton)
        view.addSubview(forgotPasswordButton)
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        
        forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotPasswordButton.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10).isActive = true
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
//        navigationItem.title = "Login"
//        view.backgroundColor = .white
//        
//        navigationController?.navigationBar.setGradientBackground(colors: StyleGuideManager.gradientColors)
//        
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        
//        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissController))
//        backButton.tintColor = .white
//        self.navigationItem.leftBarButtonItem = backButton

    }
    @objc func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

