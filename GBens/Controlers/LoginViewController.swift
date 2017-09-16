//
//  LoginViewController.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 26/04/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
    }
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
     var theuser : String?
    @IBAction func loginNoFifebase(_ sender: Any) {
    
    if userName.text == ""  {
        let alertController = UIAlertController(title: "Erro", message: "Entre com seu Código de Usuário e Senha", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    } else {
        
        Auth.auth().signIn(withEmail: self.userName.text!, password: self.passWord.text!) { (user, error) in
            
            if error == nil {
                
                
                self.theuser = user?.email
                
                
                
                // MARK: - Download dos dados Firebase
                
                // Atualização dos dados do Usuário
                let apiServiceForUser = APIService()
                var myUser : Usuario? = nil
                var jsonDataForInventariadas : [String: Any] = [:]
                var localizationDep : String = ""
                let path = "Users/\((user?.email?.components(separatedBy: "@")[0])!)"
                apiServiceForUser.path = path
                
                apiServiceForUser.getDataWith(nested: nil) { (result) in
                    
                    switch result {
                        
                    case .Success(let data):
                       // jsonDataForUser = data as [ String : Any ]
                        myUser = apiServiceForUser.createUser(jsonData: data)
                        jsonDataForInventariadas = data["inventariadas"] as! [ String : Any ]
                        localizationDep = "\(data["dep_localizacao"]!)"
                    case .Error(let message):
                        DispatchQueue.main.async {
                            self.showAlertWith(title: "Error", message: message)
                        }
                    }
                    
                    
                    
                    _ = jsonDataForInventariadas.map {
                        
                        let apiServiceForDependencia = APIService()
                        apiServiceForDependencia.path = "Inventariadas/\($0.value as! Int)"
                        apiServiceForDependencia.getDataWith(nested: nil) { (result) in
                            
                            switch result {
                                
                            case .Success(let data):
                                
                                apiServiceForDependencia.atualizaCoreDataInventariadas(dataDict: data, myuser: myUser! )
                                
                                
                            case .Error(let message):
                                DispatchQueue.main.async {
                                    self.showAlertWith(title: "Error", message: message)
                                }
                            }
                        }
                    }
                    
                    // atualizar a dependencia de localização do usuário aqui
                    
                    if let dep : Dependencia = APIService().depFromPrefixo(prefixo: localizationDep) {
                        myUser?.setValue( dep, forKey: "dep_localizacao")
                    } else {
                        myUser?.setValue( APIService().depFromPrefixo(prefixo: "9081"), forKey: "dep_localizacao")
                    }


                    
                }
                
//                var jsonDataforDependencia : [[String : Any]]
                
                
                
                
                
                
                
              //  let currentUser = apiServiceForUser.appUser(email: self.theuser!)
                
                
                
//                apiService.getDataWith(nested: "Users") { (result) in
//                    print (result)
//                }
//                
//                let inventariadas = apiService.getJSONrest(usuario: user!, path: path)
//                
//                
//                print(inventariadas)
//                
                
                
                
                let alertController = UIAlertController(title: "Sucesso", message: "Usuário Autenticado", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
                //abre a tela da lista de inventários
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let gBensTabBar = storyboard.instantiateViewController(withIdentifier: "gBensTabBar") as! UITabBarController
                let appdelegate = UIApplication.shared.delegate as! GBensAppDelegate
                appdelegate.window?.rootViewController = gBensTabBar
                
            } else {
                
                //Mostra o erro retornado pelo firebase
                let alertController = UIAlertController(title: "Erro!", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        }



}
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func preencheteste(_ sender: Any) {
        self.userName.text = "teste@teste.com"
        self.passWord.text = "teste1"
    }

    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

//  MARK: - Navigation
 
  //In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//    }
//    
//    
  
 }



    




