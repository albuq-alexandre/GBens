//
//  AppDelegate.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 26/04/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import UIKit
import CoreData
import Firebase


@UIApplicationMain
class GBensAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        var v_pfx : Int64
        
        FirebaseApp.configure()
        
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Dependencia> = Dependencia.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "prefixo", ascending: false)]
        fetchRequest.fetchBatchSize = 10
        
        var pfx : [Dependencia]
        do {
            
            pfx = try managedContext.fetch(fetchRequest)
            
        } catch {
            fatalError("Falha ao encontrar usuário: \(error)")
            
        }
        
        if pfx.count == 0 {
            v_pfx = 1001
        } else {
            v_pfx = (Int64(pfx[0].prefixo!))! + 1
        }
        
        if pfx.count < 3 {
        createDummyData(prefixo: v_pfx, myuser: createUser())
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
     saveContext()
    
    }

    // MARK: - Core Data stack
    
    lazy public var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "GBens")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

//    func atualizaCoreData (usuario: User, prefixo: String) {
//        
//        let path = "Inventariadas\\" + prefixo
//        let BensAInventariar = getJSONrest(usuario: usuario, path: path)
//        
//        //let bemEntityDescription = NSEntityDescription.entityForName("Bem", inManagedObjectContext: coreDataStack.context)
//        
//        for (nrBem) in BensAInventariar {
//            
//            let bem = NSEntityDescription.insertNewObject(forEntityName: "Bem", into: persistentContainer.viewContext) as! Bem
//        //    let bem = Bem(entity: bemEntityDescription!, insertinto: managedObjectContext)
//            
//            bem.codBem = (nrBem).value as? String
//            
//            
//            
//            
//            
//            
////            bem.codBem = nrBem as String
// //           bem.categoria = BensAInventariar.keys
//            
//        }
//        
    
    // MARK: - Dummy test CoreData
        
        
    func createUser() -> Usuario {
        
        let myuser = NSEntityDescription.insertNewObject(forEntityName: "Usuario", into: persistentContainer.viewContext) as! Usuario
        
        myuser.codUser = "teste"
        myuser.email = "teste@teste.com"
        myuser.nome = "Teste"  // theuser.email?.components(separatedBy: "@")[0]
        
        return myuser
    }
    
    func createDummyData(prefixo : Int64, myuser: Usuario) {
        
        let dep = NSEntityDescription.insertNewObject(forEntityName: "Dependencia", into: persistentContainer.viewContext) as! Dependencia
        
        
        dep.codUor = Int64(990000 + prefixo)
        dep.nome = "Dependencia \(prefixo)"
        dep.prefixo = "\(prefixo)"
        dep.ultimasincroniz = (Date() as NSDate)
        dep.addToInventariante(myuser)
        myuser.dep_localizacao = (dep)
        
        
        for i in 0..<100 {
            let b = NSEntityDescription.insertNewObject(forEntityName: "Bem", into: persistentContainer.viewContext) as! Bem
            b.codBem = "0000000000\(i)"
            b.nome = "Bem nr. 000000000\(i)"
            b.pbms = "9915050905008"
            b.pbms = "99"
            b.pbms2 = "15"
            b.pbms3 = "050"
            b.pbms4 = "905008"
            b.nome_pbms = "UltraBook Executivo"
            b.categoria = "04"
            b.subcategoria = "0009"
            b.estadoConservacao = "Otimo"
            b.dt_aquisicao = Date() as NSDate // "10/04/2016")
            b.parcelas = Int16(63)
            b.dt_inventario = Date() as NSDate // "18/11/2016")
            b.nr_serie = "0000000000\(i)"
            b.obs = "TestDummyData"
            b.nome_fabricante = "Lenovo"
            
            dep.addToBem_owner(b)
            
            let loc = NSEntityDescription.insertNewObject(forEntityName: "Localizacao", into: persistentContainer.viewContext) as! Localizacao
            
            loc.andar = Int16(i * 3)
            loc.codLoc = prefixo * 1000000 + Int64(i)
            loc.endereco = "Endereco \(i)"
            loc.bairro = "Bairro \(i)"
            loc.cidade = "Cidade \(i)"
            loc.complemento = "complemento \(i)"
            loc.sala = "sala \(i)"
            loc.setor = "setor \(i)"
            loc.uf = "DF"
            
            loc.addToBem_place(b)
            dep.addToPlace_owner(loc)
            if dep.endPrincipal == nil {
                dep.endPrincipal = (loc)
            }
            
        }
        saveContext ()
    }

}




