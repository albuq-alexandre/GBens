//
//  Bem+CoreDataProperties.swift
//  
//
//  Created by Alexandre de Sousa Albuquerque on 12/08/17.
//
//

import Foundation
import CoreData


extension Bem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bem> {
        return NSFetchRequest<Bem>(entityName: "Bem")
    }

    @NSManaged public var categoria: String?
    @NSManaged public var codBem: String?
    @NSManaged public var dt_aquisicao: NSDate?
    @NSManaged public var dt_inventario: NSDate?
    @NSManaged public var estadoConservacao: String?
    @NSManaged public var geolocdatascan: String?
    @NSManaged public var nome: String?
    @NSManaged public var nome_fabricante: String?
    @NSManaged public var nome_pbms: String?
    @NSManaged public var nr_serie: String?
    @NSManaged public var obs: String?
    @NSManaged public var parcelas: Int16
    @NSManaged public var pbms: String?
    @NSManaged public var pbms1: String?
    @NSManaged public var pbms2: String?
    @NSManaged public var pbms3: String?
    @NSManaged public var pbms4: String?
    @NSManaged public var scan_date: NSDate?
    @NSManaged public var scannedImage: NSData?
    @NSManaged public var subcategoria: String?
    @NSManaged public var nrCodBem: Int64
    @NSManaged public var dep_owner: Dependencia?
    @NSManaged public var place: Localizacao?
    @NSManaged public var user_inventariante: Usuario?

}
