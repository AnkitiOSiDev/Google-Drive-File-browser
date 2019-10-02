//
//  ViewController.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class LoginViewController: BaseViewController {
    override func viewDidLoad() {
        currentController = Controllers.login
        super.viewDidLoad()
        setupGoogleSignIn()
        // Do any additional setup after loading the view, typically from a nib.
    }

    private func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive]
    }

}

// MARK: - GIDSignInDelegate
extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
        } else {
            GoogleServiceManager.sharedInstance.service.authorizer = GIDSignIn.sharedInstance()?.currentUser.authentication.fetcherAuthorizer()
            DispatchQueue.main.async {
               NavigationManager.sharedInstance.switchToFilesListScreen()
            }
        }
    }
}

// MARK: - GIDSignInUIDelegate
extension LoginViewController: GIDSignInUIDelegate {}
