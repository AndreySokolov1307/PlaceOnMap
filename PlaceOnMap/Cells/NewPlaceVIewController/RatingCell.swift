//
//  PhotoCell.swift
//  PlaceOnMap
//
//  Created by Андрей Соколов on 20.12.2023.
//

import Foundation
import UIKit

class RatingCell: UICollectionViewListCell {
    static let reuseIdentifier = "RatingCell"
    var buttons: [UIButton] {
        return [starButton1, starButton2, starButton3, starButton4, starButton5]
    }
    
    let hStack: UIStackView = {
       let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .fill
        hStack.distribution = .fillEqually
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        hStack.isLayoutMarginsRelativeArrangement = true
        hStack.spacing = 6
       return hStack
    }()
    
    let starButton1: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = UIColor.systemYellow
        button.setBackgroundImage(UIImage(systemName: "star.fill"), for: .selected)
        return button
    }()
    let starButton2: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = UIColor.systemYellow
        return button
    }()
    let starButton3: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = UIColor.systemYellow
        return button
    }()
    let starButton4: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = UIColor.systemYellow
        return button
    }()
    let starButton5: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = UIColor.systemYellow
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        addSubview(hStack)
        hStack.addArrangedSubview(starButton1)
        hStack.addArrangedSubview(starButton2)
        hStack.addArrangedSubview(starButton3)
        hStack.addArrangedSubview(starButton4)
        hStack.addArrangedSubview(starButton5)
        
        NSLayoutConstraint.activate([
          hStack.topAnchor.constraint(equalTo: topAnchor, constant: 0),
          hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
          hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
          hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
