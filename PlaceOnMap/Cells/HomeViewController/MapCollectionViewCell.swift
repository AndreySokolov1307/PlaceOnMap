//
//  MapCollectionViewCell.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 24.11.2023.
//

import UIKit
import MapKit

class MapCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MapCell"
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .green
        return imageView
    }()
    
    let mapView: MKMapView = {
       let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        //contentView.addSubview(imageView)
        contentView.addSubview(mapView)
        mapView.layer.cornerRadius = 16
        //MARK: - Constraints
        
        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            
           mapView.topAnchor.constraint(equalTo: contentView.topAnchor),
           mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
}
