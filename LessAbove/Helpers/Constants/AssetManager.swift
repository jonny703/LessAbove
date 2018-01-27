//
//  AssetManager.swift
//  LESSABOVE
//
//  Created by John Nik on 9/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation
import UIKit

enum AssetName: String {
    
    case setting = "setting"
    case calendar = "calendar"
    case home = "home"
    case cross = "cross"
    case search = "search"
    case userIcon = "userIcon"
    case profile = "profile"
    case lessaboveIcon = "lessaboveIcon"
    case lessaboveLogo  = "lessaboveLogo"
    case back = "back"
    case lessabove = "lessabove"
    case shoe = "shoe.jpg"
    case profileBackground = "profileBackground.jpeg"
    case profileBackground1 = "profileBackground1.jpeg"
    case profileBackground2 = "profileBackground2.jpeg"
    case addPost = "addPost"
    case imageIcon = "imageIcon"
    case pictureIcon = "pictureIcon"
    case clock = "clock"
    case addPicture = "add_picture"
    case done = "done"
    case save = "save"
    case plus = "plus"
    case closeCircular = "close_circular"
    case recycleBin = "recycle_bin"
    case refresh = "refresh"
    case likeWhite = "like_white"
    case likeRed = "like_red"
    case dislikeWhite = "dislike_white"
    case dislikeBlack = "dislike_black"
    
}

class AssetManager {
    static let sharedInstance = AssetManager()
    
    static var assetDict = [String : UIImage]()
    
    class func imageForAssetName(name: AssetName) -> UIImage {
        let image = assetDict[name.rawValue] ?? UIImage(named: name.rawValue)
        assetDict[name.rawValue] = image
        return image!
    }
    
}
