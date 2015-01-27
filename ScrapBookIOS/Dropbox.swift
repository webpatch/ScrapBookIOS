//
//  Dropbox.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-22.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import UIKit

class Dropbox: NSObject {
    var files = [String]()
    var isSyncing = false
    
    func reset()
    {
        isSyncing = false
        NSUserDefaults.standardUserDefaults().setValue("", forKey: "cursor")
    }
    
    func delta()
    {
        if isSyncing { return }
        
        isSyncing = true
        
        var r = NSMutableURLRequest(URL: NSURL(string:"https://api.dropbox.com/1/delta")!)
        r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
        r.HTTPMethod = "POST"
        let cur = NSUserDefaults.standardUserDefaults().valueForKey("cursor") as? NSString ?? ""
        let params = ["cursor":cur,"locale":"","path_prefix":"/scrapbook","include_media_info":false]
        r.HTTPBody = params.htmlParams.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        NSURLConnection.sendAsynchronousRequest(r, queue: NSOperationQueue()) { (response:NSURLResponse!, data:NSData!, e:NSError!) -> Void in
            if e != nil { return }
            let json = JSON(data:data)
            
            let fm = NSFileManager.defaultManager()
            
            for i in json["entries"].arrayValue
            {
                let arr = i.arrayValue
                let path = Path.document.stringByAppendingPathComponent(arr[0].stringValue)
                // 删除
                if let o = arr[1].null
                {
                    println("Delete ")
                    fm.removeItemAtPath(path, error: nil)
                }else{
                    if let meta = arr[1].dictionary
                    {
                        if meta["is_dir"]!.boolValue{
                            println("modify Folder ")
                            fm.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil)
                        }else{
                            Downloader.sharedInstance().appendDownloadTask(arr[0].stringValue)
                            println("modify File ")
                        }
                    }
                }
            }
            
            Downloader.sharedInstance().start{
                NSUserDefaults.standardUserDefaults().setObject(json["cursor"].stringValue, forKey: "cursor")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.isSyncing = false
            }
        }
    }
    
//    func downloadFileToPath()
//    {
//        var qs = [NSOperation]()
//        let docPath = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)!
//        for file in files
//        {
//            let targetPath = docPath.URLByAppendingPathComponent(file)
//            
//            var r = NSMutableURLRequest(URL: NSURL(string:"https://api-content.dropbox.com/1/files/auto\(file)")!)
//            r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
//
//            let op = AFHTTPRequestOperation(request: r)
//            op.responseSerializer = AFHTTPResponseSerializer()
//            op.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObj:AnyObject!) -> Void in
//                let d = responseObj as NSData
//                println(targetPath)
//                d.writeToURL(targetPath, atomically: true)
//            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
//                println(error)
//            })
//
//            qs.append(op)
//        }
//        let ops = AFURLConnectionOperation.batchOfRequestOperations(qs, progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
//            println("\(numberOfFinishedOperations) / \(totalNumberOfOperations)")
//        }) { (operations) -> Void in
//            println("Download Complete!")
//        }
//        
//        NSOperationQueue().addOperations(ops, waitUntilFinished: false)
//    }
//    
//    
//    func getFileMeta(path:String)->AFHTTPRequestOperation
//    {
//        var r = NSMutableURLRequest(URL: NSURL(string:"https://api.dropbox.com/1/metadata/auto/\(path)")!)
//        r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
//        
//        let op = AFHTTPRequestOperation(request: r)
//        op.responseSerializer = AFHTTPResponseSerializer()
//        op.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObj:AnyObject!) -> Void in
//            let json = JSON(data:responseObj as NSData)
////            println(NSString(data: (responseObj as NSData), encoding: NSUTF8StringEncoding))
//            for content in json["contents"].arrayValue
//            {
//               self.files.append(content["path"].stringValue)
//            }
//        }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
//            println(error)
//        })
//        return op
//    }
    
    struct Static {
        static var instance:Dropbox? = nil
        static var token:dispatch_once_t = 0
    }
    
    class func sharedInstance() -> Dropbox! {
        dispatch_once(&Static.token) {
            Static.instance = self()
        }
        return Static.instance!
    }
    
    required override init()
    {
        super.init()
    }
}
