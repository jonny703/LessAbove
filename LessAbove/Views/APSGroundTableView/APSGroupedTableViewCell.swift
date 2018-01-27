//
//  APSGroupedTableViewCell.swift
//  APSGroupedTableView
//
//  Created by Aishwarya Pratap Singh on 10/1/16.
//  Copyright © 2016 Aishwarya Pratap Singh. All rights reserved.
//

import UIKit

protocol APSGroupedCellDelegate: class {
    func apsGroupedCellDidTapButton(buttonIndex:[Int]);
}

class APSGroupedTableViewCell: UITableViewCell {

    public weak var delegate:APSGroupedCellDelegate?
    let categoryWidth:CGFloat = 100.0
    let cellPadding:CGFloat = 0
    let corenerRadius = 2.0
    let categoryHeight = 250
    
    var categoryImage:UIImage = UIImage()
    var cellItems = [Post]()
    var cellCategoryName:String = ""
    
    var category_bg:UIColor = UIColor.white
    var separatorColor:UIColor = UIColor.red
    var content_bg:UIColor = UIColor.white
    var categoryTitleColor:UIColor = UIColor.white
    var customtextColor = UIColor.lightGray
    
    var shadowEnabled:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customViewForCell(cellIndex:Int) -> UIView {
        
        let objectCount = cellItems.count
        let customCellView = UIView(frame:CGRect(x: cellPadding, y: 5, width: self.frame.size.width - 2*cellPadding, height: CGFloat(objectCount*categoryHeight)))
        let timeParentView = UIView(frame:CGRect(x:0, y:0, width:categoryWidth, height:CGFloat(objectCount*categoryHeight)))
        timeParentView.backgroundColor = category_bg
        
        let timerView = self.viewForCategory(category: cellCategoryName)
        
//        let timeSeparatorView = UILabel(frame: CGRect(x:categoryWidth-1, y:0, width:1, height:CGFloat(objectCount*categoryHeight)))
//        let timeHoriSeparatorView = UILabel(frame: CGRect(x:0, y:(timeParentView.frame.size.height - 1), width:categoryWidth, height:1))
//        timeSeparatorView.backgroundColor = separatorColor
//        timeHoriSeparatorView.backgroundColor = separatorColor
        
//        timeParentView .addSubview(timeHoriSeparatorView)
//        timeParentView .addSubview(timeSeparatorView)
        timeParentView .addSubview(timerView)
        customCellView .addSubview(timeParentView)
        
        timerView.center = timeParentView.center
        
        for i in 0...(objectCount-1) {
            
            let ySpace = CGFloat(i*categoryHeight)
            
            let itemParentView = UIView(frame:CGRect(x:categoryWidth, y:ySpace, width:self.frame.size.width - (categoryWidth + cellPadding), height:CGFloat(categoryHeight)))
            
            itemParentView.tag = cellIndex + i
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.cellItemTappedWith(sender:)))
            itemParentView.addGestureRecognizer(recognizer)
            
//            itemParentView.backgroundColor = .blue
            
            let imageFrame = CGRect(x:0, y:0, width:itemParentView.frame.size.width, height:CGFloat(categoryHeight) - 80.0)
            let imageView = UIImageView(frame: imageFrame)
//            let image = UIImage(named: cellItems[i][0])
//            imageView.image = image
            imageView.contentMode = .scaleToFill
            
            if let imageUrls = cellItems[i].imageUrls {
                imageView.loadImageUsingCacheWithUrlString(urlString: imageUrls[0])
                
                let count = imageUrls.count
                if count > 1 {
                    let countLabel = UILabel()
                    countLabel.text = "+" + String(count - 1)
                    countLabel.sizeToFit()
                    countLabel.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.08, weight: UIFont.Weight.medium)
                    countLabel.textAlignment = .left
                    countLabel.textColor = .lightGray
                    countLabel.center.x = imageView.center.x + DEVICE_WIDTH * 0.21
                    countLabel.center.y = imageView.center.y
                    countLabel.frame.size = CGSize(width: DEVICE_WIDTH * 0.18, height: 30)
                    imageView.addSubview(countLabel)
                }
            } else {
                let image = UIImage(named: AssetName.shoe.rawValue)
                imageView.image = image
            }
            
            
