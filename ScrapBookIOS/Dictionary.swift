//
//  Dictionary.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-26.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import Foundation
extension Dictionary
{
    var htmlParams:String
    {
        var str = ""
        for (k,v) in self{
            str += "\(k)=\(v)&"
        }
        return str.remove(str.length-1, 1)
    }
}

extension NSDictionary
{
    var htmlParams:String
        {
            var str = ""
            for (k,v) in self{
                str += "\(k)=\(v)&"
            }
            return str.remove(str.length-1, 1)
    }
}