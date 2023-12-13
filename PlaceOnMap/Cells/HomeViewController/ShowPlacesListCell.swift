//
//  MostVisitedPlaceCollectionViewCell.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 24.11.2023.
//

import Foundation
import UIKit

class ShowPlacesListCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ShowPlacesList"
    static var indexPath: IndexPath? = nil
    
    private let showPlacesListLabel: UILabel = {
       let label = UILabel()
        label.text = "Show 'stat' places list!"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label 
    }()
    
    let numberOfPlacesLabel: UILabel = {
       let label = UILabel()
        label.text = "25 places total"
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 1
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
    
    private let listImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage.init(systemName: "list.bullet.indent")
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
        contentView.addSubview(showPlacesListLabel)
        contentView.addSubview(numberOfPlacesLabel)
        contentView.addSubview(hStack)
        hStack.addArrangedSubview(toiletImageView)
        hStack.addArrangedSubview(arrowImageView)
        hStack.addArrangedSubview(listImageView)
    
        
        //MARK: - Constraints
        
        NSLayoutConstraint.activate([
           
            showPlacesListLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            showPlacesListLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            showPlacesListLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
    
            
            numberOfPlacesLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberOfPlacesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            numberOfPlacesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            hStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            
        

        ])
    }
}
