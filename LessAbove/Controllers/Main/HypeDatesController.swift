//
//  HypeDatesController.swift
//  LESSABOVE
//
//  Created by John Nik on 9/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase
import KRProgressHUD
import WBSegmentControl

enum HypeDatesControllerStatus {
    case All
    case Adidas
    case Nike
    case Jordan
    case Supreme
    case Other
}

protocol HypeDatesControllerDelegate {
    
    func reloadContentsData()
    
}

class HypeDatesController: UIViewController, APSGroupedTableDelegte, APSGroupedTableDataSource {
    
    let titles = ["All", "Adidas", "Nike", "Jordan", "Supreme"]
    
    var posts = [Post]()
    
    var selectedControllerStatus: HypeDatesControllerStatus = .All
    
    let category_bg = UIColor .white
    let content_bg = UIColor.white
    
    var tableData = [String:[Post]]()
    
    let segmentControl: WBSegmentControl = {
        let segment = WBSegmentControl()
        segment.segments = [TextSegment(text: "All"), TextSegment(text: "Adidas"), TextSegment(text: "Nike"), TextSegment(text: "Jordan"), TextSegment(text: "Supreme"), TextSegment(text: "Other")]
        segment.backgroundColor = StyleGuideManager.dateViewColor
        segment.style = .cover
        segment.selectedIndex = 0
        segment.segmentTextFontSize = 12.0
        segment.segmentForegroundColor = .gray
        segment.cover_color = .lightGray
        segment.segmentForegroundColorSelected = .white
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    let tableView: APSGroupedTableView = {
        let table = APSGroupedTableView()
        table.rowsCount = 10
        
        table.showsVerticalScrollIndicator = false
        
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackground()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func apstableview(_ tableView: APSGroupedTableView, numberOfRowsIn section: Int) -> Int {
        
        return tableData.count
    }
    
    func apstableview(_ tableView: APSGroupedTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let keys = Array(tableData.keys)
        let objectCount = tableData[keys[indexPath.row]]?.count
        return CGFloat(objectCount! * 250 + 20)
    }
    
    func apstableview(tableView:APSGroupedTableView , cellForRowAt indexPath:IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! APSGroupedTableViewCell
        let keys = Array(tableData.keys)
        cell.cellCategoryName = keys[indexPath.row]
        cell.cellItems = tableData[keys[indexPath.row]]!
        cell.backgroundColor = content_bg
        
        cell.category_bg = category_bg
        cell.separatorColor = UIColor.darkGray
        cell.content_bg = content_bg
        cell.categoryTitleColor = UIColor.white
        cell.customtextColor = UIColor.lightGray
        cell.shadowEnabled = false
        
        cell.selectionStyle = .none
        return cell;
    }
    
    //MARK: - APSTableView Delegate
    func apsTableView(tableView:APSGroupedTableView, didTap index:[Int]){
        print(index);
        let keys = Array(tableData.keys)
        if let post = self.tableData[keys[index[1]]]?[index[2]] {
            self.goingToPostDetailControllerWith(post: post)
        }
    }


}

//MARK: handle HypeDatesController delegate, reload contets data
extension HypeDatesController: HypeDatesControllerDelegate {
    func reloadContentsData() {
        self.fetchData()
    }
}

//MARK: going to postdetail
extension HypeDatesController {
    
    @objc fileprivate func goingToPostDetailControllerWith(post: Post) {
        let postDetailController = PostDetailController()
        postDetailController.post = post
        
        let navController = UINavigationController(rootViewController: postDetailController)
        navController.navigationBar.setGradientBackground(colors: StyleGuideManager.gradientColors)
        
        navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.present(navController, animated: true, completion: nil)
        
    }
}


//MARK fetch content data
extension HypeDatesController {
    
    @objc func fetchData() {
        KRProgressHUD.show()
        
        self.posts.removeAll()
        
        let childPost = self.returnTabBarStringWithSelection()
        
        let postsRef = Database.database().reference().child("posts").child(childPost).queryOrdered(byChild: "timestamp")
        postsRef.observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                KRProgressHUD.dismiss()
                return
            }
            
            //            self.posts.append(Post(dictionary: dictionary))
            
            let post = Post(dictionary: dictionary)
            
            self.posts.append(post)
            
        }, withCancel: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            
            if self.posts.count == 0 {
                KRProgressHUD.dismiss()
                self.tableData.removeAll()
                self.tableView.reloadData()
                self.showErrorAlert(message: "Nothing to show")
                
                return
            }
            
            var postSet = [String: [Post]]()
//            var postsArr = [Post]()
            
            var temp = -2
            
            firstLoop: for i in 0 ..< self.posts.count {
                
                if i <= temp {
                    continue
                }
                
                var postsArr = [Post]()
                let dateStr1 = returnDayAndMonthStringWith(timestamp: self.posts[i].timestamp!)
                
                postsArr.append(self.posts[i])
                if i == self.posts.count - 1 {
                    postSet[dateStr1] = postsArr
                }
                
                secondLoop: for j in i + 1 ..< self.posts.count {
                    let dateStr2 = returnDayAndMonthStringWith(timestamp: self.posts[j].timestamp!)
                    
                    if dateStr1 == dateStr2 {
                        
                        temp = j
                        
                        postsArr.append(self.posts[j])
                        
                        if temp == self.posts.count - 1 {
                            postSet[dateStr1] = postsArr
                            break firstLoop
                        }
                        
                    } else {
                        
                        
                        
                        temp = j - 1
                        
//                        if postsArr.count == 1 || j == i + 1 {
//                            postSet[dateStr1] = postsArr
//                        }
                        postSet[dateStr1] = postsArr
                        
                        continue firstLoop
                    }
                    
                }
                
            }
            
            KRProgressHUD.dismiss()
            self.tableData.removeAll()
            self.tableData = postSet
            self.tableView.reloadData()
            print("postset", postSet)
            
        })
        
    }
    
}

