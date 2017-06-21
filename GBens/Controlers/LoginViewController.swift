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
     weak var theuser : User?
    @IBAction func loginNoFifebase(_ sender: Any) {
    
    if userName.text == ""  {
        let alertController = UIAlertController(title: "Erro", message: "Entre com seu Código de Usuário e Senha", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    } else {
        
        Auth.auth().signIn(withEmail: self.userName.text!, password: self.passWord.text!) { (user, error) in
            
            if error == nil {
                
                Auth.auth().addStateDidChangeListener { (auth, theuser) in
                    if user != nil {
                        self.theuser = user
                        user?.getIDToken() { (authToken, error) in
                            if authToken != nil {
                                print(authToken!)
                                let config = URLSessionConfiguration.default
                                let session = URLSession(configuration: config)
                                
                                let urlfirebase = URL(string: "https:gbem-b2c8c.firebaseio.com/Bens.json")
                                
                                var request = URLRequest(url: urlfirebase!)
                                
                                request.httpMethod = "GET"
                                request.addValue("auth", forHTTPHeaderField: "JWT "+authToken!)
                                
                                let task = session.dataTask(with: request) { (data, response, error) in
                                    // var jBens: [String : Any] = [:]
                                    if error != nil {
                                        print(error!.localizedDescription)
                                    } else {
                                        let jBens = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                        print (jBens!)
                                    }
                                }
                                task.resume()
                            }
                        }
                    } else {
                        print ("erro de user")
                    }
                }
                let alertController = UIAlertController(title: "Sucesso", message: "Usuário Autenticado", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
        
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
               dest.theuser = self.theuser
            
        default:
            break;
            
    
        }
    
    
  
 }

}
}





//
//
//
//
//                                }
//
//                            }
//
//


