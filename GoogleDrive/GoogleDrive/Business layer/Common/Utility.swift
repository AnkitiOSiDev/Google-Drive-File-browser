//
//  Utility.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import Foundation
import GoogleSignIn

class Utility: NSObject {
    /**
     This method is used to get file path.
     
     - Returns:  The Main storyboard file.
     */
    static func getMainStroryBoard() -> UIStoryboard {
        let stroyboard = UIStoryboard(name: "Main", bundle: nil)
        return stroyboard
    }
    
    /**
     This method is used to get file path.
     
     - Parameter  fileName:  The name of the saved file .
     - Returns:  The path of the saved file .
     */
    static func getFileUrl(fileName : String) -> String {
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
        return paths
    }
    
    /**
     This method is used to Save File.
     
     - Parameter  file:  The file data send to save in directory.
     - Parameter  fileName:  The name of the file to be saved.
     */
    static func saveFile(file: Data ,fileName : String)  {
        let fileManager = FileManager.default
        var paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String? = (paths[0] as? String)
        if let filePath = documentsDirectory?.appending("/\(fileName)") {
            fileManager.createFile(atPath: filePath, contents: file, attributes: nil)
        }
    }
    
    /**
     This method is used to delete file.
     
     - Parameter  fileName:  The name of the saved file .
     */
    static func deleteFile(fileName : String) {
        let fileManager = FileManager.default
        let path = getFileUrl(fileName: fileName)
        do {
            try fileManager.removeItem(atPath: path)
        } catch let error {
        }
    }
    
    static func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)
    }
    
    /**
     This method is used to get API key.
     
     */
    static func getGoogleKey() -> String? {
        return self.infoForKey("Google Client key")
    }
    
    /**
     This method is used to Logout user and clear user data.
     
     */
    static func logoutUser(){
        GIDSignIn.sharedInstance()?.signOut()
        self.deleteFiles()
        DatabaseManager.sharedInstance.clearAllRecords()
        NavigationManager.sharedInstance.switchToLoginScreen()
    }
    
    /**
     This method is used to delete user downloaded files.
     
     */
    static func deleteFiles() {
        if var files = DatabaseManager.sharedInstance.getAllFiles() {
            for ids in files.keys {
                if let name = files[ids] as? String {
                    deleteFile(fileName: name)
                }
            }
        }
    }
}
