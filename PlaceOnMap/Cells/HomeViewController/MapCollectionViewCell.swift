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
        contentView.addSubview(mapView)
        mapView.layer.cornerRadius = 16
    
        NSLayoutConstraint.activate([
           mapView.topAnchor.constraint(equalTo: contentView.topAnchor),
           mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

