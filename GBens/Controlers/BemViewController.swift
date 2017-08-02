//
//  BemViewController.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 02/08/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import UIKit

class BemViewController: UIViewController {

    @IBOutlet weak var imageBem: UIImageView!
    @IBOutlet weak var labelCodBem: UILabel!
    @IBOutlet weak var labelPBMS: UILabel!
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var labelDTScan: UILabel!
  //  @IBOutlet weak var pickerEstadoConservação: UIPickerView!
    @IBOutlet weak var labelPrefixoNomeDepOwner: UILabel!
    @IBOutlet weak var labelEnderecoLocal: UILabel!
    @IBOutlet weak var labelAndarLocal: UILabel!
    @IBOutlet weak var labelSalaLocal: UILabel!
    @IBOutlet weak var labelSetorLocal: UILabel!
    
   // @IBOutlet weak var pickerLocal: UIPickerView!
    
    var _bem : Bem?
    var _dep : Dependencia?
    var _loc : Localizacao?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let _dep = _bem?.dep_owner
        let _loc = _bem?.place
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if _bem?.scannedImage != nil {
            imageBem.image = UIImage(data: _bem?.scannedImage! as! Data)
        } else {
            imageBem.image = #imageLiteral(resourceName: "BemPhoto")
        }

        labelCodBem.text = _bem?.codBem
        labelPBMS.text = _bem?.pbms
        labelNome.text = _bem?.nome
        
        if _bem?.scan_date != nil {
            labelDTScan.text = dateFormatter.string(from: (_bem?.scan_date as Date?)!)
        } else {
            labelDTScan.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            labelDTScan.text = "Nunca"
        }
        
        
        labelPrefixoNomeDepOwner.text = "\(_dep?.prefixo ?? "0000" ) - \(_dep?.nome ?? "Sem Prefixo")"
        labelEnderecoLocal.text = _loc?.endereco
        labelAndarLocal.text = "\(_loc?.andar ?? 0) andar"
        labelSalaLocal.text = _loc?.sala
        labelSetorLocal.text = _loc?.setor
        
        
        
        
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
