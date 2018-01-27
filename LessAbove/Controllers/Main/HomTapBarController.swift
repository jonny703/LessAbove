//
//  HomTapBarController.swift
//  LESSABOVE
//
//  Created by John Nik on 9/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase

class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupViews()
        setupControllers()
        checkIfUserIsLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
}

//MARK: handle controllers

extension HomeTabBarController {
    
    fileprivate func setupControllers() {
        
        var colors = [UIColor]()
        
        colors.append(StyleGuideManager.gradientFirstColor)
        colors.append(StyleGuideManager.gradientSecondColor)
        
        let homeController = HomeController()
        let homeBarItem = UITabBarItem(title: "Home", image: UIImage(named: AssetName.home.rawValue)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: AssetName.home.rawValue))
        homeController.tabBarItem = homeBarItem
        
        let hypeDatesController = HypeDatesController()
        let hypeDatesBarItem = UITabBarItem(title: "HypeDates", image: UIImage(named: AssetName.calendar.rawValue)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: AssetName.calendar.rawValue))
        hypeDatesController.tabBarItem = hypeDatesBarItem
        
        let profileController = ProfileController()
//        let profileNavController = UINavigationController(rootViewController: profileController)
        let profileBarItem = UITabBarItem(title: "Profile", image: UIImage(named: AssetName.userIcon.rawValue)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: AssetName.userIcon.rawValue))
        profileController.tabBarItem = profileBarItem
        
        
        
        viewControllers = [homeController, hypeDatesController, profileController]
        self.selectedViewController = homeController
    }
    
}

//MARK: check user log in 

extension HomeTabBarController {
    
    fileprivate func checkIfUserIsLoggedIn() {
        // user is not logged in
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogoff), with: nil, afterDelay: 0)
            
        } else {
            if let user = Auth.auth().currentUser {
                if !user.isEmailVerified {
                    perform(#selector(handleLogoff), with: nil, afterDelay: 0)
                }
            }
            
        }

    }
    
    @objc fileprivate func handleLogoff() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }

        
        let authController = AuthController()
        
        let naviController = UINavigationController(rootViewController: authController)
        present(naviController, animated: true, completion: nil)
    }
    
}

//MARK: Setup views

extension HomeTabBarController {
    
    fileprivate func setupViews() {
        setupNavigationBar()
        setupTabBar()
    }
    
    private func setupNavigationBar() {
        
        view.backgroundColor = .white
        
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        let image = UIImage(named: AssetName.lessabove.rawValue)
        titleImageView.image = image
        
        navigationItem.titleView = titleImageView
        
        
        
//         let leftButton = UIBarButtonItem(title: "Log off", style: .plain, target: self, action: #selector(handleLogoff))
//        leftButton.tintColor = .white
        navigationItem.leftBarButtonItem = nil
        
    }
    
    private func setupTabBar() {
        self.tabBar.tintColor = .white
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)

        self.tabBar.setGradientBackgroundUIView(colors: StyleGuideManager.gradientColors)
        
//        let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//        let layerGradient = CAGradientLayer(frame: rect, colors: StyleGuideManager.gradientColors)
//        self.tabBar.layer.addSublayer(layerGradient)
        
//        navigationBar.setGradientBackground(colors: colors)
//        self.tabBarController?.navigationController?.navigationBar.setGradientBackground(colors: colors)
//        self.navigationController?.navigationBar.setGradientBackground(colors: colors)
        
    }
    
}
