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
    
    let query = "dogs"
    lazy var endPoint: String = {
        return "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=\(self.query)&nojsoncallback=1#"
    }()
    
    func getDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        let urlString = endPoint
        
        guard let url = URL(string: urlString) else { return completion(.Error("URL Inválida, impossível atualizar.")) }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "Não existem itens a mostrar"))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    guard let itemsJsonArray = json["items"] as? [[String: AnyObject]] else {
                        return completion(.Error(error?.localizedDescription ?? "Não existem itens a mostrar"))
                    }
                    DispatchQueue.main.async {
                        completion(.Success(itemsJsonArray))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
    
    
    func atualizaCoreData (usuario: User, prefixo: String) {
//        
//        let path = "Inventariadas\\" + prefixo
//        let BensAInventariar = getJSONrest(usuario: usuario, path: path)
//        
    }
    
    
    
    // MARK: - JSON download
    
    func getJSONrest (usuario: User, path: String) -> [String: Any] {
        
        var jBens: [String : Any] = [:]
        
        usuario.getIDToken() { (authToken, error) in
            if authToken != nil {
                
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                
                let urlpath = "https://gbem-b2c8c.firebaseio.com/\(path).json"
                
                print (urlpath)
                
                let urlfirebase = URL(string: urlpath)
                
                var request = URLRequest(url: urlfirebase!)
                
                request.httpMethod = "GET"
                request.addValue("auth", forHTTPHeaderField: "JWT "+authToken!)
                
                let task = session.dataTask(with: request) { (data, response, error) in
                    if error != nil {
                        var jBens: [String : Any] = [:]
                        jBens.updateValue("0", forKey: "erro")
                    } else {
                        jBens = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                    }
                }
                task.resume()
            }
        }   // FIXME: - Tratar o erro do getIdToken
        return jBens
    }
    
    
    // MARK: - New User
    // FIXME: - Implementar New User
    
    
    // MARK: - Renew Session Login
    // FIXME: - Implementar renewLogin
    
    
    func renewSessionLogin(usuario: Usuario?) -> UIAlertController {
        
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





