//
//  InventariosTableViewCell.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 17/05/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import UIKit

class InventariosTableViewCell: UITableViewCell {

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setupCell(inventariada:Dependencia){
        
        self.textLabel?.text = inventariada.prefixo
        //        self.imageView?.image = UIApplicationShortcutIcon
        if inventariada.inventarioConcluido {
            self.accessoryType = UITableViewCellAccessoryType.checkmark
            
        }
    
    }
    
}
