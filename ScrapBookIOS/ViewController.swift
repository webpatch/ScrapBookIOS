//
//  ViewController.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-20.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import UIKit

private let kGetDataSubFolderFinished = "kGetDataSubFolderFinished"
private let kStartDownload = "kStartDownload"


class ViewController: UITableViewController {
//    var pathArr = [String]()
//    var allFiles = [String:[String]]()
//    let docPath = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)!
//    var out  = NSMutableDictionary()
    
    var dataArr = [Folder]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        getDataSubFolder()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ready", name: kGetDataSubFolderFinished, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "download", name: kStartDownload, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "initRs", name: RDF.RDF_INIT_COMPLETE, object: nil)
        
        RDF.sharedInstance()
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("TableCell") as? UITableViewCell
        cell = cell ?? UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "TableCell")
        cell.textLabel!.text = dataArr[indexPath.row].title
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
//
    func initRs()
    {
//        dataArr = (RDF.sharedInstance().getFolderList("urn:scrapbook:root"))
//        println(dataArr)
//        println(NSThread.mainThread())
//        println(NSThread.currentThread())
//        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//           self.tableView.reloadData()
//        })
//        
        
    }

//    func insertChild(element:ONOXMLElement,nodeName:String,dict:NSMutableDictionary)
//    {
//        var tname = "root"
//        var isFolder = true
//        var id = ""
//        
//        if nodeName != "urn:scrapbook:root"
//        {
//            let descT:ONOXMLElement = element.firstChildWithXPath("//RDF:Description[@RDF:about='\(nodeName)']")
//            tname = descT["title"] as NSString
//            isFolder = descT["type"] as NSString ==  "folder"
//            id  = descT["id"] as NSString
//        }
//        dict[tname] = ["children":isFolder ? NSMutableDictionary() : NSNull(),"id":id]
//        
//        if let seq = element.firstChildWithXPath("//RDF:Seq[@RDF:about='\(nodeName)']"){
//            for child:ONOXMLElement in seq.children as [ONOXMLElement]
//            {
//                let rsName = child["resource"] as NSString
//                insertChild(element, nodeName: rsName,dict: dict[tname]!["children"]! as NSMutableDictionary)
//            }
//        }
//        
//    }
    
//    func getDataSubFolder()
//    {
//        var r = NSMutableURLRequest(URL: NSURL(string:"https://api.dropbox.com/1/metadata/auto/ScrapBook/data")!)
//        r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
//        
//        let op = AFHTTPRequestOperation(request: r)
//        op.responseSerializer = AFHTTPResponseSerializer()
//        op.setCompletionBlockWithSuccess({ (AFHTTPRequestOperation, responseObj) -> Void in
//            let str = NSString(data: responseObj as NSData, encoding: NSUTF8StringEncoding)!
//            let j = JSON(string:str)
//            let contents = j["contents"].asArray!
//            for i in contents
//            {
//                if(i["is_dir"].asBool!){
//                    var str:String = i["path"].asString!
//                    str.removeRange(Range<String.Index>(start: str.startIndex, end:advance(str.startIndex, 1)))
//                    self.pathArr.append(str)
//                }
//            }
//            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name:kGetDataSubFolderFinished, object: nil))
//        }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
//                println(NSError)
//        })
//        NSOperationQueue.mainQueue().addOperation(op)
//    }
//    
//    func download()
//    {
//        println(allFiles.count)
//        
//        var qs = [NSOperation]()
//        
//        for (path,files) in allFiles {
//            println(path,files)
//            let targetPath = docPath.URLByAppendingPathComponent(path)
//            NSFileManager.defaultManager().createDirectoryAtURL(targetPath, withIntermediateDirectories: true, attributes: nil, error: nil)
//            for file in files
//            {
//                var r = NSMutableURLRequest(URL: NSURL(string:"https://api-content.dropbox.com/1/files/auto\(file)")!)
//                r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
//               
//                let op = AFHTTPRequestOperation(request: r)
//                op.responseSerializer = AFHTTPResponseSerializer()
//                op.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObj:AnyObject!) -> Void in
//                    let d = responseObj as NSData
//                    let outPath = targetPath.URLByAppendingPathComponent(operation.response.suggestedFilename!)
//                    println(outPath)
//                    d.writeToURL(outPath, atomically: true)
//                }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
//                    println(error)
//                })
//                
//                qs.append(op)
//            }
//        }
//        let ops = AFURLConnectionOperation.batchOfRequestOperations(qs, progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
//            println("\(numberOfFinishedOperations) / \(totalNumberOfOperations)")
//        }) { (operations) -> Void in
//            println("Download Complete!")
//        }
//        
//        let q = NSOperationQueue()
//        q.maxConcurrentOperationCount = 5
//        q.addOperations(ops, waitUntilFinished: false)
//    }
//    
//    func ready()
//    {
//        var qs = [NSOperation]()
//        for path in pathArr{
//            var r = NSMutableURLRequest(URL: NSURL(string:"https://api.dropbox.com/1/metadata/auto/\(path)")!)
//            r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
//            
//            let op = AFHTTPRequestOperation(request: r)
//            op.responseSerializer = AFHTTPResponseSerializer()
//            op.setCompletionBlockWithSuccess({ (AFHTTPRequestOperation, responseObj) -> Void in
//                let str = NSString(data: responseObj as NSData, encoding: NSUTF8StringEncoding)!
//                let j = JSON(string:str)
//                let contents = j["contents"].asArray!
//                var arr = [String]()
//                for i in contents
//                {
//                   arr.append(i["path"].asString!)
//                }
//                self.allFiles["\(path)"] = arr
//            }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
//                    println(NSError)
//            })
//           qs.append(op)
//        }
//        
//        let ops = AFURLConnectionOperation.batchOfRequestOperations(qs, progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
//            println("\(numberOfFinishedOperations) / \(totalNumberOfOperations)")
//        }) { (operations) -> Void in
//            println("startDownload")
//            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: kStartDownload, object: nil))
//        }
//        NSOperationQueue.mainQueue().addOperations(ops, waitUntilFinished: false)
//    }
//



}