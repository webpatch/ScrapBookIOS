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
    
    override func viewDidLoad() {
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:FolderTableCell? = tableView.dequeueReusableCellWithIdentifier("TableCell") as? FolderTableCell
        if cell == nil{
            cell = FolderTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TableCell")
        }
        let f = dataArr[indexPath.row]
        cell!.imageView!.image = UIImage(named:f.isFolder ? "folder" : "page_white_word")
        cell!.textLabel!.text = f.title
        cell!.textLabel!.numberOfLines = 0
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
            let b = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc = b.instantiateViewControllerWithIdentifier("ReaderVC") as ReaderVC
            vc.id = f.id
            vc.title = f.title
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
}