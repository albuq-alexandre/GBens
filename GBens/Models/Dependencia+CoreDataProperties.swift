//
//  Dependencia+CoreDataProperties.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 20/06/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import Foundation
import CoreData


extension Dependencia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dependencia> {
        return NSFetchRequest<Dependencia>(entityName: "Dependencia")
    }

    @NSManaged public var codUor: Int64
    @NSManaged public var nome: String?
    @NSManaged public var prefixo: String?
    @NSManaged public var bem_owner: NSSet?
    @NSManaged public var inventariante: NSSet?
    @NSManaged public var place_owner: NSSet?

}

// MARK: Generated accessors for bem_owner
extension Dependencia {

    @objc(addBem_ownerObject:)
    @NSManaged public func addToBem_owner(_ value: Bem)

    @objc(removeBem_ownerObject:)
    @NSManaged public func removeFromBem_owner(_ value: Bem)

    @objc(addBem_owner:)
    @NSManaged public func addToBem_owner(_ values: NSSet)

    @objc(removeBem_owner:)
    @NSManaged public func removeFromBem_owner(_ values: NSSet)

}

// MARK: Generated accessors for inventariante
extension Dependencia {

    @objc(addInventarianteObject:)
    @NSManaged public func addToInventariante(_ value: Usuario)

    @objc(removeInventarianteObject:)
    @NSManaged public func removeFromInventariante(_ value: Usuario)

    @objc(addInventariante:)
    @NSManaged public func addToInventariante(_ values: NSSet)

    @objc(removeInventariante:)
    @NSManaged public func removeFromInventariante(_ values: NSSet)

}

// MARK: Generated accessors for place_owner
extension Dependencia {

    @objc(addPlace_ownerObject:)
    @NSManaged public func addToPlace_owner(_ value: Localizacao)

    @objc(removePlace_ownerObject:)
    @NSManaged public func removeFromPlace_owner(_ value: Localizacao)

    @objc(addPlace_owner:)
    @NSManaged public func addToPlace_owner(_ values: NSSet)

    @objc(removePlace_owner:)
    @NSManaged public func removeFromPlace_owner(_ values: NSSet)

}
