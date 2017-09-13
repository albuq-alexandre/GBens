//
//  InventarianteViewController.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 10/06/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth


class InventarianteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var AccountImage: UIImageView!
    
    @IBOutlet weak var nomeGuerra: UILabel!
    @IBOutlet weak var codUserLabel: UILabel!
    @IBOutlet weak var nomeCompletoLabel: UILabel!
    @IBOutlet weak var depLocalizacaoLabel: UILabel!
    @IBOutlet weak var endDependenciaLabel: UILabel!
    @IBOutlet weak var complemEndLabel: UILabel!
    @IBOutlet weak var bairroLabel: UILabel!
    @IBOutlet weak var cidadeLabel: UILabel!
    @IBOutlet weak var ufLabel: UILabel!
    
    var theUser: Usuario?
    
    
    
    var imagePicker: UIImagePickerController!
    
    @IBAction func choosePhoto(_ sender: Any) {
        
        let alertControler = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let cameraAction = UIAlertAction(title: "Tirar a Foto", style: .default) { (action) in
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
     
        let photoLibraryAction = UIAlertAction(title: "Escolher a Foto", style: .default) { (action) in
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertControler.addAction(cameraAction)
        alertControler.addAction(photoLibraryAction)
        alertControler.addAction(cancelAction)
        
        
        present(alertControler, animated: true, completion: nil)
        
    }
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let choosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        AccountImage.image = choosenImage
        AccountImage.contentMode = .scaleAspectFill
        theUser?.foto = UIImageJPEGRepresentation(choosenImage, 1)! as NSData
        
        dismiss(animated: true, completion: nil)
        
    
    
    }
    
    
    @IBAction func logoffButtonItem(_ sender: UIBarButtonItem) {
        
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theDep = theUser?.dep_localizacao
        let thePlace = theDep?.endPrincipal
        
        
        
        AccountImage.asAvatar()
        AccountImage.layer.borderWidth = 3.0
        
        if theUser?.foto != nil {
            AccountImage.image = UIImage(data: (theUser?.foto)! as Data)
        }
        
        nomeGuerra.text = theUser?.nome?.components(separatedBy: " ")[0]
        codUserLabel.text = theUser?.email
        nomeCompletoLabel.text = theUser?.nome
        depLocalizacaoLabel.text = "\(theDep?.prefixo ?? "")  - \(theDep?.nome ?? "")"
        endDependenciaLabel.text = thePlace?.endereco
        complemEndLabel.text = thePlace?.complemento
        bairroLabel.text = thePlace?.bairro
        cidadeLabel.text = thePlace?.cidade
        ufLabel.text = thePlace?.uf
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
