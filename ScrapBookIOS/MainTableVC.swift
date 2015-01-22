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
        
//        NSTimer(timeInterval: 3, target: self, selector: "query", userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "query", userInfo: nil, repeats: true)
        RDF.sharedInstance().start{
            let folders = RDF.sharedInstance().getAllItemFolders()
            var ops = [NSOperation]()
            for folder in folders
            {
                let f = "/scrapbook/data/\(folder)".lowercaseString
                ops.append(Dropbox.sharedInstance().getFileMeta(f))
                let targetPath = self.docPath.URLByAppendingPathComponent(f)
                NSFileManager.defaultManager().createDirectoryAtURL(targetPath, withIntermediateDirectories: true, attributes: nil, error: nil)
            }
            let s = AFURLConnectionOperation.batchOfRequestOperations(ops, progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
                
            }, completionBlock: { (operations) -> Void in
//               println(Dropbox.sharedInstance().files)
//                Dropbox.sharedInstance().downloadFileToPath()
            })
            NSOperationQueue().addOperations(s, waitUntilFinished: false)
           
           self.dataArr = RDF.sharedInstance().getFolderList("urn:scrapbook:root")
           self.tableView.reloadData()
        }
        
    }
    
    func query()
    {
        println("query")
        Dropbox.sharedInstance().delta()
    }
  
}