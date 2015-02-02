//
//  ReaderVC.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-22.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import UIKit

class ReaderVC: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var webView: UIWebView!
    var id:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let p = Path.document.stringByAppendingPathComponent("/scrapbook/data/\(id)/index.html")
        var r = NSURLRequest(URL: NSURL(fileURLWithPath: p)!)
        webView.loadRequest(r)
        webView.delegate = self
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if let v = NSUserDefaults.standardUserDefaults().valueForKey(id) as? Double
        {
            println("load \(v)")
            adjustFontSize(v)
            stepper.value = v
        }
    }

    @IBAction func change(sender: UIStepper) {
        adjustFontSize(sender.value)
        println(sender.value)
        NSUserDefaults.standardUserDefaults().setDouble(sender.value, forKey: id)
    }
    
    func adjustFontSize(v:Double)
    {
        let s = "document.body.style.webkitTextSizeAdjust='\(v)%%'"
        webView.stringByEvaluatingJavaScriptFromString(s)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
