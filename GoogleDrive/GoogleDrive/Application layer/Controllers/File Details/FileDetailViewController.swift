//
//  FileDetailViewController.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import UIKit

class FileDetailViewController: BaseViewController {
    
    @IBOutlet weak var imgViewLink: UIImageView!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var file : FileDataModel?
    var fileDetailViewModel : FileDetailViewModel!
    
    let segueDetailsToWebView = "detailsToWebView"
    
    override func viewDidLoad() {
        self.currentController = .detail
        super.viewDidLoad()
        if let file = file{
            fileDetailViewModel = FileDetailViewModel(file: file)
        }
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        
        lblFileName.text = ""
        self.progressView.isHidden = true
        
        guard let file = file else { return  }
        lblFileName.text = file.fileName
        imgViewLink.loadImageUsingCache(file.iconLink)
        
        if fileDetailViewModel.isFileDownloaded(fileId: file.fileId) {
            btnView.setTitle("View", for: .normal)
        }else{
            btnView.setTitle("Download", for: .normal)
            let totalFileSize = file.fileSize.floatValue
            if totalFileSize > 1 { // For doc files no size found as we are exporting the to pdf format
                self.progressView.isHidden = false
            }
        }
        
    }
    
    
    
    @IBAction func btnViewDidCicked(_ sender: Any) {
        
        guard let file = file else { return  }
        if let fileName = DatabaseManager.sharedInstance.getFilePath(fileId: file.fileId) {
            let path = Utility.getFileUrl(fileName: fileName)
            performSegue(withIdentifier: segueDetailsToWebView, sender: path)
            return
        }
        
        self.btnView.isEnabled = false
        self.activityIndicator.isHidden = false
        let totalFileSize = file.fileSize.floatValue
        fileDetailViewModel.download(progress: { (written, total) in
            if self.progressView != nil {
                if totalFileSize > 0 { // For doc files no size found as we are exporting the to pdf format
                    let progressCalc: Float = (Float(total)/(totalFileSize))
                    DispatchQueue.main.async {
                        self.progressView.progress = progressCalc
                    }
                }
            }
        }) { (isDownloaded) in
            self.btnView.isEnabled = true
            self.activityIndicator.isHidden = true
            if isDownloaded {
                self.btnView.setTitle("View", for: .normal)
            }
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueDetailsToWebView {
            if let controller = segue.destination as? InAppWebViewViewController, let path = sender as? String {
                controller.filePath = path
                controller.fileName = file?.fileName
            }
        }
    }
    
    
}
