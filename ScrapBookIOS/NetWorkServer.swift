//
//  NetWorkServer.swift
//  MobileAsking
//
//  Created by Clinic on 15-1-13.
//  Copyright (c) 2015年 Clinic. All rights reserved.
//

import Foundation
class NetWorkServer {
    var status:AFNetworkReachabilityStatus!
    required init()
    {
        let url = NSURL(string:"https://www.dropbox.com")
        let m = AFHTTPRequestOperationManager(baseURL: url)
        let q = m.operationQueue
        m.reachabilityManager.setReachabilityStatusChangeBlock { (st:AFNetworkReachabilityStatus) -> Void in
            self.status = st
        }
        m.reachabilityManager.startMonitoring()
    }
    
    struct Static {
        static var instance:NetWorkServer? = nil
        static var token:dispatch_once_t = 0
    }
    
    class func sharedInstance() -> NetWorkServer! {
        dispatch_once(&Static.token) {
            Static.instance = self()
        }
        return Static.instance!
    }
}

func hasNetwork()->Bool
{
    let s = NetWorkServer.sharedInstance().status
    return s == .ReachableViaWiFi || s == .ReachableViaWWAN
}

func requireNetWork(fun:()->Void)
{
    if hasNetwork(){
        fun()
    }else{
       UIAlertView(title: "无网络", message: "您需要连接到网络才能使用该功能！", delegate: nil, cancelButtonTitle: "知道了").show()
    }
}

func requireNetWorkSilent(fun:()->Void)
{
    if hasNetwork()
    {
        fun()
    }
}