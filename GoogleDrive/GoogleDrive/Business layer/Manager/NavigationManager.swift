//
//  NavigationManager.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import Foundation
import UIKit

class  NavigationManager  {
    static let sharedInstance = NavigationManager()
    
    private init (){}
    
    /**
     This method is used to show list screen.
     - Returns:  No value.
     */
    func switchToFilesListScreen()  {
        AppDelegate.shared.window = UIWindow(frame: UIScreen.main.bounds)
        if  let navigationController = Utility.getMainStroryBoard().instantiateViewController(withIdentifier: ListViewController.identifierNavigation) as? UINavigationController {
            AppDelegate.shared.window!.rootViewController = navigationController
            AppDelegate.shared.window!.makeKeyAndVisible()
        }
    }
    
    /**
     This method is used to show login screen.
     - Returns:  No value.
     */
    func switchToLoginScreen()  {
        AppDelegate.shared.window = UIWindow(frame: UIScreen.main.bounds)
        if  let navigationController = Utility.getMainStroryBoard().instantiateViewController(withIdentifier: LoginViewController.identifierNavigation) as? UINavigationController {
            AppDelegate.shared.window!.rootViewController = navigationController
            AppDelegate.shared.window!.makeKeyAndVisible()
        }
    }
}
