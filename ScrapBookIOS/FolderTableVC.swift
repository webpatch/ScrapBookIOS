//
//  FolderTableVC.swift
//  ScrapBookIOS
//
//  Created by Kiny on 15-1-21.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import Foundation
class FolderTableVC:UITableViewController {
    var dataArr:[Folder] = [Folder]()
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("TableCell") as? UITableViewCell
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TableCell")
        }
        let f = dataArr[indexPath.row]
        cell!.textLabel!.text = f.isFolder ? "[文件夹] \(f.title)" : f.title
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let f = dataArr[indexPath.row]
        if f.isFolder
        {
            let v = FolderTableVC()
            v.dataArr = RDF.sharedInstance().getFolderList(f.source)
            v.title = f.title
            self.navigationController?.pushViewController(v, animated: true)
        }else{
            println("hello file \(f.id)")
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
}