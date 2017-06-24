//
//  Usuario+CoreDataClass.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 20/06/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import Foundation
import CoreData

@objc(Usuario)
public class Usuario: NSManagedObject {
    
    @objc
    func initial() ->  NSString  {
        return (self.nome! as NSString).substring(to: 1) as NSString
    }

}
