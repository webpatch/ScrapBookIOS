//
//  MainView.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-21.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import Foundation
class MainTableVC:FolderTableVC{
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if hasNetwork(){
//            NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "query", userInfo: nil, repeats: true)
//        }
        RDF.sharedInstance().start{
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