//
//  Localizacao+CoreDataProperties.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 20/06/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import Foundation
import CoreData


extension Localizacao {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Localizacao> {
        return NSFetchRequest<Localizacao>(entityName: "Localizacao")
    }

    @NSManaged public var andar: Int16
    @NSManaged public var codLoc: Int64
    @NSManaged public var endereco: String?
    @NSManaged public var sala: String?
    @NSManaged public var setor: String?
    @NSManaged public var bem_place: NSSet?
    @NSManaged public var dep_onwer: Dependencia?

}

// MARK: Generated accessors for bem_place
extension Localizacao {

    @objc(addBem_placeObject:)
    @NSManaged public func addToBem_place(_ value: Bem)

    @objc(removeBem_placeObject:)
    @NSManaged public func removeFromBem_place(_ value: Bem)

    @objc(addBem_place:)
    @NSManaged public func addToBem_place(_ values: NSSet)

    @objc(removeBem_place:)
    @NSManaged public func removeFromBem_place(_ values: NSSet)

}