//            imageView.backgroundColor = .red
            itemParentView.addSubview(imageView)
            
            let labelFrame = CGRect(x:0, y:CGFloat(categoryHeight) - 80.0, width:itemParentView.frame.size.width, height:80.0)
            let titleLabel = UILabel(frame: labelFrame)
            titleLabel.text = cellItems[i].title
            titleLabel.font = UIFont.systemFont(ofSize: 25)
            titleLabel.numberOfLines = 2
            titleLabel.textAlignment = .left
            
            itemParentView.addSubview(titleLabel)
            
            
//            let medButtonView = UIButton(frame:CGRect(x:categoryWidth, y:ySpace, width:self.frame.size.width - (categoryWidth + cellPadding), height:CGFloat(categoryHeight)))
//            medButtonView.tag = cellIndex + i
//            medButtonView.setTitle(cellItems[i], for: .normal)
//            medButtonView.setTitleColor(customtextColor, for: .normal)
//            medButtonView.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
//            medButtonView.contentHorizontalAlignment = .left
//            medButtonView.addTarget(self, action: #selector(self.cellTapped(sender:)), for: .touchUpInside)
            
            let medSeparatorLabel = UILabel(frame:CGRect(x:categoryWidth, y:ySpace + CGFloat(categoryHeight), width:self.frame.size.width - (categoryWidth + 2*cellPadding), height:1))
            medSeparatorLabel.backgroundColor = separatorColor
            
            customCellView.clipsToBounds = true
//            itemParentView.addSubview(medButtonView)
            customCellView .addSubview(itemParentView)
            customCellView .addSubview(medSeparatorLabel)
        }
        
        customCellView.backgroundColor = content_bg
        customCellView.layer.cornerRadius = CGFloat(corenerRadius)
        customCellView.layer.borderColor = separatorColor.cgColor
        customCellView.layer.borderWidth = 0.5
        
        if shadowEnabled {
            customCellView.layer.shadowColor = UIColor.lightGray.cgColor
            customCellView.layer.shadowRadius = 1
            customCellView.layer.shadowOpacity = 0.5
            customCellView.layer.masksToBounds = false
            customCellView.layer.shadowOffset = CGSize(width: 2, height: 2)
        }
        
        customCellView.tag = 101
        return customCellView
    }

    func viewForCategory(category:String) -> UIView {
        
        let categoryParentView = UIView(frame: CGRect(x:0, y:0, width:categoryWidth, height:50))
        
//        let categoryParentImageView = UIImageView(frame: CGRect(x:5, y:8, width:15, height:15))
//        let categoryLabelView = UILabel(frame: CGRect(x:30, y:5, width:categoryWidth, height:20))
//        
//        categoryParentImageView.image = categoryImage
//        
//        categoryLabelView.textColor = categoryTitleColor
//        categoryLabelView.text = category
//        categoryLabelView.font = UIFont .systemFont(ofSize: 14.0)
//        categoryLabelView.textAlignment = .left
//        
//        categoryParentView .addSubview(categoryParentImageView)
//        categoryParentView .addSubview(categoryLabelView)
        
        let dateView = DateView(frame: CGRect(x: 25, y: 0, width: 50, height: 50))
        dateView.layer.cornerRadius = 25
        dateView.layer.masksToBounds = true
        
        
        let strArr = category.components(separatedBy: ",")
        dateView.dayLabel.text = strArr[0]
        dateView.monthLabel.text = strArr[1]
        
        categoryParentView.addSubview(dateView)
        
        
        
        
        return categoryParentView
    }

    override func layoutSubviews() {
        self.contentView.subviews.forEach{$0.removeFromSuperview()}
        self.contentView.addSubview(customViewForCell(cellIndex: self.tag))
        super.layoutSubviews()
        
    }
    
    func cellTapped(sender : AnyObject) {
        
        let button = sender as! UIButton
        
        let section = button.tag/100
        let row = (button.tag%100)/10
        let buttonIndex = (button.tag%100)%10
        
        delegate?.apsGroupedCellDidTapButton(buttonIndex: [section,row,buttonIndex])
        
    }
    
    @objc func cellItemTappedWith(sender: UITapGestureRecognizer) {
        
        if let cellItemView = sender.view {
//            let button = sender as! UIButton
            
            let section = cellItemView.tag/100
            let row = (cellItemView.tag%100)/10
            let buttonIndex = (cellItemView.tag%100)%10
            
            delegate?.apsGroupedCellDidTapButton(buttonIndex: [section,row,buttonIndex])

        }
        
    }
    
    
}
