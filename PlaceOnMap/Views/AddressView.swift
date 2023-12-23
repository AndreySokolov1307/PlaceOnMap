//
//  AddAddresView.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 01.12.2023.
//

import Foundation
import UIKit

final class AddressView: UIView {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let poopImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 14)
        imageView.image = UIImage(systemName: "figure.cross.training", withConfiguration: config)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        return imageView
    }()
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Where did I ..?"
        return label
    }()
    
    let userLocationButton: UIButton = {
        let button = UIButton()
        //без цвета не видно тень лол
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.layer.cornerRadius = 12
//        button.layer.borderWidth = 2
//        button.layer.borderColor = UIColor.systemYellow.cgColor
        button.imageView?.tintColor = UIColor.systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowRadius = 16
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowOpacity = 0.2
        button.layer.masksToBounds = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .systemBackground
        addSubview(poopImageView)
        addSubview(appNameLabel)
        addSubview(searchBar)
        addSubview(userLocationButton)
        addSubview(tableView)
        
        //MARK: - Constraints
        
        NSLayoutConstraint.activate([
            
            poopImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            poopImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            poopImageView.widthAnchor.constraint(equalToConstant: 50),
            poopImageView.heightAnchor.constraint(equalToConstant: 50),
            
            appNameLabel.leadingAnchor.constraint(equalTo: poopImageView.trailingAnchor, constant: 10),
            appNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            appNameLabel.centerYAnchor.constraint(equalTo: poopImageView.centerYAnchor),
            
            userLocationButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            userLocationButton.centerYAnchor.constraint(equalTo: poopImageView.centerYAnchor),
            userLocationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userLocationButton.leadingAnchor.constraint(equalTo: appNameLabel.trailingAnchor, constant: 20),
            userLocationButton.heightAnchor.constraint(equalToConstant: 50),
            userLocationButton.widthAnchor.constraint(equalToConstant: 50),
            
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 20),
            searchBar.heightAnchor.constraint(equalToConstant: 56),
            
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}
