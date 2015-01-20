//
//  ViewController.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-20.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 var pathArr = [String]()
    
    var allFiles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var r = NSMutableURLRequest(URL: NSURL(string:"https://api.dropbox.com/1/metadata/auto/ScrapBook/data")!)
        r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
        
        let op = AFHTTPRequestOperation(request: r)
        op.responseSerializer = AFHTTPResponseSerializer()
        op.setCompletionBlockWithSuccess({ (AFHTTPRequestOperation, responseObj) -> Void in
            println(responseObj )
            let d = responseObj as NSData;
            let m3u8 = NSString(data: d, encoding: NSUTF8StringEncoding)!
            let j  = JSON(string:m3u8)
            let contents = j["contents"].asArray!
            for i in contents
            {
                if(i["is_dir"].asBool!){
                   println(i["path"])
                    self.pathArr.append(i["path"].asString!)
                }
            }
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "jj", object: nil))
        }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
           println(NSError)
        })
        NSOperationQueue().addOperation(op)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ready", name: "jj", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "download", name: "startDownload", object: nil)
    }
    
    func download()
    {
//        let q = NSOperationQueue()
//        q.maxConcurrentOperationCount = 5
        for path in allFiles{
            var r = NSMutableURLRequest(URL: NSURL(string:"https://api-content.dropbox.com/1/files/auto/\(path)")!)
            r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
           
            let c = NSURLSessionConfiguration.defaultSessionConfiguration()
            let m = AFURLSessionManager(sessionConfiguration: c)
            
            let task = m.downloadTaskWithRequest(r, progress: nil, destination: { (targetPath, response) -> NSURL! in
                let doc = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false, error: nil)
                println(doc)
                return doc!.URLByAppendingPathComponent((response as NSURLResponse).suggestedFilename!)
            }, completionHandler: { (NSURLResponse, NSURL, NSError) -> Void in
                println("File downloaded to: \(NSURL)")
            })
            task.resume()
//            let op = AFHTTPRequestOperation(request: r)
//            op.responseSerializer = AFHTTPResponseSerializer()
//            op.setCompletionBlockWithSuccess({ (AFHTTPRequestOperation, responseObj) -> Void in
//                    println(responseObj)
//            }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
//                    println(NSError)
//            })
//            q.addOperation(op)
        }
    }
    
    func ready()
    {
        println("ok")
        let q = NSOperationQueue()
        q.maxConcurrentOperationCount = 5
        for path in pathArr{
            var r = NSMutableURLRequest(URL: NSURL(string:"https://api.dropbox.com/1/metadata/auto/\(path)")!)
            r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
            
            let op = AFHTTPRequestOperation(request: r)
            op.responseSerializer = AFHTTPResponseSerializer()
            op.setCompletionBlockWithSuccess({ (AFHTTPRequestOperation, responseObj) -> Void in
                let d = responseObj as NSData;
                let m3u8 = NSString(data: d, encoding: NSUTF8StringEncoding)!
                let j  = JSON(string:m3u8)
                let contents = j["contents"].asArray!
                for i in contents
                {
                    self.allFiles.append(i["path"].asString!)
                }
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "startDownload", object: nil))
                }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
                    println(NSError)
            })
            q.addOperation(op)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}