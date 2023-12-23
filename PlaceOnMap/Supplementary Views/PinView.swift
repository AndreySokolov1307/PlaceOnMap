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
    var isFirstAppereance: Bool = true
    
    let imageview: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "toilet.fill")
        imageView.tintColor = .systemYellow
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let view: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemYellow.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    private let vertLineView: UIView = {
        let view = UIView()
       // view.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(view)
        view.addSubview(imageview)
        addSubview(vertLineView)
        view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 40, height: 30))
        imageview.frame = CGRect(origin: CGPoint(x: 5, y: 5), size: CGSize(width: 30, height: 20))
        vertLineView.frame = CGRect(origin: CGPoint(x: 19, y: 30), size: CGSize(width: 2, height: 25))

    }
    
     func configureShadowPath() {
        let shadowSize: CGFloat = 10
        let shadowDistance: CGFloat = 20
        let height = frame.height
        let width = frame.width / 2
        let newOrigin = CGPoint(x: width - shadowSize / 2 , y: height  + shadowDistance )
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
