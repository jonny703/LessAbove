//
//  PostDetailController.swift
//  LESSABOVE
//
//  Created by John Nik on 9/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase
import KRProgressHUD


enum DidClickButtonStatus {
    case likeButton
    case dislikeButton
    case neither
}

enum LikeDislikeStatus {
    case like
    case unlike
    case dislike
    case undislike
}

class PostDetailController: UIViewController {
    
    let cellId = "cellId"
    let linkCellId = "linkCellId"
    
    var isLike:Bool?
    var isDislike:Bool?
    var didClickButtonStatus: DidClickButtonStatus?
    
    var post: Post? {
        didSet {
            fetchPost()
        }
    }
    
    var linkHeights = [CGFloat]()
    
    var backgroundScrollViewConstraint: NSLayoutConstraint?
    var postImageTableViewConstraint: NSLayoutConstraint!
    var postLinkTableViewConstraint: NSLayoutConstraint!
    
    var backgroundScrollViewConstant: CGFloat?
    var postImageTableViewConstant: CGFloat?
    var postLinkTableViewConstant: CGFloat?
    
    //vars for image zooming
    var startingFrame: CGRect?
    
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    
    
    let backgroundScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.alwaysBounceVertical = true
        scrollView.contentSize = CGSize(width: DEVICE_WIDTH, height: DEVICE_HEIGHT)
        return scrollView
    }()
    
    lazy var postImageTableView: UITableView = {
        var tableView = UITableView();
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        return tableView;
    }()
    
    lazy var postLinkTableView: UITableView = {
        var tableView = UITableView();
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        return tableView;
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Air Jordan 5 Blue Suede"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let clockImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: AssetName.clock.rawValue)?.withRenderingMode(.alwaysOriginal)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Sat, Sep 30 2017"
        label.textColor = StyleGuideManager.dateLabelColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let styleCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "343243-343"
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let colorSchemeLabel: UILabel = {
        let label = UILabel()
        label.text = "Royal Blue / Black"
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$190"
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageSourceLabel: UILabel = {
        let label = UILabel()
        label.text = "swishysupply"
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Likes"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dislikesLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Dislikes"
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
}

//MARK: handle like and dislike
extension PostDetailController {
    @objc fileprivate func handleLikeButton() {
        
        self.isLike! = !self.isLike!
        
        if self.isLike! {
            print("like")
            self.handleLikeDisLikeWithFirebase(type: .like)
        } else {
            print("unlike")
            self.handleLikeDisLikeWithFirebase(type: .unlike)
        }
        
        
    }
    
    @objc fileprivate func handleDislikeButton() {
        
        self.isDislike! = !self.isDislike!
        
        if self.isDislike! {
            print("dislike")
            self.handleLikeDisLikeWithFirebase(type: .dislike)
        } else {
            print("undislike")
            self.handleLikeDisLikeWithFirebase(type: .undislike)
        }
    }
    
    private func comebackLikeDislikeWhenIssueWith(type: LikeDislikeStatus) {
        if type == .like || type == .unlike {
            self.isLike! = !self.isLike!
        } else if type == .dislike || type == .undislike {
            self.isDislike! = !self.isDislike!
        }
    }
    
    private func handleLikeDisLikeWithFirebase(type: LikeDislikeStatus) {
        
        KRProgressHUD.show()
        
        guard let userId = Auth.auth().currentUser?.uid else {
            KRProgressHUD.dismiss()
            self.comebackLikeDislikeWhenIssueWith(type: type)
            self.showErrorAlertWith("Server issue!", message: "Sorry! Something went wrong, try again later")
            return
        }
        
        var likeDislikeValue = String()
        if type == .like {
            self.isDislike = false
            likeDislikeValue = "like"
        } else if type == .unlike {
            likeDislikeValue = "none"
        } else if type == .dislike {
            self.isLike = false
            likeDislikeValue = "dislike"
        } else if type == .undislike {
            likeDislikeValue = "none"
        }
        
        let likeDislikeRef = Database.database().reference().child("likes-dislikes").child((post?.postId)!)
        
        if likeDislikeValue == "none" {
            likeDislikeRef.child(userId).removeValue(completionBlock: { (error, ref) in
                
                if error != nil {
                    print("Failed to delete child", error!)
                    KRProgressHUD.dismiss()
                    self.comebackLikeDislikeWhenIssueWith(type: type)
                    self.showErrorAlertWith("Server issue!", message: "Sorry! Something went wrong, try again later")
                    return
                }
                KRProgressHUD.dismiss()
                self.updateLikeDislikeButtons(isLike: self.isLike!, isDislike: self.isDislike!)
                
            })
        } else {
            let value = ["status": likeDislikeValue]
            likeDislikeRef.child(userId).updateChildValues(value, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print("Failed to update like table")
                    KRProgressHUD.dismiss()
                    self.comebackLikeDislikeWhenIssueWith(type: type)
                    self.showErrorAlertWith("Server issue!", message: "Sorry! Something went wrong, try again later")
                }
                KRProgressHUD.dismiss()
                self.updateLikeDislikeButtons(isLike: self.isLike!, isDislike: self.isDislike!)
            })
        }
        if let postId = self.post?.postId {
            self.reloadLikeDislikeWith(postId: postId)
        }
    }
    
    
    
    fileprivate func updateLikeDislikeButtons(isLike: Bool, isDislike: Bool) {
        let likeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        likeButton.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
        let likeWhiteImage = UIImage(named: AssetName.likeWhite.rawValue)?.withRenderingMode(.alwaysOriginal)
        let likeBlueImage = UIImage(named: AssetName.likeRed.rawValue)?.withRenderingMode(.alwaysOriginal)
        
        let dislikeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        dislikeButton.addTarget(self, action: #selector(handleDislikeButton), for: .touchUpInside)
        let dislikeWhiteImage = UIImage(named: AssetName.dislikeWhite.rawValue)?.withRenderingMode(.alwaysOriginal)
        let dislikeBlackImage = UIImage(named: AssetName.dislikeBlack.rawValue)?.withRenderingMode(.alwaysOriginal)
        
        if isLike {
            likeButton.setImage(likeBlueImage, for: .normal)
        } else {
            likeButton.setImage(likeWhiteImage, for: .normal)
        }
        
        if isDislike {
            dislikeButton.setImage(dislikeBlackImage, for: .normal)
        } else {
            dislikeButton.setImage(dislikeWhiteImage, for: .normal)
        }
        let dislikeBarButton = UIBarButtonItem(customView: dislikeButton)
        let likeBarButton = UIBarButtonItem(customView: likeButton)
        
        self.navigationItem.setRightBarButtonItems([dislikeBarButton, likeBarButton], animated: true)
    }
}

//MARK: handle tableview delegate
extension PostDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == postImageTableView {
            if let count = self.post?.imageUrls?.count {
                return count
            }
            
            return 0
        } else {
            if let count = self.post?.links?.count {
                return count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == postImageTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostImageCell
            
            if let imageUrls = self.post?.imageUrls {
                let imageUrl = imageUrls[indexPath.row]
                self.setupPostImageCell(cell: cell, imageUrl: imageUrl)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: linkCellId, for: indexPath) as! PostLinkTextViewCell
            
            if let link = post?.links![indexPath.row] {
                self.setupPostLinkCell(cell: cell, link: link)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == postImageTableView {
            return IMAGE_HEIGHT
        } else {
            if self.linkHeights.count > 0 {
                return self.linkHeights[indexPath.row]
            }
            return 0
        }
    }
    
    private func setupPostImageCell(cell: PostImageCell, imageUrl: String) {
        cell.addPictureButton.isHidden = true
        cell.deletePictureButton.isHidden = true
        
        cell.postDetailController = self
        cell.postImageCellStatus = .detailPost
        cell.postImageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
    }
    
    private func setupPostLinkCell(cell: PostLinkTextViewCell, link: String) {
        let postAttributedString = NSMutableAttributedString(string: link, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)])
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: link, options: [], range: NSRange(location: 0, length: (link.utf16.count)))
        
        if matches.count > 0 {
            for match in matches {
                
                guard let range = Range(match.range, in: link) else { continue }
                let url = link[range]
                let index = link.distance(from: (link.startIndex), to: range.lowerBound)
                
                let urlRange = NSMakeRange(index, url.characters.count)
                
                postAttributedString.addAttribute(NSAttributedStringKey(rawValue: NSAttributedStringKey.link.rawValue), value: url, range: urlRange)
                
                postAttributedString.removeAttribute(NSAttributedStringKey.font, range: urlRange)
                postAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 20), range: urlRange)
                
                let linkAttribute: [String: Any] = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.darkGray, NSAttributedStringKey.underlineColor.rawValue: UIColor.darkGray, NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue]
                cell.linkTextView.linkTextAttributes = linkAttribute
                cell.linkTextView.attributedText = postAttributedString
            }
        } else {
            cell.linkTextView.attributedText = nil
            cell.linkTextView.typingAttributes = Dictionary()
            cell.linkTextView.text = link
            cell.linkTextView.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
}

