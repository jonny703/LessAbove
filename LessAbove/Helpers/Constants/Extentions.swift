//
//  Extentions.swift
//  LESSABOVE
//
//  Created by John Nik on 9/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

extension Double {
    //    var clean: String { return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", self) : String(self) }
    
    var cleanFloat: String {
        return  String(format: "%.2f", self)
    }
    
    var cleanFloatSix: String {
        return  String(format: "%.6f", self)
    }
    
    var cleanInt: String {
        return  String(format: "%d", self)
    }
    
}

extension NSAttributedStringKey {
    static let url = NSAttributedStringKey("url")
}

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 1, y: 0)
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += 20
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
        
    }
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    convenience init(withNumbersFor red: CGFloat , green: CGFloat, blue: CGFloat, alpha: CGFloat? = 1.0) {
        let redNumber = red / 255
        let greenNumber = green / 255
        let blueNumber = blue / 255
        
        self.init(red: redNumber , green: greenNumber, blue: blueNumber, alpha: alpha!)
    }
}

extension UITabBar {
    
    func setGradientBackgroundUITabBar(colors: [UIColor]) {
        
        let rect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let layerGradient = CAGradientLayer(frame: rect, colors: colors)
        self.layer.addSublayer(layerGradient)
        
    }
    
}

extension UIScrollView {
    func setGradientBackgroundUIScrollView(colors: [UIColor]) {
        
        let rect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let layerGradient = CAGradientLayer(frame: rect, colors: colors)
        self.layer.addSublayer(layerGradient)
        
    }
}

extension UIView {
    
    func setGradientBackgroundUIView(colors: [UIColor]) {
        
        let rect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let layerGradient = CAGradientLayer(frame: rect, colors: colors)
        self.layer.addSublayer(layerGradient)
        
    }
    
    func addConstraintsWithFormat(format: String, views:UIView...) {
        var viewDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
    
    func reoundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 10, height: 10))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

extension UIButton {
    
    func buttonNameWith(name: String) {
        
        self.setTitle(name, for: .normal)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.setTitleColor(UIColor.black, for: .normal)
        self.setTitleColor(UIColor.blue, for: .selected)
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


extension UIImageView {
    
    func imageWithString(name: String, radius: CGFloat) {
        
        let image = UIImage(named: name)
        
        self.image = image
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderWidth = DEVICE_WIDTH * 0.004
        self.layer.borderColor = UIColor.black.cgColor
        
    }
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.sync {
                
                if let downloadedImage = UIImage(data: data!) {
                    
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                    
                }
            }
            
        }).resume()
    }
}
