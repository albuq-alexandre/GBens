//
//  APIservice.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 26/04/17.
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
    
    
    
    
    
    // MARK: - New User
    // FIXME: - Implementar New User
    
    
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





