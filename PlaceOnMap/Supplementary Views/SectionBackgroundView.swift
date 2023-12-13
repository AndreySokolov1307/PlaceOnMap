//
//  SectionBackgroundView.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 26.11.2023.
//

import Foundation
import UIKit

class SectionBackgroundView: UICollectionReusableView {
    
    static let kindIdenifier = "SectionBackgroundView"
    
    override func didMoveToSuperview() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.shadowRadius = 16
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }
}

//enum SectionBackground: String {
//    case kind = "SectionBackground"
//    case reuse = "Background"
//
//    var identifier: String {
//        return rawValue
//    }
//}
