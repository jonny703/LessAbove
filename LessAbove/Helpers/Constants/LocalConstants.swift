//
//  Constants.swift
//  LESSABOVE
//
//  Created by John Nik on 9/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation
import UIKit


let User_Image_Radius: CGFloat = DEVICE_WIDTH * 0.16

let DEVICE_WIDTH = UIScreen.main.bounds.size.width
let DEVICE_HEIGHT = UIScreen.main.bounds.size.height
let IMAGE_HEIGHT = DEVICE_WIDTH * 3 / 5
let TEXTFEILD_HEIGHT = CGFloat(50)

let defaults = UserDefaults.standard

let TextField_Width: CGFloat = 200

let ShowAnswersTime: Int = 10
let WaitingTime: Int = 5

let AlertDelay: Int = 2

let CorrectPoints: Int = 10


enum ErrorStatus {
    case image
    case emptyLink
    case invalidLink
}