//MARK: fetch post
extension PostDetailController {
    
    private func returnMutableStringWith(headStr: String, mainStr: String, fontSize: Int) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        
        let fullStr = headStr + mainStr
        let attributedString = NSMutableAttributedString(string: fullStr, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.paragraphStyle: style, NSAttributedStringKey.font: UIFont.systemFont(ofSize: CGFloat(fontSize))])
        let range = NSRange(location: 0, length: headStr.characters.count)
        let attribute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor: UIColor.black]
        attributedString.addAttributes(attribute, range: range)
        return attributedString
    }
    
    private func returningLikesDislikesString(number: Int, type: LikeDislikeStatus) -> String {
        var str = ""
        if number >= 1000 {
            str = "1K "
        } else if number >= 2000 {
            str = "2K "
        } else if number >= 3000 {
            str = "3K "
        } else if number >= 4000 {
            str = "4K "
        } else if number >= 5000 {
            str = "5K "
        } else if number >= 6000 {
            str = "6K "
        } else if number >= 7000 {
            str = "7K "
        } else if number >= 8000 {
            str = "8K "
        } else if number >= 9000 {
            str = "9K "
        } else if number >= 10000 {
            str = "10K "
        } else if number >= 20000 {
            str = "20K "
        } else if number >= 30000 {
            str = "30K "
        } else if number >= 40000 {
            str = "40K "
        } else if number >= 50000 {
            str = "50K "
        } else if number >= 60000 {
            str = "60K "
        } else if number >= 70000 {
            str = "70K "
        } else if number >= 80000 {
            str = "80K "
        } else if number >= 90000 {
            str = "90K "
        } else if number >= 100000 {
            str = "100K "
        } else if number >= 200000 {
            str = "200K "
        } else if number >= 300000 {
            str = "300K "
        } else if number >= 400000 {
            str = "400K "
        } else if number >= 500000 {
            str = "500K "
        } else if number >= 600000 {
            str = "600K "
        } else if number >= 700000 {
            str = "700K "
        } else if number >= 800000 {
            str = "800K "
        } else if number >= 900000 {
            str = "900K "
        } else if number >= 1000000 {
            str = "1M "
        } else if number >= 2000000 {
            str = "2M "
        } else if number >= 3000000 {
            str = "3M "
        } else if number >= 4000000 {
            str = "4M "
        } else if number >= 5000000 {
            str = "5M "
        } else if number >= 6000000 {
            str = "6M "
        } else if number >= 7000000 {
            str = "7M "
        } else if number >= 8000000 {
            str = "8M "
        } else if number >= 9000000 {
            str = "9M "
        } else if number >= 10000000 {
            str = "10M "
        } else {
            str = String(number) + " "
        }
        
        if type == .like {
            str += "Likes"
        } else {
            str += "Dislikes"
        }
        return str
    }
    
    fileprivate func reloadLikeDislikeWith(postId: String) {
        let likesDislikesRef = Database.database().reference().child("likes-dislikes").child(postId)
        likesDislikesRef.queryOrdered(byChild: "status").queryEqual(toValue: "like").observeSingleEvent(of: .value, with: { (snapshot) in
            print("likes", snapshot.childrenCount)
            self.likesLabel.text = self.returningLikesDislikesString(number: Int(snapshot.childrenCount), type: .like)
        })
        
        likesDislikesRef.queryOrdered(byChild: "status").queryEqual(toValue: "dislike").observeSingleEvent(of: .value, with: { (snapshot) in
            print("dislikes", snapshot.childrenCount)
            self.dislikesLabel.text = self.returningLikesDislikesString(number: Int(snapshot.childrenCount), type: .dislike)
        })
    }
    
    fileprivate func fetchLikeDislikeWith(postId: String) {
        let likesDislikesRef = Database.database().reference().child("likes-dislikes").child(postId)
        if let userId = Auth.auth().currentUser?.uid {
            likesDislikesRef.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let status = dictionary["status"] as! String
                    if status == "like" {
                        self.isLike = true
                        self.isDislike = false
                    } else {
                        self.isDislike = true
                        self.isLike = false
                    }
                    self.updateLikeDislikeButtons(isLike: self.isLike!, isDislike: self.isDislike!)
                }
                
            })
        }
    }
    
    func fetchPost() {
        if let postId = post?.postId {
            
            self.reloadLikeDislikeWith(postId: postId)
            
            self.fetchLikeDislikeWith(postId: postId)
        }
        
        
        if let count = self.post?.imageUrls?.count {
            postImageTableViewConstant = IMAGE_HEIGHT * CGFloat(count)
            backgroundScrollViewConstant = IMAGE_HEIGHT * CGFloat(count)
        }
        
        if let count = self.post?.links?.count {
            var totalHeight: CGFloat = 0
            for i in 0 ..< count {
                if let link = self.post?.links![i] {
                    let textViewHeight = estimateFrameForText(text: link, width: Int(DEVICE_WIDTH * 0.9), fontSize: 20).height + 40.0
                    self.linkHeights.append(textViewHeight)
                    totalHeight += textViewHeight
                }
            }
            
            self.postLinkTableViewConstant = totalHeight
            
            if let backgroundScrollViewHeight = backgroundScrollViewConstant {
                self.backgroundScrollViewConstant = backgroundScrollViewHeight + totalHeight
            }
        }
        
        self.dateLabel.text = post?.date
        self.titleLabel.text = post?.title
        
        let styleCodeHeadStr = "Style Code: "
        let styleCodeMainStr = post?.styleCode
        self.styleCodeLabel.attributedText = self.returnMutableStringWith(headStr: styleCodeHeadStr, mainStr: styleCodeMainStr!, fontSize: 20)
        
        let colorSchemeHeadStr  = "Color Scheme: "
        let colorSchemeMainStr = post?.colorScheme
        self.colorSchemeLabel.attributedText = self.returnMutableStringWith(headStr: colorSchemeHeadStr, mainStr: colorSchemeMainStr!, fontSize: 20)
        
        let priceHeadStr = "Price: $"
        let priceMainStr = post?.price
        self.priceLabel.attributedText = self.returnMutableStringWith(headStr: priceHeadStr, mainStr: priceMainStr!, fontSize: 20)
        
        let imageSourceHeadStr = "Image Source: "
        let imageSourceMainStr = post?.imageSource
        self.imageSourceLabel.attributedText = self.returnMutableStringWith(headStr: imageSourceHeadStr, mainStr: imageSourceMainStr!, fontSize: 20)
        
//        let imageSourceUrl = "Link: " + (post?.links![0])!
//        let textViewHeight = estimateFrameForText(text: imageSourceUrl, width: Int(DEVICE_WIDTH * 0.9), fontSize: 20).height
//        imageSourceUrlTextViewConstraint?.constant = textViewHeight
    }
    
}

