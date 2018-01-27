//
//  StyleGuideManager.swift
//  LESSABOVE
//
//  Created by John Nik on 9/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation
import UIKit


public class StyleGuideManager {
    private init(){}
    
    static let sharedInstance : StyleGuideManager = {
        let instance = StyleGuideManager()
        return instance
    }()
    
    //Gradient Colors
    static let gradientFirstColor = UIColor(withNumbersFor: 116, green: 116, blue: 186)
    static let gradientSecondColor = UIColor(withNumbersFor: 77, green: 136, blue: 194)
    
    static let gradientColors = [StyleGuideManager.gradientFirstColor, StyleGuideManager.gradientSecondColor]
    
    
    //Buttons Colors
    static let signupButtonColor = UIColor(r: 1, g: 128, b: 255, a: 1)
    static let editProfileButtonColor = UIColor(r: 105, g: 140, b: 208)
    
    //dateView colors
    static let dateViewColor = UIColor(r: 60, g: 62, b: 74)
    static let profileBackgroundColor = UIColor(r: 67, g: 91, b: 119)
    static let profileControllerBackgroundColor = UIColor(r: 77, g: 136, b: 194, a: 0.7)
    
    //setting colors
    static let sectionColor = UIColor(r: 37, g: 39, b: 51)
    
    //scrollview color
    static let profileScrollViewColor = UIColor(r: 129, g: 172, b: 212)
    
    //dateLabel color
    static let dateLabelColor = UIColor(r: 0, g: 116, b: 240)
    
    //postImageView background color
    static let postImageViewBackroundColor = UIColor(r: 231, g: 236, b: 237)
    

    
    
    //Fonts
    func loginFontLarge() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 30)!

    }
    
    func loginPageFont() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 15)!
    }
    
    func loginPageSmallFont() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 13)!
    }
    
    func askLocationViewFont() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 16)!
    }
    
    //MARK: - Forgot Password
    static let forgotPasswordTextColor = UIColor(withNumbersFor: 66, green: 80, blue: 83)
    
    func forgotPasswordPageFont() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 17)!
    }
    
    //MARK: - Profile
    func profileNameLabelFont() -> UIFont {
        return UIFont(name: "Helvetica", size: 20)!
    }
    
    func profileSublabelFont() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 16)!
    }
    
    func profileBioFont() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 14)!
    }
    
    func profileNotificationsFont() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 10)!
    }
}


