//
//  NumberOfNewPlacesCollectionViewCell.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 24.11.2023.
//

import Foundation
import UIKit

class AddPlaceOnMapCell: UICollectionViewCell {
    
    static let reuseIdentifier = "AddPlaceOnMap"
    static var indexPath: IndexPath? = nil
    
    private let newPlaceLabel: UILabel = {
       let label = UILabel()
        label.text = "Add new place on map!"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hStack: UIStackView = {
       let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 20
        hStack.alignment = .fill
        hStack.distribution  = .fillEqually
        hStack.translatesAutoresizingMaskIntoConstraints = false
       return hStack
    }()
    
    private let toiletImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "toilet.fill")
        return imageView
    }()
    
    private let arrowImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage.init(systemName: "arrow.right")
        return imageView
    }()
    
    private let mapImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage.init(systemName: "mappin.and.ellipse")
        return imageView
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = .white
        contentView.addSubview(newPlaceLabel)
        contentView.addSubview(hStack)
        hStack.addArrangedSubview(toiletImageView)
        hStack.addArrangedSubview(arrowImageView)
        hStack.addArrangedSubview(mapImageView)
    
        
        //MARK: - Constraints
        
        NSLayoutConstraint.activate([
            newPlaceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            newPlaceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            newPlaceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            hStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            
        ])
    }
}

