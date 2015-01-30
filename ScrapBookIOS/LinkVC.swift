//
//  LinkVC.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-28.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import UIKit

class LinkVC:UIViewController {
    private let client_id = "vm6itv923vwov70"
    private let client_secret = "8whkfns7bu4b7zf"
    private let callbackURL = "http://localhost:8080/callback"
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        startServer()
        loadLoginView()
    }
    
    func loadLoginView()
    {
        let r = NSURLRequest(URL: NSURL(string: "https://www.dropbox.com/1/oauth2/authorize?client_id=\(client_id)&response_type=code&redirect_uri=\(callbackURL)".stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
        webView.backgroundColor = UIColor.grayColor()
        webView.loadRequest(r)
    }
    
    func startServer()
    {
        let server = GCDWebServer()
        server.addHandlerForMethod("GET", path: "/callback", requestClass: GCDWebServerRequest.self) { (rq:GCDWebServerRequest!) -> GCDWebServerResponse! in
            let code = rq.query["code"] as NSString
            let arg = ["code":code,"grant_type":"authorization_code","client_id":self.client_id,"client_secret":self.client_secret,"redirect_uri":self.callbackURL]
            let rq = NSMutableURLRequest(URL: NSURL(string: "https://api.dropbox.com/1/oauth2/token")!)
            rq.HTTPMethod = "POST"
            rq.HTTPBody = arg.htmlParams.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            
            NSURLConnection.sendAsynchronousRequest(rq, queue: NSOperationQueue(), completionHandler: { (rs:NSURLResponse!, d:NSData!, e:NSError!) -> Void in
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
