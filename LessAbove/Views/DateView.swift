//
//  DateView.swift
//  LESSABOVE
//
//  Created by John Nik on 9/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class DateView: UIView {
    
    
    let dayLabel: UILabel = {
        
        let label = UILabel()
        label.text = "09"
        label.textAlignment = .center
        label.textColor = .white
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    let monthLabel: UILabel = {
        
        let label = UILabel()
        label.text = "SEP"
        label.textAlignment = .center
        label.textColor = .white
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = StyleGuideManager.dateViewColor
        
        setupLabels()
        
    }
    
    private func setupLabels() {
        
        addSubview(dayLabel)
        addSubview(monthLabel)
        
        dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        monthLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        monthLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}
