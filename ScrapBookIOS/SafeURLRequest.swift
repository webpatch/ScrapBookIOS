//
//  SafeURLRequest.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-29.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import Foundation
class SafeURLRequest:NSMutableURLRequest{
    init(path:NSString,token:String = "")
    {
        let url = path.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        super.init(URL: NSURL(string:url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 30)
        if !token.isEmpty {
           self.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }
    
    var HTTPBodyDict:NSDictionary?{
        didSet{
            var str = ""
            for (k,v) in HTTPBodyDict!{
                str += "\(k)=\(v)&"
            }
            str = str.remove(str.length-1, 1)
            self.HTTPBody = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}