//
//  PinView.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 29.11.2023.
//

import Foundation
import UIKit

class PinView: UIView {
    
    var isAnimating: Bool = false
    var isCentredOnLocation: Bool = false
    
    var isFirstAppereance: Bool = true
    
    let imageview: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "figure.wave")
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    
    private let vertLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
                                  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
                                  
    private func configureView() {
        backgroundColor = .brown
        addSubview(imageview)
        addSubview(vertLineView)
        
        //MARK: - Constraints
        NSLayoutConstraint.activate([
        
            imageview.topAnchor.constraint(equalTo: topAnchor),
            imageview.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageview.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageview.heightAnchor.constraint(lessThanOrEqualToConstant:  30),
            imageview.widthAnchor.constraint(lessThanOrEqualToConstant: 30),
            
            vertLineView.centerXAnchor.constraint(equalTo: imageview.centerXAnchor),
            vertLineView.topAnchor.constraint(equalTo: imageview.bottomAnchor),
            vertLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            vertLineView.heightAnchor.constraint(lessThanOrEqualToConstant:  25),
            vertLineView.widthAnchor.constraint(lessThanOrEqualToConstant:  2),
        
        ])
    }
    
     func configureShadowPath() {
        let shadowSize: CGFloat = 10
        let shadowDistance: CGFloat = 20
        let height = frame.height
        let newOrigin = CGPoint(x: shadowSize , y: height  + shadowDistance )
        let contactRect = CGRect(origin: newOrigin, size: CGSize(width: shadowSize, height: shadowSize))
        
        layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        layer.shadowRadius = 3
         layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.black.cgColor
    }
    
    func configureSmallShadowPath() {
       let shadowSize: CGFloat = 3
       let height = frame.height
        let width = frame.width / 2
       let newOrigin = CGPoint(x: width - shadowSize / 2 , y: height )
       let contactRect = CGRect(origin: newOrigin, size: CGSize(width: shadowSize, height: shadowSize))
       
       layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
       layer.shadowRadius = 3
       layer.shadowOpacity = 1
       layer.shadowColor = UIColor.black.cgColor
   }
    
    func getSmallShadowPath() -> CGPath {
        let shadowSize: CGFloat = 3
        let height = frame.height
         let width = frame.width / 2
        let newOrigin = CGPoint(x: width - shadowSize / 2 , y: height )
        let contactRect = CGRect(origin: newOrigin, size: CGSize(width: shadowSize, height: shadowSize))
        
        let shadowPath = UIBezierPath(ovalIn: contactRect)
        
        return shadowPath.cgPath
    }
    
    func getBigShadowPath() -> CGPath {
        let shadowSize: CGFloat = 10
        let shadowDistance: CGFloat = 20
        let height = frame.height
        let newOrigin = CGPoint(x: shadowSize , y: height  + shadowDistance )
        let contactRect = CGRect(origin: newOrigin, size: CGSize(width: shadowSize, height: shadowSize))
        
        let shadowPath = UIBezierPath(ovalIn: contactRect)
    
        return shadowPath.cgPath
    }
}
