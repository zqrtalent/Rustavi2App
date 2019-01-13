//
//  DataContextColtroller.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 11/17/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import CoreData
import os

public class DataAccessController : NSObject {
    
    public static let contextSaveNotificationName: Notification.Name = Notification.Name("contextSaveNotificationName")
    
    public init(completionClosure: @escaping () -> ()) {
        // Init super class.
        super.init()
        
        guard let managedObjectModel = self.managedObjectModel else {
            os_log("Error loading model from bundle", type: OSLogType.error)
            return
        }
        
        // Initialize persistent store condinator -> NSPersistentStoreCoordinator
        let psc = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        // Migrate store.
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            do{
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.sqliteFilePath, options: nil)
                DispatchQueue.main.async {
                    self.persistentStoteCoordinator = psc
                    completionClosure()
                }
            }
            catch{
                os_log("Error migrating store", type: OSLogType.error)
            }
        }
        
        // Add notification(s)
        NotificationCenter.default.addObserver(self, selector: #selector(DataAccessController.contextDidSaveMainQueueContext(notification:)), name: DataAccessController.contextSaveNotificationName, object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: properties
    
    private lazy var managedObjectModel:NSManagedObjectModel? = {
        // Initialize managed object model -> NSManagedObjectModel
        guard let sharedFrameworkBundle = Bundle(identifier: Settings.sharedFrameworkAppId) else{
            os_log("Error initializing bundle", type: OSLogType.error)
            return nil
        }
        
        guard let modelUrl = sharedFrameworkBundle.url(forResource: "Rustavi2Data", withExtension: "momd") else {
            os_log("Error loading model from bundle", type: OSLogType.error)
            return nil
        }
        return NSManagedObjectModel(contentsOf: modelUrl)
    }()
    
    private var sqliteFilePath:URL = {
        guard let docUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Settings.appGroupId) else {
            fatalError("Unable to resolve document directory")
        }
        return docUrl.appendingPathComponent("Rustavi2Data.sqlite")
    }()
    
    private var persistentStoteCoordinator: NSPersistentStoreCoordinator?
    
    lazy var managedObjectContext:NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoteCoordinator
        return managedObjectContext
    }()
    
    
    // MARK: notifications
    
    @objc func contextDidSaveMainQueueContext(notification: Notification) {
        self.synced(lock: self, closure: { () -> () in
            self.managedObjectContext.perform {
                self.managedObjectContext.mergeChanges(fromContextDidSave: notification)
            }
        })
    }
    
    func synced(lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
}