//MARK: handle dismiss, save profile
extension PostDetailController {
    
    @objc fileprivate func handleDismiss() {
        self.dismiss(animated: false, completion: nil)
    }
}

//MARK: handle image zoom in and out
//MARK: - handleImage, Video
extension PostDetailController {
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        
        if let imageView = tapGesture.view as? UIImageView {
            
            //PRO Tip: don't perform a lot of custom logic inside of a view class
            
            self.performZoomingForStartingImageView(startingImageView: imageView)
            
            
        }
    }
    
    //my custom zooming logic
    
    func performZoomingForStartingImageView(startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.clear
        zoomingImageView.image = startingImageView.image
        
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                //math?
                //h2 / w2 = h1 / w1
                // h2 = h1 / w1 * w2
                self.blackBackgroundView?.alpha = 1
                //                self.inputContainerView.alpha = 0
                //                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                let height = (self.startingImageView?.image?.size.height)! / (self.startingImageView?.image?.size.width)! * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
                
            }, completion: { (completed) in
                
                //                zoomOutImageView.removeFromSuperview()
                
            })
        }
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        
        if let zoomOutImageView = tapGesture.view {
            
            //need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.layer.masksToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                //                self.inputContainerView.alpha = 1
                
            }, completion: { (completed) in
                
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
                
            })
        }
    }
}




