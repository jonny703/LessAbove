//
//  Alerts.swift
//  LESSABOVE
//
//  Created by John Nik on 9/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation
import UIKit


typealias AlertActionHandler = (UIAlertAction)->()

typealias AlertPresentCompletion = ()->()

extension UIViewController{
    func showErrorAlert(_ title:String? = nil, message:String, action:(AlertActionHandler)? = nil, completion:AlertPresentCompletion? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: action)
        alert.addAction(okAction)
        present(alert, animated: true, completion: completion)
    }
    
    func showErrorAlertWith(_ title:String, message: String, action:(AlertActionHandler)? = nil, completion:AlertPresentCompletion? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: action)
        alert.addAction(okAction)
        present(alert, animated: true, completion: completion)
    }
    
    func showErrorAlertWithOKCancel(_ title:String? = nil, message:String, action:(AlertActionHandler)? = nil, completion:AlertPresentCompletion? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: action)
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: completion)
    }
    
    func showErrorAlertActionStringsWith(_ title:String? = nil, message:String, okActionStr: String, cancelActionStr: String, action:(AlertActionHandler)? = nil,  completion:AlertPresentCompletion? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionStr, style: .default, handler: action)
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: cancelActionStr, style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: completion)
    }
    
    func showActionSheetWith(_ title:String? = nil, message: String, galleryAction:(AlertActionHandler)? = nil, cameraAction:(AlertActionHandler)? = nil, completion:AlertPresentCompletion? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: "Choose a Picture", style: .default, handler: galleryAction)
        let cameraAction = UIAlertAction(title: "Take a Picture", style: .default, handler: cameraAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: completion)
        
    }
    
    func showActionSheetWithCustomString(_ title: String? = nil, message: String, firstActionTitel: String, secondActionTitel: String, firstAction: (AlertActionHandler)? = nil, secondAction: (AlertActionHandler)? = nil, completion: AlertPresentCompletion? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: firstActionTitel, style: .default, handler: firstAction)
        let cameraAction = UIAlertAction(title: secondActionTitel, style: .default, handler: secondAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: completion)
    }

}



func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
    
    
    let TitleString = NSAttributedString(string: titleStr, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.04)])
    let MessageString = NSAttributedString(string: messageStr, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.03)])
    
    let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert);
    let action = UIAlertAction(title: "Ok!", style: .default, handler: nil);
    alert.addAction(action)
    
    alert.setValue(TitleString, forKey: "attributedTitle")
    alert.setValue(MessageString, forKey: "attributedMessage")
    vc.present(alert, animated: true, completion: nil)
}

typealias OkHandler = (_ thingAmount: String) -> Void

func showAlertMessageWhenLending(vc: UIViewController, titleStr: String, messageStr: String) -> Void {
    
    let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: .alert)
    
    let OkAction = UIAlertAction(title: "Ok!", style: .default) { (action) in
        let textField = alert.textFields![0]
        print(textField.text!)
        
    }
    
    let cancel = UIAlertAction(title: "avbryt", style: .destructive, handler: nil)
    
    alert.addTextField { (textField: UITextField) in
        
        textField.keyboardAppearance = .dark
        textField.keyboardType = .default
        textField.autocorrectionType = .default
        textField.placeholder = "Type amount"
        textField.clearButtonMode = .whileEditing
        
    }
    
    alert.addAction(OkAction)
    alert.addAction(cancel)
    
    vc.present(alert, animated: true, completion: nil)
    
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
        },
                       completion: nil)
    }
}

