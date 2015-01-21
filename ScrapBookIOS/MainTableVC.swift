//
//  MainView.swift
//  ScrapBookIOS
//
//  Created by Clinic on 15-1-21.
//  Copyright (c) 2015年 Kiny. All rights reserved.
//

import Foundation
class MainTableVC:FolderTableVC,DBRestClientDelegate {
    
    var restClient:DBRestClient!
    
    let docPath = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let targetPath = docPath.URLByAppendingPathComponent("/ScrapBook")
//         NSFileManager.defaultManager().createDirectoryAtURL(targetPath, withIntermediateDirectories: true, attributes: nil, error: nil)
        
        let rdfPath = "/ScrapBook/scrapbook.rdf"
        NSFileManager.defaultManager().createDirectoryAtPath(docPath.path!.stringByAppendingPathComponent(rdfPath), withIntermediateDirectories: true, attributes: nil, error: nil)
        
        let db = DBSession(appKey: "vm6itv923vwov70", appSecret: "8whkfns7bu4b7zf", root: kDBRootDropbox)
        DBSession.setSharedSession(db)
        
        restClient = DBRestClient(session: db)
        restClient.delegate = self
        
//        restClient.loadFile("/ScrapBook/scrapbook.rdf", intoPath: "\(docPath.path!)/ScrapBook/scrapbook.rdf")
        restClient.loadFile("/scrapbook/data/20150120120833/process_thread_task.png", intoPath: "\(docPath.path!)/scrapbook/data/20150120120833/process_thread_task.png")
        
//        restClient.loadMetadata("/ScrapBook/data")
    }
    
    func restClient(client: DBRestClient!, loadFileFailedWithError error: NSError!) {
        println("There was an error loading the file: \(error) ")
    }
    
    
    func restClient(client: DBRestClient!, loadedFile destPath: String!, contentType: String!, metadata: DBMetadata!) {
        println("File loaded into path: \(destPath)")
    }
    
    func restClient(client: DBRestClient!, loadedMetadata metadata: DBMetadata!) {
        if(metadata.isDirectory)
        {
//            println("Folder \(metadata.path) contains:")
           NSFileManager.defaultManager().createDirectoryAtPath("\(docPath.path!)\(metadata.path)", withIntermediateDirectories: true, attributes: nil, error: nil)
            for file:DBMetadata in metadata.contents as [DBMetadata]
            {
                println("\(metadata.path)/\(file.filename)")
                restClient.loadFile("\(metadata.path)/\(file.filename)", intoPath: "\(docPath.path!)\(metadata.path)/\(file.filename)")
                if (file.isDirectory){
                    restClient.loadMetadata("/ScrapBook/data/\(file.filename!)")
                }
            }
        }
    }
    
    func restClient(client: DBRestClient!, loadMetadataFailedWithError error: NSError!) {
        println("Error loading metadata: \(error)")
    }
    
    
    @IBAction func press(sender: AnyObject) {
        if !DBSession.sharedSession().isLinked()
        {
            DBSession.sharedSession().linkFromController(self)
        }
    }
}