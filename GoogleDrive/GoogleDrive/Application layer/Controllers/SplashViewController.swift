//
//  SplashViewController.swift
//  GoogleDrive
//
//  Created by Ankit on 21/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        GoogleLoginManager.sharedInstance.checkUserLogIn { (isLoggedIn) in
            if isLoggedIn {
                NavigationManager.sharedInstance.switchToFilesListScreen()
            }else{
                NavigationManager.sharedInstance.switchToLoginScreen()
            }
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
