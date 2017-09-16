//
//  Localizacao+CoreDataClass.swift
//  
//
//  Created by Alexandre de Sousa Albuquerque on 12/08/17.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(Localizacao)
public class Localizacao: NSManagedObject {

    var coord : CLLocationCoordinate2D?
    
}
