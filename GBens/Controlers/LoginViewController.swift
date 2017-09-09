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
                
                Auth.auth().addStateDidChangeListener { (auth, user) in
                    if user != nil {
                        self.theuser = user?.email
                        
                        let path = "Users/\((user?.email?.components(separatedBy: "@")[0])!)"
                        print (path)  //FIXME: - Download dos dados Firebase
                        let apiService = APIService()
                        
                        let inventariadas = apiService.getJSONrest(usuario: user!, path: path)
                        
                        
                        print(inventariadas)
                        
                        
                        
                        
                    } else {
                        print ("erro de user")
                    }
                }
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



//  MARK: - Navigation
 
  //In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//    }
//    
//    
  
 }



    




