//
//  AddressSearchViewController.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 01.12.2023.
//

import Foundation
import UIKit
import CoreLocation

protocol AddressSearchViewControllerDelegate: AnyObject {
    func searchViewController(_ vc: AddressSearchViewController, didSelectLoactionWith coordinates: CLLocationCoordinate2D?)
    func didTapLocationButton()
}

class AddressSearchViewController: UIViewController {
    
    private var addressView: AddressView! = nil
    
    var locations = [Location]()
    
    weak var delegate: AddressSearchViewControllerDelegate?
    
    override func loadView() {
        addressView = AddressView()
        self.view = addressView
      
    }
    
    override func viewDidLoad() {
        addressView.searchBar.delegate = self
        addressView.searchBar.searchTextField.delegate = self
        addressView.tableView.delegate = self
        addressView.tableView.dataSource = self
        
        addressView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "pizda")
        
        addressView.userLocationButton.addTarget(self, action: #selector(didTapLocationButton), for: .touchUpInside)
        //to do not let swipe down
        self.isModalInPresentation = true
        
    }
    
    @objc func dissmissKeyboard() {
        addressView.endEditing(true)
    }
    
    @objc func didTapLocationButton() {
        delegate?.didTapLocationButton()
    }
}

//MARK: - UISearchBarDelegate

extension AddressSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}


//MARK: - UITextFieldDelegate
extension AddressSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            LocationManager.shared.findLocations(with: text) { [weak self] locations in
                DispatchQueue.main.async {
                    self?.locations = locations
                    self?.addressView.tableView.reloadData()
                }
               
            }
        }
        return true
    }
}

//MARK: - UITableViewDelegate
extension AddressSearchViewController: UITableViewDelegate {
    
}


//MARK: - UITableViewDataSource
extension AddressSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pizda")
        
        var content = cell?.defaultContentConfiguration()
        content?.text = locations[indexPath.row].title
        content?.textProperties.numberOfLines = 0
        cell?.contentConfiguration = content
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //notify mapConroller
        addressView.searchBar.searchTextField.resignFirstResponder()
        let coordinate = locations[indexPath.row].coordinates
        delegate?.searchViewController(self, didSelectLoactionWith: coordinate?.locationCoordinates())
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
