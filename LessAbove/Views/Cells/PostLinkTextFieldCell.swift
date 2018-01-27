//
//  PostLinkTextFieldCell.swift
//  LESSABOVE
//
//  Created by John Nik on 10/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation
import UIKit

class PostLinkTextFieldCell: UITableViewCell {
    
    let linkTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        let str = NSAttributedString(string: "Type Link here", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        textField.attributedPlaceholder = str
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .white
        return textField
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.backgroundColor = .clear
        
        self.setupViews()
    }
    
    private func setupViews() {
        
        addSubview(linkTextField)
        
        linkTextField.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        linkTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        linkTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        linkTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
