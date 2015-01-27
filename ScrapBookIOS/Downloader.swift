//
//  Downloader.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-26.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import Foundation
class Downloader:NSObject {
    var operations = [NSOperation]()
    var queque:NSOperationQueue!
    
    func start(completeBlock:()->Void)
    {
        let ops = AFURLConnectionOperation.batchOfRequestOperations(operations, progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("Fire", object: "\(numberOfFinishedOperations) / \(totalNumberOfOperations)")
            })
        }) { (operations) -> Void in
            println("Download Complete!")
            completeBlock()
        }
        queque.addOperations(ops, waitUntilFinished: false)
    }
    
    
    func appendDownloadTask(fileLink:String)
    {
        let targetPath = Path.document.stringByAppendingPathComponent(fileLink.lowercaseString)
        let url = ("https://api-content.dropbox.com/1/files/auto\(fileLink)" as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var r = NSMutableURLRequest(URL: NSURL(string:url)!)
        r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
        
        let op = AFHTTPRequestOperation(request: r)
        op.responseSerializer = AFHTTPResponseSerializer()
        op.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObj:AnyObject!) -> Void in
            let d = responseObj as NSData
            println(targetPath)
            d.writeToFile(targetPath, atomically: true)
        }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            println(error)
        })
        operations.append(op)
    }
    
    
    struct Static {
        static var instance:Downloader? = nil
        static var token:dispatch_once_t = 0
    }
    
    class func sharedInstance() -> Downloader! {
        dispatch_once(&Static.token) {
            Static.instance = self()
        }
        return Static.instance!
    }
    
    required override init()
    {
        super.init()
        queque = NSOperationQueue()
    }
}
