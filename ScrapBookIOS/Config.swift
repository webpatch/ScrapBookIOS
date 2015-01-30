//
//  Config.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-29.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import Foundation
class Config:NSObject {
   
    struct Static {
        static var instance:Config? = nil
        static var token:dispatch_once_t = 0
    }
    
    class func sharedInstance() -> Config! {
        dispatch_once(&Static.token) {
            Static.instance = self()
        }
        return Static.instance!
    }
    
    required override init()
    {
        super.init()
    }
}