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
    var isFolder:Bool{
        return type == "folder"
    }
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
    }
    
    
    func start(complete:()->Void)
    {
        var r = NSMutableURLRequest(URL: NSURL(string:"https://api-content.dropbox.com/1/files/auto/ScrapBook/scrapbook.rdf")!)
        r.addValue("Bearer Pug6-mtEkpIAAAAAAAAEBuyS-WWaUXlpG_VGHZn5EUzx9BJewqVuiOpIPfpXspi-", forHTTPHeaderField: "Authorization")
        println("start")
        let op = AFHTTPRequestOperation(request: r)
        op.responseSerializer = AFHTTPResponseSerializer()
        op.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObj:AnyObject!) -> Void in
            println("over")
            let d = responseObj as NSData
            self.doc = ONOXMLDocument(data: d, error: nil)
            complete()
        }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                println(error)
        })
        
        NSOperationQueue.mainQueue().addOperation(op)
    }
    
    func getFolderList(nodeName:String) -> [Folder]
    {
        var arr = [Folder]()
        if let seq = self.doc.firstChildWithXPath("//RDF:Seq[@RDF:about='\(nodeName)']"){
            for child:ONOXMLElement in seq.children as [ONOXMLElement]
            {
                let rsName = child["resource"] as NSString
                let descNode:ONOXMLElement = self.doc.firstChildWithXPath("//RDF:Description[@RDF:about='\(rsName)']")
                
                let f = Folder()
                f.title = descNode["title"] as NSString
                f.id = descNode["id"] as NSString
                f.type = descNode["type"] as NSString
                f.source = rsName
                arr.append(f)
            }
        }
        return arr
    }
    
    func getAllItemFolders()->[String]
    {
        var arr = [String]()
        self.doc.enumerateElementsWithXPath("//RDF:Description[@NS1:type='']", usingBlock: { (e:ONOXMLElement!, idx:UInt, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            arr.append(e["id"] as String)
        })
        return arr
    }
}