//
//  ReaderVC.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-22.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import UIKit

class ReaderVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var id:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let p = Path.document.stringByAppendingPathComponent("/scrapbook/data/\(id)/index.html")
        var r = NSURLRequest(URL: NSURL(fileURLWithPath: p)!)
        webView.loadRequest(r)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
