//
//  SettingController.swift
//  LESSABOVE
//
//  Created by John Nik on 9/10/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase

class SettingController: UITableViewController {
    
    
    
    var privacyCell: UITableViewCell = UITableViewCell()
    var termsCell: UITableViewCell = UITableViewCell()
    var logoutCell: UITableViewCell = UITableViewCell()
    var userDeleteCell: UITableViewCell = UITableViewCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 || section == 1 {
            return 2
        }
        
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                return self.privacyCell
            } else {
                return self.termsCell
            }
            
        } else {
            if indexPath.row == 0 {
                return self.logoutCell
            } else {
                return self.userDeleteCell
            }
        }
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        if section == 0 {
//            
//            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 60))
//            containerView.backgroundColor = .gray
//            
//            let label = UILabel(frame: CGRect(x: 20, y: 20, width: DEVICE_WIDTH, height: 40))
//            label.text = "Agreement"
//            label.textColor = .white
//            label.textAlignment = .left
//            
//            containerView.addSubview(label)
//            
//            return "Agreement"
//        } else {
//            return "User Management"
//        }
//        
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
        } else {
            if indexPath.row == 0 {
                
                self.showErrorAlertActionStringsWith("Log Out", message: "Are you sure you want to log out?", okActionStr: "Yes", cancelActionStr: "No", action: { (action) in
                    self.handleLogoff()
                }, completion: nil)
                
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 60))
        containerView.backgroundColor = StyleGuideManager.sectionColor
        
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: DEVICE_WIDTH, height: 40))
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .left
        
        containerView.addSubview(label)
        if section == 0 {
            
            label.text = "Agreement"
            
            return containerView
        } else {
            
            label.text = "User Management"
            
            return containerView
        }

        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

}

//MARK: handle dismiss, logoff
extension SettingController {
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func handleLogoff() {
        
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

//MARK: handle background and nav bar

extension SettingController {
    
    fileprivate func setupViews() {
        setupBackground()
        setupNavBar()
        setupCells()
        setupTableView()
    }
    
    private func setupTableView() {
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        
    }
    
    private func setupCells() {
        
        let privacyLabel = UILabel(frame: self.privacyCell.contentView.bounds.insetBy(dx: 15, dy: 0))
        privacyLabel.text = "Privacy Policy"
        privacyLabel.textAlignment = .left
        
        privacyCell.addSubview(privacyLabel)
        
        let termsLabel = UILabel(frame: self.termsCell.contentView.bounds.insetBy(dx: 15, dy: 0))
        termsLabel.text = "Terms of Service"
        termsLabel.textAlignment = .left
        
        termsCell.addSubview(termsLabel)
        
        let logoutLabel = UILabel(frame: self.logoutCell.contentView.bounds.insetBy(dx: 15, dy: 0))
        logoutLabel.text = "Log Out"
        logoutLabel.textAlignment = .left
        
        logoutCell.addSubview(logoutLabel)
        
        let userDeleteLabel = UILabel(frame: self.userDeleteCell.contentView.bounds.insetBy(dx: 15, dy: 0))
        userDeleteLabel.text = "Delete my account"
        userDeleteLabel.textColor = .red
        userDeleteLabel.textAlignment = .left
        
        userDeleteCell.addSubview(userDeleteLabel)
    }
    
    private func setupBackground() {
        
        view.backgroundColor = .white
        
    }
    
    private func setupNavBar() {
        
        navigationItem.title = "Setting"
        
        
        let image = UIImage(named: AssetName.cross.rawValue)
        let dismissButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(dismissController))
        dismissButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = dismissButton
        
        
    }
    
}