//MARK handle dropdown menu
extension HypeDatesController: WBSegmentControlDelegate {
    
    func segmentControl(_ segmentControl: WBSegmentControl, selectIndex newIndex: Int, oldIndex: Int) {
        
        if newIndex == 0 {
            self.selectedControllerStatus = .All
        } else if newIndex == 1 {
            self.selectedControllerStatus = .Adidas
        } else if newIndex == 2 {
            self.selectedControllerStatus = .Nike
        } else if newIndex == 3 {
            self.selectedControllerStatus = .Jordan
        } else if newIndex == 4 {
            self.selectedControllerStatus = .Supreme
        } else if newIndex == 5 {
            self.selectedControllerStatus = .Other
        }
        
        self.fetchData()
    }
}

//MARK: handle top tab bar

extension HypeDatesController {
    
    fileprivate func returnTabBarStringWithSelection() -> String {
        var tabStr = "all"
        if self.selectedControllerStatus == .All {
            tabStr = "all"
        } else if self.selectedControllerStatus == .Adidas {
            tabStr = "adidas"
        } else if self.selectedControllerStatus == .Nike {
            tabStr = "nike"
        } else if self.selectedControllerStatus == .Jordan {
            tabStr = "jordan"
        } else if self.selectedControllerStatus == .Supreme {
            tabStr = "supreme"
        } else if self.selectedControllerStatus == .Other {
            tabStr = "other"
        }
        return tabStr
    }
    
}

extension HypeDatesController {
    
    @objc func handlePost() {
        
        let createPostController = CreatePostController()
        createPostController.selectedPostChildName = self.returnTabBarStringWithSelection()
        createPostController.hypeDatesControllerDelegate = self
        let navController = UINavigationController(rootViewController: createPostController)
        navController.navigationBar.setGradientBackground(colors: StyleGuideManager.gradientColors)
        
        navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.present(navController, animated: true, completion: nil)
        
    }
    
}

//MARK: setup background and views

extension HypeDatesController {
    
    fileprivate func setupViews() {
        
        self.setupSegmentControl()
        self.setupAPSTableView()
        
    }
    
    private func setupSegmentControl() {
        segmentControl.delegate = self
        view.addSubview(segmentControl)
        
        segmentControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentControl.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupAPSTableView() {
        tableView.register(APSGroupedTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.apsDelegate = self
        tableView.apsDataSource = self
        
        view.addSubview(tableView)
        
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 0).isActive = true
        
    }
    
    fileprivate func setupBackground() {
        
        view.backgroundColor = .white
        let addPostImage = UIImage(named: AssetName.addPost.rawValue)?.withRenderingMode(.alwaysOriginal)
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: addPostImage, style: .plain, target: self, action: #selector(handlePost))
        
        let refreshImage = UIImage(named: AssetName.refresh.rawValue)
        let refreshButton = UIBarButtonItem(image: refreshImage, style: .plain, target: self, action: #selector(fetchData))
        self.tabBarController?.navigationItem.leftBarButtonItem = refreshButton
    }
    
    
    
    
}
