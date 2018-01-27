//
//  HomeCellHeader.swift
//  LESSABOVE
//
//  Created by John Nik on 9/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class HomeCellHeader: UITableViewHeaderFooterView {
    
    let postImageVew: UIImageView = {
        
        let imageView = UIImageView()
        let image = UIImage(named: AssetName.shoe.rawValue)
        imageView.image = image
        imageView.alpha = 0.2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let dateView: DateView = {
        let view = DateView()
        view.dayLabel.font = UIFont.systemFont(ofSize: 20)
        view.monthLabel.font = UIFont.systemFont(ofSize: 20)
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Adidas"
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = StyleGuideManager.dateViewColor
        label.textAlignment = .center
        label.numberOfLines = 2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        
        
        setupViews()
    }
    
    private func setupViews() {
        
        addSubview(postImageVew)
        addSubview(dateView)
        addSubview(titleLabel)
        
        
        postImageVew.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        postImageVew.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        postImageVew.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        postImageVew.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        dateView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        dateView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        dateView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dateView.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
