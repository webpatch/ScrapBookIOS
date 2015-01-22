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
        let docPath = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)!
        let p = docPath.path?.stringByAppendingPathComponent("/scrapbook/data/\(id)/index.html")
        var r = NSURLRequest(URL: NSURL(fileURLWithPath: p!)!)
        webView.loadRequest(r)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
