//
//  AccountSwitcherTableViewCell.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 17/05/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import UIKit

class AccountSwitcherTableViewCell: UITableViewCell {

    @IBOutlet weak var UserAvatar: UIImageView!
    @IBOutlet weak var UserNameButton: UIButton!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(theuser:Usuario){
        
        UserAvatar.image = UIImage(data: theuser.foto! as Data)
        UserAvatar.asAvatar()
        UserNameButton.setTitle(theuser.nome, for: .normal)
        
        
    }
    
}


    
