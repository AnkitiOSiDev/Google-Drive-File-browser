//
//  GoogleServiceManager.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

enum GDriveError: Error {
    case NoDataAtPath
}

typealias downloadProgress = (Int64, Int64) -> ()

class GoogleServiceManager {
    
    static let sharedInstance = GoogleServiceManager()
    var service: GTLRDriveService!
    
    private init (){
        service = GTLRDriveService()
        service.shouldFetchNextPages = false
    }

    /**
     This method is used to get list of files by folder name.
     - Parameter  folder:  The name of the parent folder.
     - Parameter  nextPageToken:  The token for the next page. (Optional).
     - Parameter onCompleted: invoked when files fetched.
     - Parameter filesList: fetched files(Optional).
     - Parameter error: error occured in getting list of files (Optional).
     - Returns:  No value.
     */
    public func listFilesInFolder(_ folder: String,nextPageToken:String?, onCompleted: @escaping (_ filesList: GTLRDrive_FileList?,_ error: Error?) -> ()) {
        search(folder) { (folderID, error) in
            guard let ID = folderID else {
                onCompleted(nil, error)
                return
            }
            self.listFiles(ID, nextPageToken: nextPageToken, onCompleted: onCompleted)
        }
    }
  
    /**
     This method is used to get list of files by folder id.
     - Parameter  folderID:  The id of the parent folder.
     - Parameter  nextPageToken:  The token for the next page. (Optional).
     - Parameter onCompleted: invoked when files fetched.
     - Parameter filesList: fetched files(Optional).
     - Parameter error: error occured in getting list of files (Optional).
     - Returns:  No value.
     */
    public func listFiles(_ folderID: String,nextPageToken: String?, onCompleted: @escaping (_ filesList: GTLRDrive_FileList?,_ error: Error?) -> ()) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 10
        query.q = "'\(folderID)' in parents"
        query.fields = "kind,nextPageToken,files(id,mimeType,name,webContentLink,size,iconLink)"
        if let token = nextPageToken {
            query.pageToken  = token
        }
        service.executeQuery(query) { (ticket, result, error) in
            onCompleted(result as? GTLRDrive_FileList, error)
        }
    }
   
    /**
     This method is used to download file by file id.
     - Parameter  fileID:  The id of the file.
     - Parameter  progress:  The progress of the download.
     - Parameter onCompleted: invoked when file downloaded.
     - Parameter data: fetched file data(Optional).
     - Parameter error: error occured in downloading of file (Optional).
     - Returns:  No value.
     */
    public func download(_ fileID: String,progress: @escaping downloadProgress, onCompleted: @escaping (_ data: Data?, _ error: Error?) -> ()) {
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileID)
        let request : URLRequest = service.request(for: query) as URLRequest
        let fetcher = service.fetcherService.fetcher(with: request)
        fetcher.authorizer = service.authorizer
        fetcher.receivedProgressBlock = progress
        fetcher.beginFetch { (data, error) in
            onCompleted(data, error)
        }
    }
    
    /**
     This method is used to export file by file id.
     - Parameter  fileID:  The id of the file.
     - Parameter  progress:  The progress of the export.
     - Parameter onCompleted: invoked when file exported.
     - Parameter data: fetched file data(Optional).
     - Parameter error: error occured in exporting of file (Optional).
     - Returns:  No value.
     */
    public func export(_ fileID: String,mimeType : String,progress: @escaping downloadProgress, onCompleted: @escaping (_ data: Data?, _ error: Error?) -> ()) {
        let query = GTLRDriveQuery_FilesExport.queryForMedia(withFileId: fileID,mimeType: mimeType)
        let request : URLRequest = service.request(for: query) as URLRequest
        let fetcher = service.fetcherService.fetcher(with: request)
        fetcher.authorizer = service.authorizer
        fetcher.receivedProgressBlock = progress
        fetcher.beginFetch { (data, error) in
            onCompleted(data, error)
        }
    }
    
    /**
     This method is used to search file id by file name.
     - Parameter onCompleted: invoked when file search complete.
     - Parameter identifier: fetched file identifier(Optional).
     - Parameter error: error occured in searching of file (Optional).
     - Returns:  No value.
     */
    public func search(_ fileName: String, onCompleted: @escaping (_ identifier: String?,_ error: Error?) -> ()) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 1
        query.q = "name contains '\(fileName)'"
        service.executeQuery(query) { (ticket, results, error) in
            onCompleted((results as? GTLRDrive_FileList)?.files?.first?.identifier, error)
        }
    }
}

