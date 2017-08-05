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
    @IBOutlet weak var pickerEstadoConservacao: UIPickerView!
    @IBOutlet weak var labelPrefixoNomeDepOwner: UILabel!
    @IBOutlet weak var labelEnderecoLocal: UILabel!
    @IBOutlet weak var labelAndarLocal: UILabel!
    @IBOutlet weak var labelSalaLocal: UILabel!
    @IBOutlet weak var labelSetorLocal: UILabel!
    @IBOutlet weak var transfereParaMinhaDep: UIButton!
    @IBOutlet weak var pickerLocal: UIPickerView!
    
    var _bem : Bem?
    var _dep : Dependencia?
    var _loc : Localizacao?
    var usrLogado : Usuario? = ((UIApplication.shared.delegate as! GBensAppDelegate).usuariologado)
    
    var est_conserv = ["Ótimo", "Bom", "Danificado", "Obsoleto", "Inservível"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if usrLogado == nil {
            usrLogado = appUser(email: "teste@teste.com")   // FIXME: - TRATAR CASO NÃO FAÇA LOGIN
        }
        
        if _loc == nil {
            let t_loc: [Localizacao] = ((UIApplication.shared.delegate as! GBensAppDelegate).usuariologado?.dep_localizacao?.place_owner?.allObjects)! as! [Localizacao]
            _loc = t_loc[0]
        }
        
        
        if usrLogado?.dep_localizacao != _dep {
            transfereParaMinhaDep.isEnabled = true
        } else {
            transfereParaMinhaDep.isEnabled = false
        }
        
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if _bem?.scannedImage != nil {
            imageBem.image = UIImage(data: (_bem?.scannedImage! as Data?)!)
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
        if _bem?.estadoConservacao != nil {
         pickerEstadoConservacao.selectRow(est_conserv.index(of: (_bem?.estadoConservacao)!)!, inComponent: 0, animated: true)
        }
        
        
        labelPrefixoNomeDepOwner.text = "\(_dep?.prefixo ?? "0000" ) - \(_dep?.nome ?? "Sem Prefixo")"
        labelEnderecoLocal.text = _loc?.endereco
        labelAndarLocal.text = "\(_loc?.andar ?? 0) andar"
        labelSalaLocal.text = _loc?.sala
        labelSetorLocal.text = _loc?.setor
        
       
        pickerLocal.selectRow((_dep?.place_owner?.allObjects as! [Localizacao]).index(of: _loc!)!, inComponent: 0, animated: true)
       
        
        // Do any additional setup after loading the view.
    }

    @IBAction func transfereParaMinhaDep(_ sender: Any) {
        _bem?.dep_owner = (UIApplication.shared.delegate as! GBensAppDelegate).usuariologado?.dep_localizacao
        _dep = (UIApplication.shared.delegate as! GBensAppDelegate).usuariologado?.dep_localizacao
        let t_loc: [Localizacao] = ((UIApplication.shared.delegate as! GBensAppDelegate).usuariologado?.dep_localizacao?.place_owner?.allObjects)! as! [Localizacao]
        _loc = t_loc[0]
        pickerLocal.selectRow((_dep?.place_owner?.allObjects as! [Localizacao]).index(of: _loc!)!, inComponent: 0, animated: true)
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
        
        if let identifier = segue.identifier{
            switch identifier {
            case "unwindToLista":
                
            default:
                break;
            }
        }

        
    }
    */
}


extension BemViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var titulo:String?
        
        switch pickerView {
        case pickerEstadoConservacao:
            titulo = est_conserv[row]
        case pickerLocal:
            titulo = (_dep?.place_owner?.allObjects as! [Localizacao])[row].setor
        default:
            titulo = ""
        }
        
        return titulo
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var nr: Int = 1
        switch pickerView {
        case pickerEstadoConservacao:
            nr = est_conserv.count
        case pickerLocal:
            nr = (_dep?.place_owner?.count)!
        default:
            nr = 1
        }
        return nr
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
        case pickerEstadoConservacao:
            _bem?.estadoConservacao = est_conserv[row]
        case pickerLocal:
            _bem?.place = (_dep?.place_owner?.allObjects as! [Localizacao])[row]
            _loc = (_dep?.place_owner?.allObjects as! [Localizacao])[row]
            labelPrefixoNomeDepOwner.text = "\(_dep?.prefixo ?? "0000" ) - \(_dep?.nome ?? "Sem Prefixo")"
            labelEnderecoLocal.text = _loc?.endereco
            labelAndarLocal.text = "\(_loc?.andar ?? 0) andar"
            labelSalaLocal.text = _loc?.sala
            labelSetorLocal.text = _loc?.setor

            
            
        default: break
            
        }

        
        
        
    }
    
}
