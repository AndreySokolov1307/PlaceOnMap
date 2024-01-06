//
//  DetailPhotoViewController.swift
//  PlaceOnMap
//
//  Created by Андрей Соколов on 06.01.2024.
//

import Foundation
import UIKit

class DetailPhotoViewController: UIViewController {
    
    private var detailPhotoView: DetailPhotoView!
    private let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        detailPhotoView = DetailPhotoView()
        self.view = detailPhotoView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        detailPhotoView.imageView.image = image
        navigationItem.largeTitleDisplayMode = .never
    }
}
