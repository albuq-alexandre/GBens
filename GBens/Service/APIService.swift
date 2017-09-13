//
//  APIservice.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 13/09/2017.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//


import Foundation
import UIKit
import Firebase
import CoreData

class APIService: NSObject {
    
    var path : String = ""
    lazy var endPoint: String = {
        return "https://gbem-b2c8c.firebaseio.com/\(self.path).json"
    }()
    
    func getDataWith(nested: String? , completion: @escaping (Result<[String: AnyObject]>) -> Void) {
        
        let urlString = endPoint
        
        guard let url = URL(string: urlString) else { return completion(.Error("URL Inválida, impossível atualizar.")) }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "1Não existem itens a mostrar"))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    if nested != nil {
                        guard let itemsJsonArray = json[nested!] as? [String: AnyObject] else {
                            return completion(.Error(error?.localizedDescription ?? "Não existem \(nested!) a mostrar"))
                        }
                        DispatchQueue.main.async {
                            completion(.Success(itemsJsonArray))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.Success(json))
                        }
                    }
                    
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
    
    
    func atualizaCoreData  (dataDict: [[String: AnyObject]]) throws -> Void  {
        //
        //        let path = "Inventariadas\\" + prefixo
        //        let BensAInventariar = getJSONrest(usuario: usuario, path: path)
        //
        
    }
    
    
    func createDummyData(depd : Dependencia?, myuser: Usuario) {
        
        var prefixo : Int64 = Int64(9081)
        var finalbem: Int = 0
        let managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! GBensAppDelegate).persistentContainer.viewContext
        
        if depd != nil {
            prefixo = Int64((depd?.prefixo!)!)! + 1
            finalbem = Int(((prefixo - 9082 ) * 10) + Int64((depd?.bem_owner?.count)!))
        }
        
        let dep = NSEntityDescription.insertNewObject(forEntityName: "Dependencia", into: managedObjectContext) as! Dependencia
        
        
        dep.codUor = Int64(990000 + prefixo)
        dep.nome = "Dependencia \(prefixo)"
        dep.prefixo = "\(prefixo)"
        dep.ultimasincroniz = (Date() as NSDate)
        dep.addToInventariante(myuser)
        myuser.setValue( dep, forKey: "dep_localizacao")
        
        
        for i in 0..<10 {
            let b = NSEntityDescription.insertNewObject(forEntityName: "Bem", into: managedObjectContext) as! Bem
            b.codBem = "0000000000\(i + finalbem)"
            b.nrCodBem = Int64(i + finalbem)
            b.nome = "Bem nr. 000000000\(i + finalbem)"
            b.pbms = "99.15.050.905008"
            b.pbms1 = "99"
            b.pbms2 = "15"
            b.pbms3 = "050"
            b.pbms4 = "905008"
            b.nome_pbms = "UltraBook Executivo"
            b.categoria = "04"
            b.subcategoria = "0009"
            b.estadoConservacao = "Ótimo"
            b.dt_aquisicao = Date() as NSDate // "10/04/2016")
            b.parcelas = Int16(63)
            b.dt_inventario = Date() as NSDate // "18/11/2016")
            b.nr_serie = "0000000000\(i + finalbem)"
            b.obs = "TestDummyData"
            b.nome_fabricante = "Lenovo"
            
            dep.addToBem_owner(b)
            
            let loc = NSEntityDescription.insertNewObject(forEntityName: "Localizacao", into: managedObjectContext) as! Localizacao
            
            loc.andar = Int16(i * 3)
            loc.codLoc = prefixo * 1000000 + Int64(i + finalbem)
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
                dep.setValue(loc, forKey: "endPrincipal")
            }
            
        }
        (UIApplication.shared.delegate as! GBensAppDelegate).saveContext ()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - New User
    // FIXME: - Implementar New User
    func createUser() -> Usuario {
        
        var myuser : Usuario
        
        
        let managedContext = (UIApplication.shared.delegate as! GBensAppDelegate).persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Usuario> = Usuario.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "email", ascending: false)]
        fetchRequest.fetchBatchSize = 10
        
        
        var usr : [Usuario]
        do {
            
            usr = try managedContext.fetch(fetchRequest)
            
        } catch {
            fatalError("Falha ao encontrar usuário: \(error)")
            
        }
        
        if usr.count == 0 {
            myuser = NSEntityDescription.insertNewObject(forEntityName: "Usuario", into: managedContext) as! Usuario
            myuser.codUser = "teste"
            myuser.email = "teste@teste.com"
            myuser.nome = "Teste"  // theuser.email?.components(separatedBy: "@")[0]
        } else {
            myuser = usr.first!
        }
        
        return myuser
    }
    
    
    // MARK: - Renew Session Login
    // FIXME: - Implementar renewLogin
    
    
    func renewSessionLogin(usuario: Usuario) -> UIAlertController {
        
        let alertController = UIAlertController(title: "Login", message: "Por favor entre com suas credenciais", preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            //This is called when the user presses the cancel button.
            print("Você pressionou cancelar");
        }
        
        let actionLogin = UIAlertAction(title: "Login", style: .default) { (action:UIAlertAction) in
            //This is called when the user presses the login button.
            let textUser = alertController.textFields![0] as UITextField;
            let textPW = alertController.textFields![1] as UITextField
            
            print("The user entered:%@ & %@",textUser.text!,textPW.text!);
        }
        
        alertController.addTextField { (textField) -> Void in
            //Configure the attributes of the first text box.
            textField.placeholder = "E-mail"
            textField.text = usuario.email
        }
        
        alertController.addTextField { (textField) -> Void in
            //Configure the attributes of the second text box.
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        //Add the buttons
        alertController.addAction(actionCancel)
        alertController.addAction(actionLogin)
        
        //Code for Present the alert controller - paste in sender
        //        self.presentViewController(alertController, animated: true, completion:nil)
        
        
        return alertController
        
        
        
        
    }
}


enum Result<T> {
    case Success(T)
    case Error(String)
}





