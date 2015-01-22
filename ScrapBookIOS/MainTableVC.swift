//
//  MainView.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-21.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import Foundation
class MainTableVC:FolderTableVC{
    
    
    let docPath = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RDF.sharedInstance().start{
            let folders = RDF.sharedInstance().getAllItemFolders()
            var ops = [NSOperation]()
            for folder in folders
            {
                ops.append(Dropbox.sharedInstance().getFileMeta("/ScrapBook/data/\(folder)"))
                let targetPath = self.docPath.URLByAppendingPathComponent("/ScrapBook/data/\(folder)")
                NSFileManager.defaultManager().createDirectoryAtURL(targetPath, withIntermediateDirectories: true, attributes: nil, error: nil)
            }
            let s = AFURLConnectionOperation.batchOfRequestOperations(ops, progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
                
            }, completionBlock: { (operations) -> Void in
               println(Dropbox.sharedInstance().files)
                Dropbox.sharedInstance().downloadFileToPath()
            })
            NSOperationQueue().addOperations(s, waitUntilFinished: false)
           
           self.dataArr = RDF.sharedInstance().getFolderList("urn:scrapbook:root")
           self.tableView.reloadData()
        }
    }
  
}