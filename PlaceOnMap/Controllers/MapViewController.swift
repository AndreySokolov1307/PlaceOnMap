//
//  MapViewController.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 24.11.2023.
//

import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController {
    
    private var myMapView: MKMapView! = nil
    private lazy var pinView = PinView()
    private lazy var addressSearchViewController = AddressSearchViewController()
    private let locationManager = CLLocationManager()
    private let spanDelta: Double = 0.01
    private var mapOffset: CGFloat = 300
    
    override func loadView() {
        myMapView = MKMapView()
        self.view = myMapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupNavBar()
        setupPinView()
        showAddressSearchVCAsASheet()
        
        checkLocationServices()
    }
    
//MARK:  Setting up locationManager and authorization
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationServices() {
            if CLLocationManager.locationServicesEnabled() {
                self.setupLocationManager()
                self.checkLocationAuthorization()
            } else {
                //show allert that user have to turn this on
            }
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            //Do map stuff
            myMapView.showsUserLocation = true
            centerViewOnUserLocation()
            break
        case .denied:
            //Show allert with turn on instruction
            showAllertWithLocationTurnOnInstruction()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //Show allert that user cant change that app status
            break
        case .authorizedAlways:
            break
        // if new cases are gonna be added in the future
        @unknown default:
            fatalError("add new cases")
        }
    }
  
    private func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate{
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta))
            myMapView.setRegion(region, animated: true)
        }
    }
    
    private func showAllertWithLocationTurnOnInstruction() {
        let alert = UIAlertController(title: "Change location settings.", message: "Your location is turned off. Go to Settings -> Privacy -> Location Servises and allow location usage.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .cancel))
        
        if let presentedVC = self.presentedViewController {
            presentedVC.present(alert, animated: true)
        }
       
    }
    
    private func setupMapView() {
        myMapView.delegate = self
        myMapView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: mapOffset, right: 0)
    }
    
    private func showAddressSearchVCAsASheet() {
        let vc = addressSearchViewController
        addressSearchViewController.delegate = self
        
        if let sheet = vc.sheetPresentationController {
            let startDetentID = UISheetPresentationController.Detent.Identifier(rawValue: "start")
            let start = UISheetPresentationController.Detent.custom(identifier: startDetentID)
            { context in
                self.myMapView.frame.height * 0.4
            }
            sheet.detents = [ start,]
            sheet.selectedDetentIdentifier = .init("start")
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .init("start")
        }
        present(vc, animated: true)
    }
 
    private func setupPinView() {
        myMapView.addSubview(pinView)
    }
    
    //MARK: - viewDidLayoutSubviews
    
    override func viewDidLayoutSubviews() {
        if !pinView.isAnimating {
            setupPinViewCenter()
            if pinView.isFirstAppereance {
                pinView.configureSmallShadowPath()
                pinView.isFirstAppereance = false
            }
        }
    }
    
    private func setupPinViewCenter() {
        let originX = myMapView.frame.midX
        let originY = myMapView.center.y
        
        //UPD: vrode sdelal что ровно на точку встает охуеть
        let viewOrigin = CGPoint(x: originX - 20 , y: originY - 27.5 - mapOffset / 2 )
            pinView.frame = CGRect(origin: viewOrigin, size: CGSize(width: 40, height: 55))
    }
    
    private func setupNavBar() {
        navigationItem.title = "Look for place"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add place", style: .plain, target: self, action: #selector(didTapGovnoButton))
        navigationItem.largeTitleDisplayMode = .never
    
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
        addressSearchViewController.dismiss(animated: false) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func didTapGovnoButton() {
        let x = pinView.frame.midX
        let y = pinView.frame.maxY
        let coordinates = myMapView.convert(CGPoint(x: x, y: y), toCoordinateFrom: myMapView)
        
        let place: Coordinate = Coordinate(latitude: coordinates.latitude, longitude: coordinates.longitude)
        var shitPlace = ShitPlace(note: nil, place: place, rating: 0, photo: nil, date: Date(), address: nil)
        Task {
            await shitPlace.getAddress()
            let controller = NewPlaceViewController(shitPlace: shitPlace)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            
            self.navigationController?.dismiss(animated: false) {
                nav.presentationController?.delegate = self
                self.present(nav, animated: true)
            }
        }
    }
}

//MARK: - MKMapViewDelegate

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        if !pinView.isFirstAppereance {
            pinView.isAnimating = true
            pinView.configureShadowPath()
            
            //EXAPLE of animation of  detent transition
//            vc.sheetPresentationController?.animateChanges {
//                vc.sheetPresentationController?.selectedDetentIdentifier = .init("start")
//            }
            
            //Animation from small shadowPath to big
            let animation1 = CABasicAnimation(keyPath: #keyPath(CALayer.shadowPath))
            
            animation1.fromValue = pinView.getSmallShadowPath
            animation1.toValue = pinView.getBigShadowPath
            animation1.duration = 0.5
            animation1.autoreverses = false
            pinView.layer.add(animation1, forKey: #keyPath(CALayer.shadowPath))
            
            UIView.animate(withDuration: 0.5) {
                self.pinView.transform = CGAffineTransform(translationX: 0, y: -20)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !pinView.isFirstAppereance {
            self.pinView.isAnimating = false
            pinView.configureSmallShadowPath()
        
            // Animation from big shadowPath to small
            let animation2 = CABasicAnimation(keyPath: #keyPath(CALayer.shadowPath))
            
            animation2.fromValue = pinView.getBigShadowPath
            animation2.toValue = pinView.getSmallShadowPath
            animation2.duration = 0.5
            animation2.autoreverses = false
            pinView.layer.add(animation2, forKey: #keyPath(CALayer.shadowPath))
            UIView.animate(withDuration: 0.5, delay: 0, options: []) {
                self.pinView.transform = CGAffineTransform.identity
            }
        }
    }
    
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

//MARK: - AddressSearchViewControllerDelegate

extension MapViewController: AddressSearchViewControllerDelegate {
    func didTapLocationButton() {
        checkLocationAuthorization()
    }
    
    func searchViewController(_ vc: AddressSearchViewController, didSelectLoactionWith coordinates: CLLocationCoordinate2D?) {
        guard let coordinates = coordinates else {
            return
        }
        myMapView.removeAnnotations(myMapView.annotations)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        myMapView.addAnnotation(pin)
        
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta))
        myMapView.setRegion(region, animated: true)
    }
}


//MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
}

extension MapViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
       showAddressSearchVCAsASheet()
    }
}

extension MapViewController: NewPlaceViewControllerDelegate {
    func addNewPlace() {
        showAddressSearchVCAsASheet()
    }
}
