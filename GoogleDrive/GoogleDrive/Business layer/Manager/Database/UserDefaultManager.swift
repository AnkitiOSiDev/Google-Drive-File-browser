//
//  UserDefaultManager.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import Foundation

class  UserDefaultManager : DBModule  {
    
  
    private let kFiles = "key_files"
    
    func initialize() {
        
    }
    
    func insertFilePath(fileId: String, filePath: String) {
         if var files = getFiles() {
            files[fileId] = filePath
            UserDefaults.standard.set(files, forKey: kFiles)
         }else{
            let files = [fileId:filePath]
            UserDefaults.standard.set(files, forKey: kFiles)
        }
    }
    
    func deleteFilePath(fileId: String, filePath: String) {
        if var files = getFiles() {
            files[fileId] = nil
            UserDefaults.standard.set(files, forKey: kFiles)
        }
    }
    
    func getFilePath(fileId: String) -> String? {
        if let files = getFiles() {
            if let filePath = files[fileId] as? String {
                return filePath
            }
        }
        return nil
    }
    
    func getAllFiles() -> [String : Any]? {
        return getFiles()
    }
    
    func getFiles()-> [String:Any]? {
        if let value = UserDefaults.standard.object(forKey: kFiles) as? [String:Any] {
            return value
        }
        return nil
    }
        
    func clearAllRecords() {
        UserDefaults.standard.set(nil, forKey: kFiles)
    }
    
    func deInitialize() {
        
    }
    

}
