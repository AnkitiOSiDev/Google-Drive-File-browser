//
//  ListViewModel.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import Foundation

protocol ListViewModelDelegate: class  {
    func dataFetchCompleted(error: Error?)
}

class ListViewModel {
    
    weak var delegate : ListViewModelDelegate!
    var arrFiles = [FileDataModel]()
    var nextPageToken: String?
    var folderId : String?
    var previousCount = 0
    
    init(delegate:ListViewModelDelegate) {
        self.delegate = delegate
    }
    
    /// Fetch list of files
    func fetchAllFiles()  {
        // if folder id present directlty fetch files
        if let folderId = self.folderId {
            GoogleServiceManager.sharedInstance.listFiles(folderId, nextPageToken: nextPageToken) { [weak self] (response, error) in
                guard let _ = self else {
                    return
                }
                
                if error != nil {
                    self?.delegate.dataFetchCompleted(error: error)
                    return
                }
                self?.nextPageToken = response?.nextPageToken
                self?.previousCount = self?.arrFiles.count ?? 0
                if let files = response?.files {
                    for file in files {
                        self?.arrFiles.append(FileDataModel(fileName:(file.name ?? ""),fileId:(file.identifier ?? ""), iconLink: file.iconLink ?? "", mimeType: file.mimeType ?? "", fileSize: file.size ?? NSNumber(value: 0)))
                    }
                }
                self?.delegate.dataFetchCompleted(error: nil)
                return
            }
        }else{
            getFolderId()
        }
        
    }
    
    /// Fetch folder id
    func getFolderId(){
        GoogleServiceManager.sharedInstance.search("Google Drive") { [weak self] (identifier, error) in
            if error != nil {
                self?.delegate.dataFetchCompleted(error: error)
                return
            }
            self?.folderId = identifier
            self?.fetchAllFiles()
        }
    }
}
