//
//  Global.swift
//  LESSABOVE
//
//  Created by John Nik on 7/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation
import UIKit

func returnLeftTimedateformatter(date: Double) -> String {
    
    let date1:Date = Date() // Same you did before with timeNow variable
    let date2: Date = Date(timeIntervalSince1970: date)
    
    let calender:Calendar = Calendar.current
    let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1, to: date2)
    print(components)
    var returnString:String = ""
    print(abs(components.second!))
    
    if abs(components.year!) >= 1 {
        returnString = String(describing: abs(components.year!))+" y"
    } else if abs(components.month!) >= 1{
        returnString = String(describing: abs(components.month!))+" m"
    } else if abs(components.day!) >= 1{
        returnString = String(describing: abs(components.day!)) + " d"
    } else if abs(components.hour!) >= 1{
        returnString = String(describing: abs(components.hour!)) + " h"
    } else if abs(components.minute!) >= 1{
        returnString = String(describing: abs(components.minute!)) + " min"
    } else if components.second! < 60 {
        returnString = "Just Now"
    }
    return returnString
}

func returnDayWithDateformatter(date: Double) -> Int {
    
    let date1:Date = Date() // Same you did before with timeNow variable
    let date2: Date = Date(timeIntervalSince1970: date)
    
    let calender:Calendar = Calendar.current
    let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1, to: date2)
//    print(components)
    var returnNum: Int = 0
//    print(components.second)
    
    if abs(components.day!) >= 1{
        returnNum = abs(components.day!)
    } else if components.hour! >= 1{
        returnNum = 0
    } else if components.minute! >= 1{
        returnNum = 0
    } else if components.second! < 60 {
        returnNum = 0
    }
    return returnNum
}

func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}

func estimateFrameForText(text: String, width: Int, fontSize: Int) -> CGRect {
    
    let size = CGSize(width: width, height: 1000)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: CGFloat(fontSize))], context: nil)
    
}
func goingBrowser(urlString: String) {
    let destinationUrl = URL(string: urlString)!
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(destinationUrl, options: [:], completionHandler: nil)
    } else {
        UIApplication.shared.openURL(destinationUrl)
    }
}

func verifyUrl(urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
    }
    return false
}












