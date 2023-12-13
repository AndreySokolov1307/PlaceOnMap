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
    private var previousLocation: CLLocation?
    private let mapCenterYOffset: CGFloat = 150
    
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
            locationManager.startUpdatingLocation()
            previousLocation = locationManager.location
            break
        case .denied:
            //Show allert with turn on instruction
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
           let offsetCoordinate = getOffsetCoordinate(from: location)
            
            let region = MKCoordinateRegion(center: offsetCoordinate, span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta))
            myMapView.setRegion(region, animated: true)
        }
    }
    
    private func getOffsetCoordinate(from coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        //get point on myMapView
        var newPoint = myMapView.convert(coordinate, toPointTo: myMapView)

        //Add Y offset to the point
        newPoint.y +=  55 + mapCenterYOffset
        
    
        var offsetCoordinate = myMapView.convert(newPoint, toCoordinateFrom: myMapView)

        return offsetCoordinate
    }
    
    private func setupMapView() {
        myMapView.delegate = self
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
        let originY = myMapView.frame.midY
        
        //TODO: - fix that shit, сделать как было раньше - чуть выше, когда нажимает адресс то показывать анотацию и скрывать эту хуйню, когда нажимает плюсик то переходить на некс экран, а то заебало конткретно это делать, когда нажимает на локацию в таблице вылазиет ясейка с адрессом и дискложуре индикатором б или попробовать вернуться к оффсету и добавить разницу игрек хз короче, можно сделать на нажатие локации отдельную анимацию что пин выпадает сверху вних на локацию вроде норм вариант жиесть
            let viewOrigin = CGPoint(x: originX - 15 , y: originY - 55 - mapCenterYOffset)
            
            pinView.frame = CGRect(origin: viewOrigin, size: CGSize(width: 30, height: 55))
    }
    
    private func setupNavBar() {
        navigationItem.title = "Add "
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapGovnoButton))
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
        
        //TODO: - normal async funcrion in location manager
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        geocoder.reverseGeocodeLocation(location) { place, error in
            print(place![0].name)
            print(place![0].location?.coordinate)
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
            print(pinView.frame.maxY)
            print(myMapView.convert(locationManager.location!.coordinate, toPointTo: myMapView))
            
        }
    }
}

//MARK: - AddressSearchViewControllerDelegate

extension MapViewController: AddressSearchViewControllerDelegate {
    func didTapLocationButton() {
        pinView.isCentredOnLocation = true
        centerViewOnUserLocation()
        //print(myMapView.centerCoordinate)
    }
    
    func searchViewController(_ vc: AddressSearchViewController, didSelectLoactionWith coordinates: CLLocationCoordinate2D?) {
        guard let coordinates = coordinates else {
            return
        }
        
        myMapView.removeAnnotations(myMapView.annotations)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        myMapView.addAnnotation(pin)
       // let offsetCootdinate = getOffsetCoordinate(from: coordinates)
       
        //pinView.isHidden = true
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta))
        myMapView.setRegion(region, animated: true)
        print(myMapView.convert(pin.coordinate, toPointTo: myMapView!))
    }
}


//MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locationManagerLocation = locationManager.location,
              let previousLocation = previousLocation,
              locationManagerLocation.distance(from: previousLocation) > 50 else {
            return
        }
            
        guard let location = locations.last else { return }
        self.previousLocation = location
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta))
        myMapView.setRegion(region, animated: true)
    }
    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        print("suka chek")
//        checkLocationAuthorization()
//    }
}

