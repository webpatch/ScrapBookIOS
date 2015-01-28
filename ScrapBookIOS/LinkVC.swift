//
//  LinkVC.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-28.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import UIKit

class LinkVC:UIViewController {
    
    override func viewDidLoad() {
        let s = GCDWebServer()
        var code = ""
        s.addDefaultHandlerForMethod("GET", requestClass: GCDWebServerRequest.self) { (req:GCDWebServerRequest!) -> GCDWebServerResponse! in
            println(req.query)
            code = req.query["code"] as NSString
            
            let o2 = ["code":code,"grant_type":"authorization_code","client_id":"vm6itv923vwov70","client_secret":"8whkfns7bu4b7zf","redirect_uri":"http://aaa"]
            let r2 = NSMutableURLRequest(URL: NSURL(string: "https://api.dropbox.com/1/oauth2/token")!)
            r2.HTTPMethod = "POST"
            r2.HTTPBody = o2.htmlParams.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            
            NSURLConnection.sendAsynchronousRequest(r2, queue: NSOperationQueue(), completionHandler: { (rs:NSURLResponse!, d:NSData!, e:NSError!) -> Void in
                println(NSString(data: d, encoding: NSUTF8StringEncoding))
            })
            
            return GCDWebServerDataResponse(HTML: "hello i like you")
        }
        
       s.startWithPort(8080, bonjourName: nil)
        
//        let o = ["response_type":"code","client_id":"vm6itv923vwov70"]
        let r = NSMutableURLRequest(URL: NSURL(string: "https://www.dropbox.com/1/oauth2/authorize?client_id=vm6itv923vwov70&response_type=code&redirect_uri=http://localhost:8080/callback".stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
        
        let v = UIWebView(frame: view.bounds)
        v.backgroundColor = UIColor.grayColor()
        view.addSubview(v)
        v.loadRequest(r)
    }
}
