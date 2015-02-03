//
//  LinkVC.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-28.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import UIKit

class LinkVC:UIViewController,UIWebViewDelegate {
    private let client_id = "ht7uybl6q1plcqy"
    private let client_secret = "1pio0sc5ea4g7e1"
    private let callbackURL = "http://localhost:8080/callback"
    
    private var ac:UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        initView()
        startMonitorURLCallBack()
        loadLoginView()
    }
    
    func initView()
    {
        ac = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.view.addSubview(ac)
        ac.hidesWhenStopped = true
        ac.stopAnimating()
        ac.center = view.center
        
        webView.delegate = self
    }

    func loadLoginView()
    {
        let r = NSURLRequest(URL: NSURL(string: "https://www.dropbox.com/1/oauth2/authorize?client_id=\(client_id)&response_type=code&redirect_uri=\(callbackURL)".stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
        webView.loadRequest(r)
    }
    
    @IBAction func reload(sender: UIBarButtonItem) {
        loadLoginView()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        let a = UIAlertView(title: "Error", message: "Can't load the DropBox login page", delegate: nil, cancelButtonTitle: "I know")
        a.show()
        ac.stopAnimating()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
       ac.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
       ac.stopAnimating()
    }
    
    func startMonitorURLCallBack()
    {
        let server = GCDWebServer()
        server.addHandlerForMethod("GET", path: "/callback", requestClass: GCDWebServerRequest.self) { (rq:GCDWebServerRequest!) -> GCDWebServerResponse! in
            let code = rq.query["code"] as NSString
            let rq = SafeURLRequest(path: "https://api.dropbox.com/1/oauth2/token")
            rq.HTTPMethod = "POST"
            rq.HTTPBodyDict = ["code":code,"grant_type":"authorization_code","client_id":self.client_id,"client_secret":self.client_secret,"redirect_uri":self.callbackURL]
            
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
