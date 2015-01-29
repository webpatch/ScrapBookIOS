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
        startServer()
        
        let r = NSURLRequest(URL: NSURL(string: "https://www.dropbox.com/1/oauth2/authorize?client_id=vm6itv923vwov70&response_type=code&redirect_uri=http://localhost:8080/callback".stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
        let v = UIWebView(frame: view.bounds)
        v.backgroundColor = UIColor.grayColor()
        view.addSubview(v)
        v.loadRequest(r)
    }
    
    func startServer()
    {
        let server = GCDWebServer()
        server.addHandlerForMethod("GET", path: "/callback", requestClass: GCDWebServerRequest.self) { (rq:GCDWebServerRequest!) -> GCDWebServerResponse! in
            let code = rq.query["code"] as NSString
            let o2 = ["code":code,"grant_type":"authorization_code","client_id":"vm6itv923vwov70","client_secret":"8whkfns7bu4b7zf","redirect_uri":"http://localhost:8080/callback"]
            let r2 = NSMutableURLRequest(URL: NSURL(string: "https://api.dropbox.com/1/oauth2/token")!)
            r2.HTTPMethod = "POST"
            r2.HTTPBody = o2.htmlParams.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            
            NSURLConnection.sendAsynchronousRequest(r2, queue: NSOperationQueue(), completionHandler: { (rs:NSURLResponse!, d:NSData!, e:NSError!) -> Void in
                let j = JSON(data:d)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    Dropbox.sharedInstance().token = j["access_token"].stringValue
                    let sb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let v = sb.instantiateViewControllerWithIdentifier("MainTableVC") as UIViewController
                    self.navigationController?.pushViewController(v, animated: true)
                    println(NSString(data: d, encoding: NSUTF8StringEncoding)!)
                })
                server.stop()
            })
            return GCDWebServerDataResponse(HTML: "")
        }
        server.startWithPort(8080, bonjourName: nil)
    }
}
