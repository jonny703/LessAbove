//
//  AuthController.swift
//  LESSABOVE
//
//  Created by John Nik on 9/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import KRProgressHUD

class AuthController: UIViewController, UIGestureRecognizerDelegate {
    
    
    //MARK: set UI
    
    /*
    lazy var agreeTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        
        //MARK: handle text attribute
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let agreeAttributedString = NSMutableAttributedString(string: "By signing up, you are agreeing to our Terms of Service and Privacy Policy", attributes: [NSForegroundColorAttributeName: UIColor.white, NSParagraphStyleAttributeName: style])
        
        agreeAttributedString.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: 38))
        
        let termsRange = NSRange(location: 39, length: 16)
        let termsAttribute = ["terms": "terms of value", NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold), NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue] as [String : Any]
        agreeAttributedString.addAttributes(termsAttribute, range: termsRange)
        
        
        agreeAttributedString.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15)], range: NSRange(location: 55, length: 5))
        
        
        let policyRange = NSRange(location: 60, length: 14)
        let policyAttribute = ["policy": "policy of value", NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold), NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue] as [String : Any]
        agreeAttributedString.addAttributes(policyAttribute, range: policyRange)
        
        
        textView.attributedText = agreeAttributedString
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        textView.isUserInteractionEnabled = true
        textView.addGestureRecognizer(tap)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    */
    
    lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SIGN UP", for: .normal)
        button.backgroundColor = StyleGuideManager.signupButtonColor
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(naviSignupController), for: .touchUpInside)
        return button
    }()
    
    lazy var signinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LOGIN", for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2.5
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(naviLoginController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        KRProgressHUD.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    
}


//MARK: handle tapgesture for terms and policy
/*
extension AuthController {
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        
        let textView = sender.view as! UITextView
        let layoutManager = textView.layoutManager
        
        var location = sender.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        
        let characterIndex = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if characterIndex < textView.textStorage.length {
            // print the character index
            print("character index: \(characterIndex)")
            
            // print the character at the index
            let myRange = NSRange(location: characterIndex, length: 1)
            let substring = (textView.attributedText.string as NSString).substring(with: myRange)
            print("character at index: \(substring)")
            
            // check if the tap location has a certain attribute
            let termsName = "terms"
            let termsValue = textView.attributedText.attribute(termsName, at: characterIndex, effectiveRange: nil) as? String
            
            let policyName = "policy"
            let policyValue = textView.attributedText.attribute(policyName, at: characterIndex, effectiveRange: nil) as? String
            
            if let termsValue = termsValue {
                print("You tapped on \(termsName) and the value is: \(termsValue)")
                
                let agreementController = AgreementController()
                agreementController.controllerStatus = .authController
                agreementController.agreementStatus = .terms
                
                navigationController?.pushViewController(agreementController, animated: true)
                
            } else if let policyValue = policyValue {
                print("You tapped on \(policyName) and the value is: \(policyValue)")
                
                let agreementController = AgreementController()
                agreementController.controllerStatus = .authController
                agreementController.agreementStatus = .policy
                
                navigationController?.pushViewController(agreementController, animated: true)
            }
        }
    }
    
}
 */

//MARK: handle navi contorllers

extension AuthController {
    
    @objc fileprivate func naviSignupController() {
        
        let signupController = SignupController()
        
        navigationController?.pushViewController(signupController, animated: true)
        
    }
    
    @objc fileprivate func naviLoginController() {
        
        let loginController = LoginController()
        navigationController?.pushViewController(loginController, animated: true)
        
    }
    
    func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }

    
}

//MARK: Setup views

extension AuthController {
    
    fileprivate func setupViews() {
        setupNavigationBarAndBackground()
        setupButtons()
//        setupTextViews()
    }
    
    /*
    private func setupTextViews() {
        
        view.addSubview(agreeTextView)
        
        agreeTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        agreeTextView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.8).isActive = true
        agreeTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        agreeTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
    }
    */
    
    private func setupButtons() {
        
        view.addSubview(signinButton)
        view.addSubview(signupButton)
        
        signinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signinButton.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        signinButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signinButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signupButton.bottomAnchor.constraint(equalTo: signinButton.topAnchor, constant: -15).isActive = true
    }
    
    private func setupNavigationBarAndBackground() {
        
        
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        view.setGradientBackgroundUIView(colors: StyleGuideManager.gradientColors)

        
        view.backgroundColor = UIColor(r: 144, g: 187, b: 255, a: 0.6)
        
        let backgroundView = UIImageView()
        backgroundView.image = UIImage(named: AssetName.lessaboveLogo.rawValue)
        backgroundView.alpha = 0.3
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundView)
        
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//
//        let backgroundImageView = UIImageView()
//        backgroundImageView.image = UIImage(named: AssetName.lessaboveIcon.rawValue)
//        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(backgroundImageView)
//        
//        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
//        backgroundImageView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.35).isActive = true
//        backgroundImageView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.35).isActive = true
        
        
    }
    
}

