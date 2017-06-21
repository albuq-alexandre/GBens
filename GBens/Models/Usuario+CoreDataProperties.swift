//
//  Usuario+CoreDataProperties.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 20/06/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import Foundation
import CoreData


extension Usuario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Usuario> {
        return NSFetchRequest<Usuario>(entityName: "Usuario")
    }

    @NSManaged public var codUser: String?
    @NSManaged public var foto: NSData?
    @NSManaged public var nome: String?
    @NSManaged public var password: String?
    @NSManaged public var bem_scanned: NSSet?
    @NSManaged public var dep_inventariada: NSSet?

}

// MARK: Generated accessors for bem_scanned
extension Usuario {

    @objc(addBem_scannedObject:)
    @NSManaged public func addToBem_scanned(_ value: Bem)

    @objc(removeBem_scannedObject:)
    @NSManaged public func removeFromBem_scanned(_ value: Bem)

    @objc(addBem_scanned:)
    @NSManaged public func addToBem_scanned(_ values: NSSet)

    @objc(removeBem_scanned:)
    @NSManaged public func removeFromBem_scanned(_ values: NSSet)

}

// MARK: Generated accessors for dep_inventariada
extension Usuario {

    @objc(addDep_inventariadaObject:)
    @NSManaged public func addToDep_inventariada(_ value: Dependencia)

    @objc(removeDep_inventariadaObject:)
    @NSManaged public func removeFromDep_inventariada(_ value: Dependencia)

    @objc(addDep_inventariada:)
    @NSManaged public func addToDep_inventariada(_ values: NSSet)

    @objc(removeDep_inventariada:)
    @NSManaged public func removeFromDep_inventariada(_ values: NSSet)

}
