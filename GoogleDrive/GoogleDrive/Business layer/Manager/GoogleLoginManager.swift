//
//  GoogleLoginManager.swift
//  GoogleDrive
//
//  Created by Ankit on 21/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST

typealias loggedInHandler = (Bool) -> ()

class GoogleLoginManager : NSObject{
    
    static let sharedInstance = GoogleLoginManager()
    var completion : loggedInHandler?
    
    private override init (){
        super.init()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive]
    }

    /**
     This method is used to check user logged or not and authenticate service.
     - Parameter onCompletion: invoked when user log-in call.
     - Returns:  No value.
     */
    func checkUserLogIn(onCompletion: @escaping loggedInHandler){
        completion = onCompletion
        GIDSignIn.sharedInstance().signInSilently()
    }
}

// MARK: - GIDSignInDelegate
extension GoogleLoginManager: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let completion = completion else { return  }
        if let _ = error {
            completion(false)
        } else {
            GoogleServiceManager.sharedInstance.service.authorizer = GIDSignIn.sharedInstance()?.currentUser.authentication.fetcherAuthorizer()
          completion(true)
        }
    }
}

// MARK: - GIDSignInUIDelegate
extension GoogleLoginManager: GIDSignInUIDelegate {}
