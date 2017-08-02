//
//  Localizacao+CoreDataProperties.swift
//  
//
//  Created by Alexandre de Sousa Albuquerque on 31/07/17.
//
//

import Foundation
import CoreData


extension Localizacao {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Localizacao> {
        return NSFetchRequest<Localizacao>(entityName: "Localizacao")
    }

    @NSManaged public var andar: Int16
    @NSManaged public var bairro: String?
    @NSManaged public var cidade: String?
    @NSManaged public var codLoc: Int64
    @NSManaged public var complemento: String?
    @NSManaged public var endereco: String?
    @NSManaged public var sala: String?
    @NSManaged public var setor: String?
    @NSManaged public var uf: String?
    @NSManaged public var bem_place: NSSet?
    @NSManaged public var dep_host: Dependencia?
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
