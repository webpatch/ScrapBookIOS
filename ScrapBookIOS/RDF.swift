//
//  RDF.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-21.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import Foundation

class Folder:NSObject{
    var title:String = ""
    var id:String = ""
    var type:String = ""
    var source:String = ""
}

extension Folder:Printable
{
    override var description:String{
        return "\(self.title)"
    }
}


class RDF:NSObject {
    class var RDF_INIT_COMPLETE:String {return "RDF_INIT_COMPLETE"}
    var doc:ONOXMLDocument!
    
    struct Static {
        static var instance:RDF? = nil
        static var token:dispatch_once_t = 0
    }
    
    class func sharedInstance() -> RDF! {
        dispatch_once(&Static.token) {
            Static.instance = self()
        }
        return Static.instance!
    }
    
    
    required override init()
    {
        super.init()
        
        var r = NSMutableURLRequest(URL: NSURL(string:"https://api-content.dropbox.com/1/files/auto/ScrapBook/scrapbook.rdf")!)
        r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
        println("start")
        let op = AFHTTPRequestOperation(request: r)
        op.responseSerializer = AFHTTPResponseSerializer()
        op.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObj:AnyObject!) -> Void in
            println("over")
            let d = responseObj as NSData
            self.doc = ONOXMLDocument(data: d, error: nil)
            println(NSThread.mainThread())
            println(NSThread.currentThread())
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
               NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "RDF_INIT_COMPLETE", object: nil))
//            })
        }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                println(error)
        })
        
        NSOperationQueue.mainQueue().addOperation(op)
    }
    
    class func getFolderList(nodeName:String) -> [Folder]
    {
//        var arr = [Folder]()
        
        let f2 = Folder()
        f2.title = "gg"
        
        let f3 = Folder()
        f3.title = "ggddd"
        
        
        let arr = [Folder(),f2,f3]
//        if let seq = self.doc.firstChildWithXPath("//RDF:Seq[@RDF:about='\(nodeName)']"){
//            for child:ONOXMLElement in seq.children as [ONOXMLElement]
//            {
//                let rsName = child["resource"] as NSString
//                let descNode:ONOXMLElement = self.doc.firstChildWithXPath("//RDF:Description[@RDF:about='\(rsName)']")
//                
//                let f = Folder()
//                f.title = descNode["title"] as NSString
//                f.id = descNode["id"] as NSString
//                f.type = descNode["type"] as NSString
//                f.source = rsName
//                arr.append(f)
//            }
//        }
        return arr
    }
    
}