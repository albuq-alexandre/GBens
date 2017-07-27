//
//  Dependencia+CoreDataProperties.swift
//  
//
//  Created by Alexandre de Sousa Albuquerque on 26/07/17.
//
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
    @NSManaged public var ultimoInventario: NSDate?
    @NSManaged public var ultimasincroniz: NSDate?
    @NSManaged public var bem_owner: NSOrderedSet?
    @NSManaged public var inventariante: NSSet?
    @NSManaged public var place_owner: NSSet?
    @NSManaged public var endPrincipal: Localizacao?
    @NSManaged public var usuario_local: NSSet?

}

// MARK: Generated accessors for bem_owner
extension Dependencia {

    @objc(insertObject:inBem_ownerAtIndex:)
    @NSManaged public func insertIntoBem_owner(_ value: Bem, at idx: Int)

    @objc(removeObjectFromBem_ownerAtIndex:)
    @NSManaged public func removeFromBem_owner(at idx: Int)

    @objc(insertBem_owner:atIndexes:)
    @NSManaged public func insertIntoBem_owner(_ values: [Bem], at indexes: NSIndexSet)

    @objc(removeBem_ownerAtIndexes:)
    @NSManaged public func removeFromBem_owner(at indexes: NSIndexSet)

    @objc(replaceObjectInBem_ownerAtIndex:withObject:)
    @NSManaged public func replaceBem_owner(at idx: Int, with value: Bem)

    @objc(replaceBem_ownerAtIndexes:withBem_owner:)
    @NSManaged public func replaceBem_owner(at indexes: NSIndexSet, with values: [Bem])

    @objc(addBem_ownerObject:)
    @NSManaged public func addToBem_owner(_ value: Bem)

    @objc(removeBem_ownerObject:)
    @NSManaged public func removeFromBem_owner(_ value: Bem)

    @objc(addBem_owner:)
    @NSManaged public func addToBem_owner(_ values: NSOrderedSet)

    @objc(removeBem_owner:)
    @NSManaged public func removeFromBem_owner(_ values: NSOrderedSet)

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

// MARK: Generated accessors for usuario_local
extension Dependencia {

    @objc(addUsuario_localObject:)
    @NSManaged public func addToUsuario_local(_ value: Usuario)

    @objc(removeUsuario_localObject:)
    @NSManaged public func removeFromUsuario_local(_ value: Usuario)

    @objc(addUsuario_local:)
    @NSManaged public func addToUsuario_local(_ values: NSSet)

    @objc(removeUsuario_local:)
    @NSManaged public func removeFromUsuario_local(_ values: NSSet)

}
