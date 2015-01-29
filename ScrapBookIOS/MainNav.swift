//
//  MainNav.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-29.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import UIKit

class MainNav: UINavigationController {
    override func viewDidLoad() {
        let sb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var v:UIViewController
        if Dropbox.sharedInstance().token.isEmpty{
            println("need link")
            v = sb.instantiateViewControllerWithIdentifier("LinkVC") as UIViewController
        }else{
            println("linked")
            v = sb.instantiateViewControllerWithIdentifier("MainTableVC") as UIViewController
        }
        self.pushViewController(v, animated: true)
        println(Path.document)
    }
}
