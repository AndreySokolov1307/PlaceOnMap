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
        
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection in
            
            if sectionIndex == 0 {
                //MARK: - Shit count cell
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
                
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
     
        let cell = homeView.collectionView.cellForItem(at: ShitCountCell.indexPath!) as! ShitCountCell
        cell.shitCountLabel.text = String(Int.random(in: 0...100))
        
        print("pizda")
    }
 
}

//MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeader.reuseIdentifier, for: indexPath) as! CollectionViewHeader
        
        header.label.text = "Map Header"
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
        } else if section == 2 {
            return 2
        } else {
            let photos = Sample.sample.compactMap { $0.photo }
            return photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShitCountCell.reuseIdentifier, for: indexPath) as! ShitCountCell
            ShitCountCell.indexPath = indexPath

            cell.sortButton.menu = configureDropDownSortButtonMenu()
            cell.sortButton.showsMenuAsPrimaryAction = true
            
            return cell
        case 1:
          let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: ShitPhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! ShitPhotoCollectionViewCell
            
            cell.imageView.image = Sample.sample[indexPath.item].photo
            
            return cell
        case 2:
            switch indexPath.row {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowPlacesListCell.reuseIdentifier, for: indexPath) as! ShowPlacesListCell

                ShowPlacesListCell.indexPath = indexPath
                cell.configureShadow()
                
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
              
            let coordinate = CLLocationCoordinate2D(latitude: Sample.sample[indexPath.item].place.latitude, longitude: Sample.sample[indexPath.item].place.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            cell.mapView.addAnnotation(annotation)
            
            let span =  MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
            cell.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: true)
            cell.mapView.isUserInteractionEnabled = false
            
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
    
    private func menuHandler(action: UIAction) {
        print("menuHAndler")
    }
    
}






