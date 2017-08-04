//
//  bemTableViewCell.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 17/05/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import UIKit

class bemTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCodBem: UILabel!
    @IBOutlet weak var labelPBMS: UILabel!
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var imageBem: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(_bem:Bem){
        
        labelNome.text = _bem.nome
        labelPBMS.text = _bem.pbms
        labelCodBem.text = _bem.codBem
        if _bem.scannedImage != nil {
            imageBem.image = UIImage(data: _bem.scannedImage! as Data)
            
        } else {
            imageBem.image = #imageLiteral(resourceName: "BemPhoto")
        }

        imageBem.asAvatar()
        
        if _bem.scan_date != nil {
            self.accessoryType = UITableViewCellAccessoryType.checkmark
            
        } else {
            self.accessoryType = UITableViewCellAccessoryType.none
            
        }
        
        
        
    }
    
    
}
