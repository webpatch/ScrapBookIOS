//
//  Reflect.swift
//  MobileAsking
//
//  Created by Clinic on 14-12-3.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

import Foundation

class Reflect:NSObject {
    var propertys:[String]
    {
        let m = reflect(self)
        var s = [String]()
        for i in 0..<m.count
        {
            let (name,_)  = m[i]
            if name == "super"{continue}
            s.append(name)
        }
        return s
    }
}