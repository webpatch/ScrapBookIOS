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

class ViewController: UIViewController {
    var pathArr = [String]()
    var allFiles = [String:[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataSubFolder()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ready", name: kGetDataSubFolderFinished, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "download", name: kStartDownload, object: nil)
    }
    
    func getDataSubFolder()
    {
        var r = NSMutableURLRequest(URL: NSURL(string:"https://api.dropbox.com/1/metadata/auto/ScrapBook/data")!)
        r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
        
        let op = AFHTTPRequestOperation(request: r)
        op.responseSerializer = AFHTTPResponseSerializer()
        op.setCompletionBlockWithSuccess({ (AFHTTPRequestOperation, responseObj) -> Void in
            let str = NSString(data: responseObj as NSData, encoding: NSUTF8StringEncoding)!
            let j = JSON(string:str)
            let contents = j["contents"].asArray!
            for i in contents
            {
                if(i["is_dir"].asBool!){
                    var str:String = i["path"].asString!
                    str.removeRange(Range<String.Index>(start: str.startIndex, end:advance(str.startIndex, 1)))
                    self.pathArr.append(str)
                }
            }
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name:kGetDataSubFolderFinished, object: nil))
        }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
                println(NSError)
        })
        NSOperationQueue.mainQueue().addOperation(op)
    }
    
    func download()
    {
        println(allFiles.count)
        
        var qs = [NSOperation]()
        let q = NSOperationQueue()
        q.maxConcurrentOperationCount = 5
        for (path,files) in allFiles {
            println(path,files)
            var docPath = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false, error: nil)!
            docPath = docPath.URLByAppendingPathComponent(path)
            NSFileManager.defaultManager().createDirectoryAtURL(docPath, withIntermediateDirectories: true, attributes: nil, error: nil)
            for file in files
            {
                var r = NSMutableURLRequest(URL: NSURL(string:"https://api-content.dropbox.com/1/files/auto\(file)")!)
                r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
               
                let op = AFHTTPRequestOperation(request: r)
                op.responseSerializer = AFHTTPResponseSerializer()
                op.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObj:AnyObject!) -> Void in
                    let d = responseObj as NSData
                    let outPath = docPath.URLByAppendingPathComponent(operation.response.suggestedFilename!)
                    println(outPath)
                    d.writeToURL(outPath, atomically: true)
                }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
                    println(NSError)
                })
                
                qs.append(op)
            }
        }
        let ops = AFURLConnectionOperation.batchOfRequestOperations(qs, progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
            println("\(numberOfFinishedOperations) / \(totalNumberOfOperations)")
            }) { (operations) -> Void in
                println("Download Complete!")
        }
        q.addOperations(ops, waitUntilFinished: false)
    }
    
    func ready()
    {
        var qs = [NSOperation]()
        for path in pathArr{
            var r = NSMutableURLRequest(URL: NSURL(string:"https://api.dropbox.com/1/metadata/auto/\(path)")!)
            r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
            
            let op = AFHTTPRequestOperation(request: r)
            op.responseSerializer = AFHTTPResponseSerializer()
            op.setCompletionBlockWithSuccess({ (AFHTTPRequestOperation, responseObj) -> Void in
                let str = NSString(data: responseObj as NSData, encoding: NSUTF8StringEncoding)!
                let j = JSON(string:str)
                let contents = j["contents"].asArray!
                var arr = [String]()
                for i in contents
                {
                   arr.append(i["path"].asString!)
                }
                self.allFiles["\(path)"] = arr
            }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
                    println(NSError)
            })
           qs.append(op)
        }
        
        let ops = AFURLConnectionOperation.batchOfRequestOperations(qs, progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
            println("\(numberOfFinishedOperations) / \(totalNumberOfOperations)")
        }) { (operations) -> Void in
            println("startDownload")
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: kStartDownload, object: nil))
        }
        NSOperationQueue.mainQueue().addOperations(ops, waitUntilFinished: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}