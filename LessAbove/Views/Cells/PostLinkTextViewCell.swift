//
//  PostLinkTextViewCell.swift
//  LESSABOVE
//
//  Created by John Nik on 10/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation
import UIKit

class PostLinkTextViewCell: UITableViewCell {
    
    let linkTextView: UITextView = {
        let textView = UITextView()
        textView.text = "swishysupply"
        textView.textColor = .black
        textView.textAlignment = .left
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.isSelectable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.backgroundColor = .clear
        
        self.setupViews()
    }
    
    private func setupViews() {
        
        addSubview(linkTextView)
        
        linkTextView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        linkTextView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        linkTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        linkTextView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
