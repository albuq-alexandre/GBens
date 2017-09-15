//
//  Usuario+CoreDataClass.swift
//  
//
//  Created by Alexandre de Sousa Albuquerque on 12/08/17.
//
//

import Foundation
import CoreData
import UIKit

@objc(Usuario)
public class Usuario: NSManagedObject {
    
    func appUser(email: String) -> Usuario {
        
        let managedContext = (UIApplication.shared.delegate as! GBensAppDelegate).persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Usuario> = Usuario.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        fetchRequest.fetchBatchSize = 10
        
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        var fetchedUser : [Usuario]
        do {
            
            fetchedUser = try managedContext.fetch(fetchRequest)
            
        } catch {
            fatalError("Falha ao encontrar usuário: \(error)")
            
        }
        
        if fetchedUser.count == 0 {
            
            fatalError("Falha ao encontrar usuário!")
            
        } else {
            
            return fetchedUser[0]
        }
        
    
        
        
    }
    

}
