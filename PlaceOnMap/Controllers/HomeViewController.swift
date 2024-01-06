//
//  ViewController.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 24.11.2023.
//

import UIKit
import MapKit

final class HomeViewController: UIViewController {
    
    private var homeView: HomeView! = nil
    
    private let showPlacesListCell = ShowPlacesListCell()
    private let addPlaceOnMapCell
    = AddPlaceOnMapCell()
    private let spanDelta: Double = 0.01
    
    override func loadView() {
        homeView = HomeView()
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Where did you ..?"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        //Cells registration
        homeView.collectionView.register(ShitCountCell.self, forCellWithReuseIdentifier: ShitCountCell.reuseIdentifier)
        homeView.collectionView.register(ShitPhotoCollectionViewCell.self, forCellWithReuseIdentifier: ShitPhotoCollectionViewCell.reuseIdentifier)
        homeView.collectionView.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: MapCollectionViewCell.reuseIdentifier)
        homeView.collectionView.register(ShowPlacesListCell.self, forCellWithReuseIdentifier: ShowPlacesListCell.reuseIdentifier)
        homeView.collectionView.register(AddPlaceOnMapCell.self, forCellWithReuseIdentifier: AddPlaceOnMapCell.reuseIdentifier)
        
        //Header
        homeView.collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeader.reuseIdentifier)
        
        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
        homeView.collectionView.setCollectionViewLayout(createLayout(), animated: true)
        homeView.collectionView.isScrollEnabled = false
        
        FileCache.shared.loadAllPlaces(from: "shit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeView.collectionView.reloadData()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection in
            
            if sectionIndex == 0 {
                //MARK: - Shit count cell
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.1))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
                
                return section
                
             } else if sectionIndex == 1 {
                //MARK: - Photo govna Section Layout
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.28), heightDimension: .fractionalHeight(0.12))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
                
                let background = NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.kindIdenifier)
                
                section.decorationItems = [background]
                
                return section
            } else if  sectionIndex == 2 {
                //MARK: - Dve Kletki Section Layout
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.22))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item,
                count: 2)
            
                
                let section = NSCollectionLayoutSection(group: group)
        
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
                
                return section
                
            } else  {
                //MARK: - Mesto na karte  Section Layout
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .fractionalHeight(0.3))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1) ,
                                                        heightDimension: .absolute(40))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                let background = NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.kindIdenifier)
                
                section.decorationItems = [background]
                
                return section
            }
        }
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: SectionBackgroundView.kindIdenifier)
        
        return layout
    }
    
    @objc func didTapSortButton() {
     
       
    }
 
}

//MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeader.reuseIdentifier, for: indexPath) as! CollectionViewHeader
        
        header.label.text = "Places where you ..."
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == ShowPlacesListCell.indexPath {
            UIView.animate(withDuration: 0.1, animations: {
                let cell = collectionView.cellForItem(at: indexPath)
                cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { (_) in
                UIView.animate(withDuration: 0.1, animations: {
                    let cell = collectionView.cellForItem(at: indexPath)
                    cell?.transform = CGAffineTransform.identity
                }) { (_) in
                    let vc = ShitListTableViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        if indexPath == AddPlaceOnMapCell.indexPath {
            UIView.animate(withDuration: 0.1, animations: {
                let cell = collectionView.cellForItem(at: indexPath)
                cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { (_) in
                UIView.animate(withDuration: 0.1, animations: {
                    let cell = collectionView.cellForItem(at: indexPath)
                    cell?.transform = CGAffineTransform.identity
                }) { (_) in
                    let vc = MapViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            }
        }
        
        if indexPath.section == 1 {
            let cell = collectionView.cellForItem(at: indexPath) as! ShitPhotoCollectionViewCell
            let vc = DetailPhotoViewController(image: cell.imageView.image!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.section == 3 {
            let vc = SimpleMapViewController()
            let coordinate = FileCache.shared.shitPlaces[indexPath.item].place
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate.locationCoordinates()
            vc.mapView.removeAnnotations(vc.mapView.annotations)
            vc.mapView.addAnnotation(annotation)
            
            let span =  MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta)
            vc.mapView.setRegion(MKCoordinateRegion(center: coordinate.locationCoordinates(), span: span), animated: true)
            
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)
        }
    }
}

//MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            let photos = FileCache.shared.shitPlaces.compactMap { $0.photo?.imageData }
            return photos.count
        } else if section == 2 {
            return 2
        } else  {
            return FileCache.shared.shitPlaces.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShitCountCell.reuseIdentifier, for: indexPath) as! ShitCountCell
            ShitCountCell.indexPath = indexPath

            cell.sortButton.menu = configureDropDownSortButtonMenu()
            cell.sortButton.showsMenuAsPrimaryAction = true
            cell.shitCountLabel.text = "For last day you pooped \(FileCache.shared.shitPlaces.count) times"
            
            return cell
        case 1:
          let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: ShitPhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! ShitPhotoCollectionViewCell
            
            var photos = FileCache.shared.shitPlaces.compactMap { $0.photo?.getImage() }
            cell.imageView.image = photos[indexPath.row]
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.systemYellow.cgColor
            cell.layer.cornerRadius = 16
            cell.layer.masksToBounds = true
            
            return cell
        case 2:
            switch indexPath.row {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowPlacesListCell.reuseIdentifier, for: indexPath) as! ShowPlacesListCell

                ShowPlacesListCell.indexPath = indexPath
                cell.configureShadow()
                cell.numberOfPlacesLabel.text = "\(FileCache.shared.shitPlaces.count) places in total"
                
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPlaceOnMapCell.reuseIdentifier, for: indexPath) as!
                AddPlaceOnMapCell
                AddPlaceOnMapCell.indexPath = indexPath
                cell.configureShadow()
                
                return cell
             
            default: return UICollectionViewCell()
            }
        case 3:
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: MapCollectionViewCell.reuseIdentifier, for: indexPath) as! MapCollectionViewCell
              
            let coordinate = FileCache.shared.shitPlaces[indexPath.item].place
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate.locationCoordinates()
            cell.mapView.removeAnnotations(cell.mapView.annotations)
            cell.mapView.addAnnotation(annotation)
            
            
            let span =  MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta)
            cell.mapView.setRegion(MKCoordinateRegion(center: coordinate.locationCoordinates(), span: span), animated: true)
            cell.mapView.isUserInteractionEnabled = false
            cell.mapView.delegate = self
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    private func configureDropDownSortButtonMenu() -> UIMenu {
        let menu = UIMenu(children: [UIAction(title: "Day",
                                              handler: menuHandler(action:))])
        return menu
    }
    
    //TODO: - Ну сделать сортировку в день неделю месяц типааааа
    private func menuHandler(action: UIAction) {
        print("menuHAndler")
    }
}

extension HomeViewController: MKMapViewDelegate {
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







