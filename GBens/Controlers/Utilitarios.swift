//
//  Utilitarios.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 18/06/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func asAvatar()  {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.white.cgColor
        
}

}
