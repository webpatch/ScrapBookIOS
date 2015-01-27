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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUI:", name: "Fire", object: nil)
        RDF.sharedInstance().start{
            self.dataArr = RDF.sharedInstance().getFolderList("urn:scrapbook:root")
            self.tableView.reloadData()
        }
        query()
    }
    
    func query()
    {
        println("query")
        Dropbox.sharedInstance().delta()
    }
    
    func updateUI(ns:NSNotification)
    {
        self.title = ns.object as NSString
//        ns.userInfo
    }
  
}