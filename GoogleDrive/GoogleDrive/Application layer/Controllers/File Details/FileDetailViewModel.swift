//
//  FileDetailViewModel.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//


class FileDetailViewModel {
    
    var file : FileDataModel
    
    init(file:FileDataModel) {
        self.file = file
    }
    
    func isFileDownloaded(fileId: String) -> Bool{
        if let _ = DatabaseManager.sharedInstance.getFilePath(fileId: fileId) {
            return true
        }
        return false
    }
    
    public func download(progress: @escaping downloadProgress, onCompleted: @escaping (Bool) -> ()) {
        if file.mimeType.contains("vnd.google-apps"){
            GoogleServiceManager.sharedInstance.export(file.fileId, mimeType: "application/pdf", progress: progress, onCompleted: { (data, error) in
                if error == nil && data != nil {
                    let time = Date().timeIntervalSince1970
                    let fileName = String(format:"%0.f.pdf", time)
                    Utility.saveFile(file: data!, fileName: fileName)
                    DatabaseManager.sharedInstance.insertFilePath(fileId: self.file.fileId, filePath: fileName)
                    onCompleted(true)
                    return
                }
                onCompleted(false)
            })
        }else{
            GoogleServiceManager.sharedInstance.download(file.fileId, progress: progress, onCompleted:  { (data, error) in
                if error == nil && data != nil {
                    let path = self.file.mimeType.components(separatedBy: "/")
                    if path.count > 1 {
                        let time = Date().timeIntervalSince1970
                        let fileName = String(format:"%0.f.\(path.last ?? "")", time)
                        Utility.saveFile(file: data!, fileName: fileName)
                        DatabaseManager.sharedInstance.insertFilePath(fileId: self.file.fileId, filePath: fileName)
                        onCompleted(true)
                        return
                    }
                }
                onCompleted(false)
            })
        }
    }
}
