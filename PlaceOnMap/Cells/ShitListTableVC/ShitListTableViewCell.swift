//
//  ShitListTableViewCell.swift
//  PlaceOnMap
//
//  Created by Андрей Соколов on 22.12.2023.
//

import Foundation
import UIKit

class ShitListTableViewCell: UITableViewCell {
    
    static let  reuseIdentifier: String = "ShitListTableViewCell"
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .left
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        addSubview(photoImageView)
        addSubview(vStack)
        vStack.addArrangedSubview(addressLabel)
        vStack.addArrangedSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 60),
            photoImageView.widthAnchor.constraint(equalToConstant: 60),
            
            vStack.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
}
