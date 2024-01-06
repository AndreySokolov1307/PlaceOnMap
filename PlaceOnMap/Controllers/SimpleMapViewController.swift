//
//  SimpleMapViewController.swift
//  PlaceOnMap
//
//  Created by Андрей Соколов on 06.01.2024.
//

import Foundation
import UIKit
import MapKit

class SimpleMapViewController: UIViewController {
    
    var mapView = MKMapView()
    
    override func loadView() {
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.title = "You pooped here"
        
        //create back button to add own Action(dissmiss AdressSearchVC)
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        //default white lol
        backButton.setTitleColor(UIColor.systemBlue, for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .quaternarySystemFill
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc func didTapBackButton() {
        self.dismiss(animated: true)
    }
}

extension SimpleMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "shit")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "shit")
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = "💩".textToImage()
        
        return annotationView
    }
}
