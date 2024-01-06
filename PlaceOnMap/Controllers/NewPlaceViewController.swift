//
//  NewPlaceViewController.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 24.11.2023.
//

import UIKit
import CoreLocation
import MapKit

protocol NewPlaceViewControllerDelegate: AnyObject {
    func addNewPlace()
}

class NewPlaceViewController: UIViewController {
    
    var newPlaceView: NewPlaceView! = nil
    var shitPlace: ShitPlace
    var selectedImage: UIImage? = nil
    private let spanDelta: Double = 0.001
    weak var delegate: NewPlaceViewControllerDelegate?
    
    init(shitPlace: ShitPlace ) {
        self.shitPlace = shitPlace
        if let image = shitPlace.photo?.getImage() {
            self.selectedImage = image
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        newPlaceView = NewPlaceView()
        self.view  = newPlaceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        cellRegistration()
        setupNavBar()
    }
    
    
    private func setupView() {
        newPlaceView?.collectionView.dataSource = self
        newPlaceView?.collectionView.delegate = self
        newPlaceView?.collectionView.setCollectionViewLayout(generateLayout(), animated: true)
    }
    
    private func cellRegistration() {
        newPlaceView?.collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "listCell")
        newPlaceView.collectionView.register(RatingCell.self, forCellWithReuseIdentifier: RatingCell.reuseIdentifier)
        newPlaceView.collectionView.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: MapCollectionViewCell.reuseIdentifier)
        newPlaceView.collectionView.register(RatingCell.self, forCellWithReuseIdentifier: RatingCell.reuseIdentifier)
        newPlaceView.collectionView.register(ShitPhotoCollectionViewCell.self, forCellWithReuseIdentifier: ShitPhotoCollectionViewCell.reuseIdentifier)
    }
    
    private func setupNavBar() {
        navigationItem.title = "Add place "
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", image: nil, target: self, action: #selector(didTapSaveButton))
        navigationItem.largeTitleDisplayMode = .never
        
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        //default white lol
        backButton.setTitleColor(UIColor.systemBlue, for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    @objc func didTapBackButton() {
        dismiss(animated: true) {
            self.delegate?.addNewPlace()
        }
    }
    
    @objc func didTapSaveButton() {
               
        shitPlace.photo = Image(withImage: selectedImage)
        
        FileCache.shared.addNewPlace(place: shitPlace)
        FileCache.shared.saveAllPlaces()
        dismiss(animated: true) {
            self.delegate?.addNewPlace()
        }
    }
}

extension NewPlaceViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            //Address
        case 0:
            return 1
            //Photo
        case 1:
            if let _ = selectedImage {
                return 2
            } else {
                return 1
            }
            //Map
        case 2:
            return 1
            //Rating
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! UICollectionViewListCell
            
            var content = UIListContentConfiguration.valueCell()
            content.text = shitPlace.address!
          
            cell.contentConfiguration = content
            
            return cell
        case 1:
            switch indexPath.item {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! UICollectionViewListCell
                
                var content = UIListContentConfiguration.valueCell()
                
                content.text = "Add photo"
                content.image = UIImage(systemName: "photo.fill")
                cell.accessories = [.disclosureIndicator()]
                
                cell.contentConfiguration = content
                
                return cell
                
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShitPhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! ShitPhotoCollectionViewCell
                
                cell.imageView.image = selectedImage
                cell.imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 44 * 3).isActive = true
                cell.imageView.contentMode = .scaleAspectFit
                cell.accessories = [.delete(displayed: .always, options: UICellAccessory.DeleteOptions(isHidden: false, reservedLayoutWidth: nil, tintColor: nil, backgroundColor: nil), actionHandler: {
                    self.selectedImage = nil
                    self.newPlaceView.collectionView.reloadData()
                })]
                
                return cell
            default :
                return UICollectionViewListCell()
            }
        case 2:
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: MapCollectionViewCell.reuseIdentifier, for: indexPath) as! MapCollectionViewCell
              
            let coordinate = shitPlace.place.locationCoordinates()
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            cell.mapView.addAnnotation(annotation)
            
            let span =  MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta)
            cell.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: true)
            cell.mapView.isUserInteractionEnabled = false
            cell.mapView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44 * 3).isActive = true
            cell.mapView.delegate = self
            
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatingCell.reuseIdentifier, for: indexPath) as! RatingCell
            cell.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
            cell.buttons.forEach { button in
                button.addTarget(self, action: #selector(didTapRatingButton), for: .touchUpInside)
            }
            for i in 0..<shitPlace.rating {
                cell.buttons[i].isSelected = true
            }
            return cell
        default:
            return UICollectionViewListCell()
        }
    }
    
    @objc func didTapRatingButton(sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            let cell = newPlaceView.collectionView.cellForItem(at: IndexPath(item: 0, section: 3)) as! RatingCell
            let index = cell.buttons.firstIndex { button in
                button == sender
            }
            for i in 0...4 {
                if i <= index! {
                    cell.buttons[i].isSelected = true
                } else {
                    cell.buttons[i].isSelected = false
                }
            }
            var selected = cell.buttons.filter { $0.isSelected }
            shitPlace.rating = selected.count
            
        } else {
            let cell = newPlaceView.collectionView.cellForItem(at: IndexPath(item: 0, section: 3)) as! RatingCell
            let index = cell.buttons.firstIndex { button in
                button == sender
            }
            for i in 0...4 {
                if i < index! {
                    cell.buttons[i].isSelected = true
                } else {
                    cell.buttons[i].isSelected = false
                }
            }
            var selected = cell.buttons.filter { $0.isSelected }
            shitPlace.rating = selected.count
        }
    }
}


extension NewPlaceViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if indexPath == IndexPath(item: 0, section: 0) || indexPath == IndexPath(item: 0, section: 2) || indexPath == IndexPath(item: 0, section: 3) {
            return false
        } else {
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath == IndexPath(item: 0, section: 1) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
             
            let allertController = UIAlertController(title: "Choose image sourse", message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            allertController.addAction(cancelAction)
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                }
                allertController.addAction(cameraAction)
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
                }
                allertController.addAction(photoLibraryAction)
            }
            
           // allertController.popoverPresentationController?.sourceView = collectionView.cellForItem(at: indexPath)
            
            present(allertController, animated: true, completion: nil)
        }
    }    
}

extension NewPlaceViewController: MKMapViewDelegate {
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

extension NewPlaceViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        self.selectedImage = selectedImage
        newPlaceView.collectionView.reloadSections(IndexSet(integer: 1))
        dismiss(animated: true, completion: nil)
    }
}

extension NewPlaceViewController: UINavigationControllerDelegate {
    
}

