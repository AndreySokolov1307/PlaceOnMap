//
//  Cell + cellShadow.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 26.11.2023.
//

import Foundation
import UIKit


extension UICollectionViewCell {
    
    func configureShadow() {
        
        self.layer.shadowRadius = 16
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        
    }
}
