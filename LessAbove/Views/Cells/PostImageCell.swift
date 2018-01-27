//
//  CreatePostCell.swift
//  LESSABOVE
//
//  Created by John Nik on 10/2/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation
import UIKit

protocol PostImageCellDelegate {
    func didClickAddPhoto(selectedIndex: Int)
    func didClickDeletePhoto(selectedIndex: Int)
}

enum PostImageCellStatus {
    case createPost
    case detailPost
}

class PostImageCell: UITableViewCell {
    
    var postImageCellDelegate: PostImageCellDelegate?
    var createPostController: CreatePostController?
    var postDetailController: PostDetailController?
    
    var postImageCellStatus: PostImageCellStatus?
    
    var selectedIndex: Int?
    
    lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: AssetName.imageIcon.rawValue)
        imageView.backgroundColor = StyleGuideManager.postImageViewBackroundColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleToFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap(tapGesture:))))
        return imageView
        
    }()
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        
        if let imageView = tapGesture.view as? UIImageView {
            if imageView.image != nil {
                
                if self.postImageCellStatus == .createPost {
                    self.createPostController?.performZoomingForStartingImageView(startingImageView: imageView)
                } else {
                    self.postDetailController?.performZoomingForStartingImageView(startingImageView: imageView)
                }
            }
            
        }
    }
    
    lazy var addPictureButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: AssetName.plus.rawValue)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return button
    }()
    
    lazy var deletePictureButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: AssetName.recycleBin.rawValue)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDeletePhoto), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.backgroundColor = .clear
        setupViews()
        
    }
    
    private func setupViews() {
        
        addSubview(postImageView)
        addSubview(addPictureButton)
        addSubview(deletePictureButton)
        
        postImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        postImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        postImageView.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        postImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        addPictureButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        addPictureButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        addPictureButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        addPictureButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        
        deletePictureButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        deletePictureButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        deletePictureButton.topAnchor.constraint(equalTo: postImageView.topAnchor, constant: 0).isActive = true
        deletePictureButton.leftAnchor.constraint(equalTo: postImageView.leftAnchor, constant: -5).isActive = true
        
        deletePictureButton.isHidden = true
    }
    
    @objc private func handleAddPhoto() {
        postImageCellDelegate?.didClickAddPhoto(selectedIndex: self.selectedIndex!)
    }
    
    @objc private func handleDeletePhoto() {
        postImageCellDelegate?.didClickDeletePhoto(selectedIndex: self.selectedIndex!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
