//
//  UIImage.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 16/09/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    
        func bemImage(index: Int) -> UIImage {
        
        var theimage = [#imageLiteral(resourceName: "ic_pin_drop"), #imageLiteral(resourceName: "ic_location_city"), #imageLiteral(resourceName: "ic_devices"), #imageLiteral(resourceName: "ic_palette"), #imageLiteral(resourceName: "ic_weekend") , #imageLiteral(resourceName: "ic_sd_card"), #imageLiteral(resourceName: "ic_build"), #imageLiteral(resourceName: "ic_description"), #imageLiteral(resourceName: "ic_gavel2"), #imageLiteral(resourceName: "ic_attach_file"), #imageLiteral(resourceName: "ic_assignment_late")]
        
            var indeximage = 10
            
        switch index {
            
        case 1 :
            indeximage = 0
        case 2 :
            indeximage = 1
        case 3 :
            indeximage = 2
        case 4 :
            indeximage = 3
        case 5 :
            indeximage = 4
        case 6 :
            indeximage = 5
        case 7 :
            indeximage = 6
        case 12 :
            indeximage = 7
        case 20 :
            indeximage = 8
        case 50 :
            indeximage = 9
        default :
            indeximage = 10
            
        }
        
        return theimage[indeximage]
        
    }
    
    
}
