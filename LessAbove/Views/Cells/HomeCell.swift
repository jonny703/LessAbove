//
//  UserCell.swift
//  LESSABOVE
//
//  Created by John Nik on 9/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase

class HomeCell: UITableViewCell {
    
    var post: Post? {
        didSet {
            
            self.titleLabel.text = post?.title
            if let timestamp = post?.timestamp {
                self.dateView.dayLabel.text = returnDayStringWith(timestamp: timestamp)
                self.dateView.monthLabel.text = returnMonthStringWith(timestamp: timestamp)
            }
            
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    let dateView: DateView = {
        
        let view = DateView()
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Adidas"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = StyleGuideManager.dateViewColor
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
//    lazy var moreButton: UIButton = {
//        let button = UIButton(type: .system)
//        let image = UIImage(named: AssetName.more.rawValue)
//        button.setImage(image, for: .normal)
//        button.tintColor = UIColor(r: 108, g: 134, b: 167, a: 1)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        
//        return button
//    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        setupViews()
        
        
//        addSubview(moreButton)
        
//        moreButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
//        moreButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        moreButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
//        moreButton.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
    }
    
    private func setupViews() {
        
        addSubview(dateView)
        addSubview(titleLabel)
        
        dateView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        dateView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        dateView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dateView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: dateView.rightAnchor, constant: 10).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

