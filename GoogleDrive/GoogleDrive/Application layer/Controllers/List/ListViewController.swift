//
//  ListViewController.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import UIKit
import GoogleSignIn

class ListViewController: BaseViewController {
    
    @IBOutlet weak var tblFilesList: UITableView!
    var listViewModel: ListViewModel!
    let segueListToDetails = "listToDetails"
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    override func viewDidLoad() {
        currentController = Controllers.list
        super.viewDidLoad()
        listViewModel = ListViewModel(delegate: self)
        setupTableView()
        self.fetchFiles()
    }
    
    func setupTableView() {
        self.tblFilesList.register(ListTableViewCell.nib, forCellReuseIdentifier: ListTableViewCell.identifier)
        self.tblFilesList.dataSource = self
        self.tblFilesList.delegate = self
        self.tblFilesList.estimatedRowHeight = 50.0
        self.tblFilesList.rowHeight = UITableView.automaticDimension
        self.tblFilesList.tableFooterView = UIView()
    }
    
    func fetchFiles(){
        activityIndicatorView.isHidden = false
        listViewModel.fetchAllFiles()
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueListToDetails {
            if let controller = segue.destination as? FileDetailViewController, let indexPath = sender as? IndexPath {
                controller.file = listViewModel.arrFiles[safe:indexPath.row]
            }
        }
    }
    
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueListToDetails, sender: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.arrFiles.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins))  {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if cell.responds(to: #selector(setter: UIView.layoutMargins))  {
            cell.layoutMargins = .zero
        }
        
        if ((indexPath.row == (listViewModel.arrFiles.count-1)) && (listViewModel.nextPageToken != nil)) {
             self.fetchFiles()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell {
            if let file = listViewModel.arrFiles[safe:indexPath.row] {
                cell.file = file
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ListViewController : ListViewModelDelegate {
    func dataFetchCompleted(error: Error?) {
        DispatchQueue.main.async {
             self.activityIndicatorView.isHidden = true
        }
       
        if error == nil {
            var insertIndexPaths = [IndexPath]()
            if(listViewModel.arrFiles.count > 0){
                for i in listViewModel.previousCount..<listViewModel.arrFiles.count {
                    let indexPath:IndexPath = IndexPath(row: i, section: 0)
                    insertIndexPaths.append(indexPath)
                }
            }
            if insertIndexPaths.count > 0 {
                self.tblFilesList.beginUpdates()
                if insertIndexPaths.count > 0 {
                    self.tblFilesList.insertRows(at: insertIndexPaths, with: .fade)
                }
                self.tblFilesList.endUpdates()
            }
        }
    }
}
