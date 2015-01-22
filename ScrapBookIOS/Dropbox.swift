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
    
    func delta()
    {
        var r = NSMutableURLRequest(URL: NSURL(string:"https://api.dropbox.com/1/delta")!)
        r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
        r.HTTPMethod = "POST"
        
        let cur = NSUserDefaults.standardUserDefaults().valueForKey("cursor") as? NSString ?? ""
        let params = ["cursor":cur,"locale":"","path_prefix":"/scrapbook","include_media_info":false]
        let rPost = AFHTTPRequestSerializer().requestBySerializingRequest(r, withParameters: params, error: nil)
        let op = AFHTTPRequestOperation(request: rPost)
        op.responseSerializer = AFHTTPResponseSerializer()
        op.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObj:AnyObject!) -> Void in
            let json = JSON(data:responseObj as NSData)
            let arr = json["entries"].asArray!
            for i in arr
            {
                let a = i.asArray!
//                println(a)
                if let o = a[1].asNull?
                {
                    println("Delete ")
                }else{
                    if let j = a[1].asDictionary?
                    {
                        if j["is_dir"]!.asBool!{
                            println("modify Folder ")
                        }else{
                            println("modify File ")
                        }
                    }
                }
            }
//            println(json["entries"].asArray!)
//            self.parseEntries(json["entries"].asArray!)
//            println(NSString(data: responseObj as NSData, encoding: NSUTF8StringEncoding)!)
            NSUserDefaults.standardUserDefaults().setObject(json["cursor"].asString!, forKey: "cursor")
            NSUserDefaults.standardUserDefaults().synchronize()
        }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            println(error)
        })
        op.start()
    }
    
    private func parseEntries(arr:NSArray)
    {
        for obj in arr
        {
            let oArr = (obj as JSON).asArray! as NSArray
            if oArr.lastObject! as NSObject == NSNull()
            {
                println("Delete \(oArr.firstObject)")
            }else{
                if let dic = oArr.lastObject as? JSON
                {
                    if dic["is_dir"].asBool!{
                        println("modify Folder \(oArr.firstObject)")
                    }else{
                        println("modify File \(oArr.firstObject)")
                    }
                    
                }
            }
        }
    }
    
    func downloadFileToPath()
    {
        var qs = [NSOperation]()
        let docPath = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)!
        for file in files
        {
            let targetPath = docPath.URLByAppendingPathComponent(file)
            
            var r = NSMutableURLRequest(URL: NSURL(string:"https://api-content.dropbox.com/1/files/auto\(file)")!)
            r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")

            let op = AFHTTPRequestOperation(request: r)
            op.responseSerializer = AFHTTPResponseSerializer()
            op.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObj:AnyObject!) -> Void in
                let d = responseObj as NSData
                println(targetPath)
                d.writeToURL(targetPath, atomically: true)
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                println(error)
            })

            qs.append(op)
        }
        let ops = AFURLConnectionOperation.batchOfRequestOperations(qs, progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
            println("\(numberOfFinishedOperations) / \(totalNumberOfOperations)")
        }) { (operations) -> Void in
            println("Download Complete!")
        }
        
        NSOperationQueue().addOperations(ops, waitUntilFinished: false)
    }
    
    
    func getFileMeta(path:String)->AFHTTPRequestOperation
    {
        var r = NSMutableURLRequest(URL: NSURL(string:"https://api.dropbox.com/1/metadata/auto/\(path)")!)
        r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
        
        let op = AFHTTPRequestOperation(request: r)
        op.responseSerializer = AFHTTPResponseSerializer()
        op.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObj:AnyObject!) -> Void in
            let json = JSON(data:responseObj as NSData)
//            println(NSString(data: (responseObj as NSData), encoding: NSUTF8StringEncoding))
            for content in json["contents"].asArray!
            {
               self.files.append(content["path"].asString!)
            }
        }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            println(error)
        })
        return op
    }
    
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
