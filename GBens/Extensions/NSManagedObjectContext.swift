//
//  NSManagedObjectContext.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 24/06/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    func managedObjectContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! GBensAppDelegate).persistentContainer.viewContext
    }
}
