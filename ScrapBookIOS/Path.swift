//
//  Path.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-26.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import Foundation
class Path:NSObject {
    class var document:String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    }
}