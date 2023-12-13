//
//  ShitCountCell.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 26.11.2023.
//

import Foundation
import UIKit



class ShitCountCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ShitCountCell"
    static var indexPath: IndexPath? = nil
    
   
    
    let shitCountLabel: PaddingLabel = {
       let label = PaddingLabel(topInset: 0, bottomInset: 0, leftInset: 16, rightInset: 16)
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        
        return label
    }()
    
    private let shadowView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.layer.shadowRadius = 16
        view.layer.shadowColor = UIColor.systemGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.layer.shadowOpacity = 0.2
        view.layer.masksToBounds = false

        return view
    }()
    
    let sortButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "list.dash"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 24), forImageIn: .normal)
        button.imageView?.tintColor = .systemGray
        button.layer.cornerRadius = 16
        button.layer.shadowRadius = 16
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowOpacity = 0.2
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
   
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if super.point(inside: point, with: event) {
            return true
        }
        
        return self.sortButton.point(inside: self.sortButton.convert(point, from: self), with: event)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
       
        let view = self.sortButton.hitTest(self.sortButton.convert(point, from: self), with: event)
        if view == nil {
            return super.hitTest(point, with: event)
        }
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        addSubview(shadowView)
        addSubview(sortButton)
        shadowView.addSubview(shitCountLabel)
        
        //MARK: - Constraints
        
        NSLayoutConstraint.activate([
        
            shadowView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            shadowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shadowView.trailingAnchor.constraint(equalTo: sortButton.leadingAnchor,constant: -20),
            shadowView.heightAnchor.constraint(equalToConstant: 54),
            
            shitCountLabel.topAnchor.constraint(equalTo: shadowView.topAnchor),
            shitCountLabel.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            shitCountLabel.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            shitCountLabel.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            sortButton.centerYAnchor.constraint(equalTo: shitCountLabel.centerYAnchor),
            sortButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            sortButton.heightAnchor.constraint(equalTo: shitCountLabel.heightAnchor),
            sortButton.widthAnchor.constraint(equalTo: shitCountLabel.heightAnchor),
        ])
        
    }
}
