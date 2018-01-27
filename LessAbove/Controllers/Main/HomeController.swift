//
//  HomeController.swift
//  LESSABOVE
//
//  Created by John Nik on 9/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase
import KRProgressHUD

class HomeController: UITableViewController {
    
    let cellId = "cellId"
    let cellHeaderId = "cellHeaderId"
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        fectchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackground()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = self.posts[indexPath.row]
        self.goingToPostDetailControllerWith(post: post, type: "cell")
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeCell
        
        let post = posts[indexPath.row]
        cell.post = post
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        
        if self.posts.count > 0 {
            let cellHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: cellHeaderId) as! HomeCellHeader

            let post = posts[0]
            cellHeader.titleLabel.text = post.title
            
            if let timestamp = post.timestamp {
                cellHeader.dateView.dayLabel.text = returnDayStringWith(timestamp: timestamp)
                cellHeader.dateView.monthLabel.text = returnMonthStringWith(timestamp: timestamp)
            }
            
            if let imageUrls = post.imageUrls {
                cellHeader.postImageVew.loadImageUsingCacheWithUrlString(urlString: imageUrls[0])
            }
            
            cellHeader.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goingToPostDetailController)))
            return cellHeader
        } else {
            return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}

//MARK: going to postdetail
extension HomeController {
    
    @objc fileprivate func goingToPostDetailController() {
        let postDetailController = PostDetailController()
        postDetailController.post = self.posts[0]
        
        let navController = UINavigationController(rootViewController: postDetailController)
        navController.navigationBar.setGradientBackground(colors: StyleGuideManager.gradientColors)
        
        navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc fileprivate func goingToPostDetailControllerWith(post: Post, type: String) {
        
        let postDetailController = PostDetailController()
        
        if type == "cell" {
            postDetailController.post = post
        } else {
            postDetailController.post = self.posts[0]
        }
        
        let navController = UINavigationController(rootViewController: postDetailController)
        navController.navigationBar.setGradientBackground(colors: StyleGuideManager.gradientColors)
        
        navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.present(navController, animated: true, completion: nil)
        
    }
    
    
    
    
}

//MARK: fetch contents
extension HomeController {
    @objc fileprivate func fectchPosts() {
        
        KRProgressHUD.show()
        
        self.posts.removeAll()
        
        let postsRef = Database.database().reference().child("posts").child("all").queryOrdered(byChild: "timestamp")
        postsRef.observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                KRProgressHUD.dismiss()
                return
            }
            
            let post = Post(dictionary: dictionary)
            
//            self.posts.insert(post, at: 0)
            self.posts.append(post)
            
            DispatchQueue.main.async {
                KRProgressHUD.dismiss()
                self.tableView.reloadData()
            }
            
        }, withCancel: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            
            if self.posts.count == 0 {
                KRProgressHUD.dismiss()
                self.showErrorAlert(message: "Nothing to show")
            }
            
        })

        
    }
}

//MARK: setup background and views

extension HomeController {
    
    fileprivate func setupViews() {
        setupTabelView()
    }
    
    private func setupTabelView() {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        tableView = UITableView(frame: frame, style: .grouped)
        
        tableView.register(HomeCell.self, forCellReuseIdentifier: cellId)
        tableView.register(HomeCellHeader.self, forHeaderFooterViewReuseIdentifier: cellHeaderId)
    }
    
    fileprivate func setupBackground() {
        
        view.backgroundColor = .white
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        
        let refreshImage = UIImage(named: AssetName.refresh.rawValue)
        let refreshButton = UIBarButtonItem(image: refreshImage, style: .plain, target: self, action: #selector(fectchPosts))
        self.tabBarController?.navigationItem.leftBarButtonItem = refreshButton
    }
    
}
