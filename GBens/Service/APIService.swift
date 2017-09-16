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

public class APIService: NSObject {
    
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
    
    
    func atualizaCoreDataInventariadas  (dataDict: [String: AnyObject], myuser: Usuario) -> Void  {
        
        let depData : [String:Any] = dataDict["data"] as! [String:Any]
        let prefixo : Int64 = depData["prefixo"] as! Int64
        let dep_opt: Dependencia? = APIService().depFromPrefixo(prefixo: "\(prefixo)")
        let managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! GBensAppDelegate).persistentContainer.viewContext
        let dep : Dependencia
        
        
        if dep_opt == nil {
            dep = NSEntityDescription.insertNewObject(forEntityName: "Dependencia", into: managedObjectContext) as! Dependencia
        } else {
            dep = dep_opt!
        }
        
        
        dep.codUor = depData["codUor"] as! Int64
        dep.nome = "Dependencia \(prefixo)"
        dep.prefixo = "\(prefixo)"
        dep.ultimasincroniz = (Date() as NSDate)
        dep.addToInventariante(myuser)
        
        
       
        _ = dataDict.map {
            
            if let nrcodbem : Int64 = Int64($0.key) {
                
                let dictBem : [String:Any] = $0.value as! [String : Any]
                let bem_opt : Bem? = bemFromNR(bem: Int($0.key)!)
                let b : Bem
                
                if bem_opt == nil {
                    b = NSEntityDescription.insertNewObject(forEntityName: "Bem", into: managedObjectContext) as! Bem
                } else {
                    b = bem_opt!
                }
                
                
                b.codBem = $0.key
                
                b.nrCodBem = nrcodbem
                b.nome = dictBem["nome_pbms"] as? String
                b.pbms = dictBem["pbms"] as? String
                b.pbms1 = dictBem["pbms1"] as? String
                b.pbms2 = dictBem["pbms2"] as? String
                b.pbms3 = dictBem["pbms3"] as? String
                b.pbms4 = dictBem["pbms3"] as? String
                b.nome_pbms = dictBem["nome_pbms"] as? String
                
                
                    
                    b.categoria = (dictBem["categoria"] as? String ?? "03")
                           
                b.subcategoria = dictBem["subcategoria"] as? String
                b.estadoConservacao = "Ótimo"
                b.dt_aquisicao = dateFromString(dataS: (dictBem["dt_aquisicao"] as? String)!)
                b.parcelas = 0
                b.dt_inventario = dateFromString(dataS: (dictBem["dt_inventario"] as? String)!)
                b.nr_serie = dictBem["nr_serie"] as? String
                b.obs = dictBem["obs"] as? String
                b.nome_fabricante = dictBem["nome_fabricante"] as? String
                
                dep.addToBem_owner(b)
                
                if dep.endPrincipal == nil {
                    let dictLocMain: [String:Any] = depData["endPrincipal"] as! [String:Any]
                    let locMain = NSEntityDescription.insertNewObject(forEntityName: "Localizacao", into: managedObjectContext) as! Localizacao
                    locMain.andar = (dictLocMain["andar"] as? Int16)!
                    locMain.codLoc = prefixo * 1000000 + 1
                    locMain.endereco = dictLocMain["endereco"] as? String
                    locMain.bairro = dictLocMain["bairro"] as? String
                    locMain.cidade = dictLocMain["cidade"] as? String
                    locMain.complemento = dictLocMain["complemento"] as? String
                    locMain.sala = dictLocMain["sala"] as? String
                    locMain.setor = dictLocMain["setor"] as? String
                    locMain.uf = dictLocMain["uf"] as? String
                    dep.setValue(locMain, forKey: "endPrincipal")
                    locMain.addToBem_place(b)
                    dep.addToPlace_owner(locMain)
                } else {
                    let loc = NSEntityDescription.insertNewObject(forEntityName: "Localizacao", into: managedObjectContext) as! Localizacao
                    let start = $0.key.index($0.key.endIndex, offsetBy: -1)
                    let codlocstart = $0.key.index($0.key.endIndex, offsetBy: -4)
                    let i = Int16(($0.key.substring(from: codlocstart)))!
                    loc.andar = Int16(($0.key.substring(from: start)))!
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
                }
            }
            (UIApplication.shared.delegate as! GBensAppDelegate).saveContext()
        }
    }
    
        // MARK: - New User
    // FIXME: - Implementar New User
    func createUser( jsonData: [String:Any] ) -> Usuario {
        
        var myuser : Usuario
        
        
        let managedContext = (UIApplication.shared.delegate as! GBensAppDelegate).persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Usuario> = Usuario.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "email", ascending: false)]
        fetchRequest.fetchBatchSize = 10
        fetchRequest.predicate = NSPredicate(format: "email == %@", jsonData["email"] as! String)
        
        var usr : [Usuario]
        do {
            
            usr = try managedContext.fetch(fetchRequest)
            
        } catch {
            fatalError("Falha ao encontrar usuário: \(error)")
            
        }
        
        if usr.count == 0 {
            myuser = NSEntityDescription.insertNewObject(forEntityName: "Usuario", into: managedContext) as! Usuario
            myuser.codUser = ( jsonData["email"] as! String).components(separatedBy: "@")[0]
            myuser.email =  jsonData["email"] as? String
            myuser.nome =  jsonData["nome"] as? String
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
//            DispatchQueue.main.async {
//                self.showAlertWith(title: "Error", message: "Falha ao encontrar usuário: \(error)")
                fatalError("Falha ao encontrar usuário: \(error)")

//            }

                    }
        
        if fetchedUser.count == 0 {
            
//            DispatchQueue.main.async {
//                self.showAlertWith(title: "Error", message: "Usuário Inexistente")
                fatalError("Usuário Inexistente")
//            }
            
            
            
        } else {
            
            return fetchedUser[0]
        }
    }
    
    func depFromPrefixo(prefixo: String) -> Dependencia? {
        
        let managedContext = (UIApplication.shared.delegate as! GBensAppDelegate).persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Dependencia> = Dependencia.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        fetchRequest.fetchBatchSize = 1
        
        fetchRequest.predicate = NSPredicate(format: "prefixo == %@", prefixo)
        var fetchedDep : [Dependencia]
        do {
            
            fetchedDep = try managedContext.fetch(fetchRequest)
            
        } catch {
            fatalError("Erro ao buscar prefixo \(prefixo) : \(error)")
        }
        
        if fetchedDep.count == 0 {
            //  "Prefixo inexistente"
            return nil
        } else {
            return fetchedDep.first
        }
    }
    
    func dateFromString (dataS:String) -> NSDate? {
        
        let dateFormatter = DateFormatter()
        
        
        // FIXME: - TRATAR O TAMANHO DA STRING E O DELIMITADOR DE DATA
        
        dateFormatter.dateFormat = "DD/MM/YY" // date_format_you_want_in_string from
        
        
            let dataD = dateFormatter.date(from: dataS)! as NSDate
            return dataD
        
        
        
        
    }
    
    func bemFromNR(bem: Int) -> Bem? {
        
        let managedContext = (UIApplication.shared.delegate as! GBensAppDelegate).persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Bem> = Bem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nrCodBem", ascending: true)]
        fetchRequest.fetchBatchSize = 1
        
        fetchRequest.predicate = NSPredicate(format: "nrCodBem == %i", bem)
        var fetchedBem : [Bem]
        do {
            
            fetchedBem = try managedContext.fetch(fetchRequest)
            
        } catch {
            fatalError("Erro ao buscar Bem \(bem) : \(error)")
        }
        
        if fetchedBem.count == 0 {
            //  "Bem inexistente"
            return nil
        } else {
            return fetchedBem.first
        }
    }

}


enum Result<T> {
    case Success(T)
    case Error(String)
}





