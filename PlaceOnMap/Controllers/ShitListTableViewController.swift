//
//  ShitListTableViewController.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 24.11.2023.
//

import UIKit

final class ShitListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Poop places"
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(ShitListTableViewCell.self, forCellReuseIdentifier: ShitListTableViewCell.reuseIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FileCache.shared.shitPlaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShitListTableViewCell.reuseIdentifier, for: indexPath) as! ShitListTableViewCell
        
        if let image = FileCache.shared.shitPlaces[indexPath.row].photo {
            cell.photoImageView.image = image.getImage()
        } else {
            cell.photoImageView.image = UIImage(systemName: "photo")
        }
        cell.addressLabel.text = FileCache.shared.shitPlaces[indexPath.row].address!
        cell.ratingLabel.text = getRatingLabelText(with: FileCache.shared.shitPlaces[indexPath.row].rating)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    private func getRatingLabelText(with rating: Int) -> String {
        if rating == 0 {
            return "Rating - 0"
        }
        
        var string = "Rating -"
        for _ in 1...rating {
            string += " ⭐️"
        }
        return string
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let place = FileCache.shared.shitPlaces[indexPath.row]
        let action = UIContextualAction(style: .destructive,
                                        title: "Delete") { [weak self] (action, view, completion) in
            FileCache.shared.removePlaceWithId(id: place.id)
           
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            FileCache.shared.saveAllPlaces()
            completion(true)
        }
        action.backgroundColor = .systemRed
        action.image = UIImage(systemName: "trash")
        return action
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let controller = NewPlaceViewController(shitPlace: FileCache.shared.shitPlaces[indexPath.row])
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        
        self.present(nav, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ShitListTableViewController: NewPlaceViewControllerDelegate {
    func addNewPlace() {
        tableView.reloadData()
    }
}