//MARK: setup background and views

extension PostDetailController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupNavBar()
        setupPostViews()
    }
    
    
    
    private func setupPostViews() {
        
        
        
        view.addSubview(backgroundScrollView)
        
        backgroundScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundScrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        backgroundScrollViewConstraint = backgroundScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        backgroundScrollViewConstraint?.isActive = true
        
        if let height = backgroundScrollViewConstant {
            backgroundScrollView.contentSize.height += height
        }
        
        backgroundScrollView.addSubview(likesLabel)
        backgroundScrollView.addSubview(dislikesLabel)
        backgroundScrollView.addSubview(postImageTableView)
        backgroundScrollView.addSubview(titleLabel)
        backgroundScrollView.addSubview(clockImageView)
        backgroundScrollView.addSubview(dateLabel)
        backgroundScrollView.addSubview(styleCodeLabel)
        backgroundScrollView.addSubview(colorSchemeLabel)
        backgroundScrollView.addSubview(priceLabel)
        backgroundScrollView.addSubview(imageSourceLabel)
        backgroundScrollView.addSubview(postLinkTableView)
        
        likesLabel.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.5 - 30).isActive = true
        likesLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        likesLabel.leftAnchor.constraint(equalTo: backgroundScrollView.leftAnchor, constant: 30).isActive = true
        likesLabel.topAnchor.constraint(equalTo: backgroundScrollView.topAnchor, constant: 10).isActive = true
        
        dislikesLabel.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.5).isActive = true
        dislikesLabel.heightAnchor.constraint(equalTo: likesLabel.heightAnchor).isActive = true
        dislikesLabel.topAnchor.constraint(equalTo: backgroundScrollView.topAnchor, constant: 10).isActive = true
        dislikesLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        postImageTableView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH).isActive = true
        postImageTableView.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 0).isActive = true
        postImageTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postImageTableViewConstraint = postImageTableView.heightAnchor.constraint(equalToConstant: IMAGE_HEIGHT)
        postImageTableViewConstraint.isActive = true
        
        if let height = postImageTableViewConstant {
            postImageTableViewConstraint.constant = height
        }
        
        postImageTableView.register(PostImageCell.self, forCellReuseIdentifier: cellId)
        
        titleLabel.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.9).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: backgroundScrollView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: postImageTableView.bottomAnchor, constant: 30).isActive = true
        
        clockImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        clockImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        clockImageView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0).isActive = true
        clockImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: clockImageView.rightAnchor, constant: 10).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: clockImageView.bottomAnchor, constant: 5).isActive = true
        
        styleCodeLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        styleCodeLabel.heightAnchor.constraint(equalTo: dateLabel.heightAnchor).isActive = true
        styleCodeLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        styleCodeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20).isActive = true
        
        colorSchemeLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        colorSchemeLabel.heightAnchor.constraint(equalTo: dateLabel.heightAnchor).isActive = true
        colorSchemeLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        colorSchemeLabel.topAnchor.constraint(equalTo: styleCodeLabel.bottomAnchor, constant: 20).isActive = true

        
        priceLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalTo: dateLabel.heightAnchor).isActive = true
        priceLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        priceLabel.topAnchor.constraint(equalTo: colorSchemeLabel.bottomAnchor, constant: 20).isActive = true

        
        imageSourceLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        imageSourceLabel.heightAnchor.constraint(equalTo: dateLabel.heightAnchor).isActive = true
        imageSourceLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        imageSourceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20).isActive = true
        
        postLinkTableView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH).isActive = true
        postLinkTableView.topAnchor.constraint(equalTo: imageSourceLabel.bottomAnchor, constant: 20).isActive = true
        postLinkTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postLinkTableViewConstraint = postLinkTableView.heightAnchor.constraint(equalToConstant: 50)
        postLinkTableViewConstraint.isActive = true
        
        if let height = postLinkTableViewConstant {
            postLinkTableViewConstraint.constant = height
        }
        
        postLinkTableView.register(PostLinkTextViewCell.self, forCellReuseIdentifier: linkCellId)

    }
    
    private func setupBackground() {
        
                view.backgroundColor = .white
        
//        view.setGradientBackgroundUIView(colors: StyleGuideManager.gradientColors)
        
    }
    
    fileprivate func setupNavBar() {
        
//        navigationItem.title = "Create Content"
        
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        let image = UIImage(named: AssetName.lessabove.rawValue)
        titleImageView.image = image
        
        navigationItem.titleView = titleImageView
        
        let closeImage = UIImage(named: AssetName.cross.rawValue)?.withRenderingMode(.alwaysTemplate)
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(handleDismiss))
        closeButton.tintColor = .white
        navigationItem.leftBarButtonItem = closeButton
        
        if let isLike = self.isLike, let isDislike = self.isDislike {
            print(isLike, isDislike)
        } else {
            self.isLike = false
            self.isDislike = false
        }
        self.updateLikeDislikeButtons(isLike: isLike!, isDislike: self.isDislike!)
        
        
    }
    
}

