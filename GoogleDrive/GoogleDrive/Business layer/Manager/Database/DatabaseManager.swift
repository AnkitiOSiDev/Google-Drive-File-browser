//
//  DatabaseManager.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import Foundation

protocol DBModule {
    func initialize()
    func getAllFiles() -> [String:Any]?
    func insertFilePath(fileId:String, filePath:String)
    func deleteFilePath(fileId:String, filePath:String)
    func getFilePath(fileId:String) -> String?
    func clearAllRecords()
    func deInitialize()
}

class  DatabaseManager  {
    static let sharedInstance = DatabaseManager()
    private var dbHandle : DBModule!
    
    private init (){
        //User default used to handle DB. We can replace the UserDefaultManager Manager with other Database manager Core data or Realm Manager
        dbHandle = UserDefaultManager()
    }
    
    /**
     This method is used to get list of downloaded files.
     - Returns:  Dictionary of all files list.
     */
    func getAllFiles() -> [String:Any]? {
       return  dbHandle.getAllFiles()
    }
    
    /**
     This method is used to save the downloaded file path in database.
     - Parameter  fileId:  The id of the file.
     - Parameter  filePath:  The path of saved file.
     - Returns:  No value.
     */
    func insertFilePath(fileId:String, filePath:String)  {
      dbHandle.insertFilePath(fileId: fileId, filePath: filePath)
    }

    /**
     This method is used to get path of saved file.
     - Parameter  fileId:  The id of the file.
     - Returns:  The path of saved file.
     */
    func getFilePath(fileId:String) -> String? {
       return dbHandle.getFilePath(fileId: fileId)
    }
    
    /**
     This method is used to deleted the downloaded file path in database.
     - Parameter  fileId:  The id of the file.
     - Parameter  filePath:  The path of saved file.
     - Returns:  No value.
     */
    func deleteFilePath(fileId:String, filePath:String)  {
        dbHandle.deleteFilePath(fileId: fileId, filePath: filePath)
    }
    
    /**
     This method is used to delete all record from database .
     - Returns:  No value.
     */
    func clearAllRecords(){
        dbHandle.clearAllRecords()
    }
    
}
