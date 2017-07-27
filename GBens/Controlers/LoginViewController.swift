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
                       // let path = "Users\\" + (user?.email?.components(separatedBy: "@")[0])!
                       // print (path)  //FIXME: - Download dos dados Firebase
                        
                        
//                        let fetchRequest : NSFetchRequest<Usuario> = Usuario.fetchRequest()
//                        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
//                        fetchRequest.fetchBatchSize = 1
//                        fetchRequest.predicate = NSPredicate(format: "email == %@", user!.email!)
//                        
//                        var fetchedUser : [Usuario]
//                        do {
//                            
//                            fetchedUser = try fetchRequest.execute()
//                            
//                        } catch {
//                            fatalError("Falha ao encontrar usuário: \(error)")
//                            
//                        }
//                        
                        
                        
                        
//                        let inventariadas = getJSONrest(usuario: user!, path: path)
//                        
//                        for (nr, prefixo) in inventariadas {
//                            print (nr)
//                            print (prefixo)
////                            atualizaCoreData(usuario: user!, prefixo)
                      //  }
                    
                        
                    } else {
                        print ("erro de user")
                    }
                }
                let alertController = UIAlertController(title: "Sucesso", message: "Usuário Autenticado", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
               // self.present(alertController, animated: true, completion: nil)
        
            } else {
                
                //Mostra o erro retornado pelo firebase
                let alertController = UIAlertController(title: "Erro!", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    //abre a tela da lista de bens
    self.performSegue(withIdentifier: "segueToResumo", sender: nil)
    
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
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier{
        switch identifier {
        case "segueToResumo":
            let dest = segue.destination as! InventarianteTableViewController
              dest.from_user = self.userName.text
        default:
            break;
            
    
        }
    
    
  
 }

}
    }

// MARK: - JSON download

//func getJSONrest (usuario: User, path: String) -> [String: Any] {
////
//    
//    usuario.getIDToken() { (authToken, error) in
//        if authToken != nil {
//           
//            let config = URLSessionConfiguration.default
//            let session = URLSession(configuration: config)
//            
//            let urlpath = "https:gbem-b2c8c.firebaseio.com/\(path).json"
//            
//            let urlfirebase = URL(string: urlpath)
//            
//            var request = URLRequest(url: urlfirebase!)
//            
//            request.httpMethod = "GET"
//            request.addValue("auth", forHTTPHeaderField: "JWT "+authToken!)
//            
//            let task = session.dataTask(with: request) { (data, response, error) in
//                if error != nil {
//                    var jBens: [String : Any] = [:]
//                    jBens.updateValue("0", forKey: "erro")
//                } else {
//                    let jBens = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//                }
//            }
//            task.resume()
//        }
//        
//        var jBens: [String : Any] = [:]
//        jBens.updateValue("0", forKey: "erro")
//
//    return jBens
//    
//    
//    
//}
//}
//

// MARK: - New User



// MARK: - Renew Session Login
//


    func renewSessionLogin(usuario: Usuario?) {
        
        let alertController = UIAlertController(title: "Login", message: "Por favor entre com suas credenciais", preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            //This is called when the user presses the cancel button.
            print("You've pressed the cancel button");
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
        
        //Present the alert controller
//        self.presentViewController(alertController, animated: true, completion:nil)
        
        
        
}





//
//
                              //

//
//


