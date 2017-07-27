//
//  InventarioViewController.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 10/05/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import UIKit

class InventarioViewController: UIViewController {

    weak var dep : Dependencia?
    
    @IBOutlet weak var titulo: UINavigationItem!
    @IBOutlet weak var fotoAgencia: UIImageView!
    @IBOutlet weak var labelNomeDependencia: UILabel!
    @IBOutlet weak var labelPrefixo: UILabel!
    @IBOutlet weak var labelUOR: UILabel!
    @IBOutlet weak var labelUltimoInventario: UILabel!
    @IBOutlet weak var labelUltimaSincr: UILabel!
    @IBOutlet weak var labelMensagemStatus: UILabel!
    
    
    
    
    @IBOutlet weak var botaoConcluir: UIButton!
    @IBOutlet weak var botaoSincronizarDados: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    
        titulo.title = ("Inventário " + (dep?.prefixo)!)
        labelNomeDependencia.text = dep?.nome!
        labelPrefixo.text = dep?.prefixo!
        labelUOR.text =  "\(dep?.codUor ?? 0)"
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        
        labelUltimoInventario.text = dateFormatter.string(from: date)
        labelUltimaSincr.text = dateFormatter.string(from: date)
        
        
        
        labelMensagemStatus.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        labelMensagemStatus.text = "Sem Pendências"
    
        botaoConcluir.isEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK:  - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
