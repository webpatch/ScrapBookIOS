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
