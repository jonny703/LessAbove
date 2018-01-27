//
//  Post.swift
//  LESSABOVE
//
//  Created by John Nik on 9/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class Post: NSObject {
    var postId: String?
    var title: String?
    var styleCode: String?
    var price: String?
//    var imageWidth: NSNumber?
    var imageUrls: [String]?
//    var imageHeight: NSNumber?
    var imageSource: String?
    var date: String?
    var colorScheme: String?
    var timestamp: NSNumber?
    var links: [String]?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        postId = dictionary["postId"] as? String
        title = dictionary["title"] as? String
        styleCode = dictionary["styleCode"] as? String
        price = dictionary["price"] as? String
//        imageWidth = dictionary["imageWidth"] as? NSNumber
//        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageUrls = dictionary["imageUrls"] as? [String]
        imageSource = dictionary["imageSource"] as? String
        date = dictionary["date"] as? String
        colorScheme = dictionary["colorScheme"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        links = dictionary["links"] as? [String]
    }
    
}
