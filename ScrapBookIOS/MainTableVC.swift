//
//  MainView.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-21.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import Foundation
class MainTableVC:UITableViewController {
    var dataArr:[Folder]!
    override func viewDidLoad() {
        super.viewDidLoad()
        println("load")
        dataArr = [Folder]()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "initRs", name: "RDF_INIT_COMPLETE", object: nil)
        
        RDF.sharedInstance()
    }
    
    @IBAction func test(sender: AnyObject) {
        
        let f2 = Folder()
        f2.title = "gg"
        
        let f3 = Folder()
        f3.title = "ggddd"
        
        
        self.dataArr = [Folder(),f2,f3]
        self.tableView.reloadData()
    }
    
    func initRs()
    {
        self.dataArr = RDF.getFolderList("urn:scrapbook:root")
        println(self.dataArr)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("update")
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("TableCell") as? UITableViewCell
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TableCell")
        }
        cell!.textLabel!.text = dataArr[indexPath.row].title
        return cell!
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
}