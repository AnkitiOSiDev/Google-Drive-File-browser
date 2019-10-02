//
//  BaseViewController.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var identifierNavigation: String {
        return "\(String(describing: self))Navigation"
    }
    
    enum Controllers {
        case login
        case list
        case detail
        case webView
        
        var title : String {
            switch self {
            case .login:
                return "Login"
            case .list:
                return "List".uppercased()
            case .detail:
                return "Detail".uppercased()
            case .webView:
                return "Detail".uppercased()
            }
        }
        
        var isShowLogout : Bool {
            switch self {
            case .login:
                return false
            case .list:
                return true
            case .detail:
                return true
            case .webView:
                return false
            }
        }
    }
    
    var currentController : Controllers = .login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = currentController.title
        setupRightBarButtons()
        
    }
    
    func setupRightBarButtons(){
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem()]
        if  currentController.isShowLogout {
            let button = addRightbarButton(text: "Logout")
            button.addTarget(self, action: #selector(logout(button:)), for: .touchUpInside)
            self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView: button))
        }
    }
    
    func addRightbarButton(text: String) -> UIButton {
        let button = UIButton.init(type: .custom)
        button.setTitleColor(UIColor.black, for: .normal)
        button.frame = CGRect(x: 0.0, y: 5.0, width: 50.0, height: 30.0)
        button.setTitle(text, for: .normal)
        return button
    }
    
    @objc func logout(button: UIButton) {
        Utility.logoutUser()
    }
}
