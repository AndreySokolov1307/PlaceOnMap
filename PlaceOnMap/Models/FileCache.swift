//
//  FileCache.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 24.11.2023.
//

import Foundation


class FileCache {
    
    static let shared = FileCache()
    
    private(set) var shitPlaces: [ShitPlace] = []
     
    func addNewPlace(place: ShitPlace) {
        if !shitPlaces.contains(where: { $0.id == place.id }) {
            shitPlaces.append(place)
        } else {
            if let index = shitPlaces.firstIndex(where: { $0.id == place.id }) {
                shitPlaces.remove(at: index)
                shitPlaces.insert(place, at: index)
            }
        }
    }
    
    func removePlaceWithId(id: String) {
        shitPlaces.removeAll { $0.id == id }
    }
    
    func saveAllPlaces(to file: String = "shitPlaces") {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first!
        let archieveURL = documentsDirectory.appendingPathComponent(file).appendingPathExtension("json")
    
        let jsonArray = shitPlaces.map { $0.json }
        
        guard let data = try? JSONSerialization.data(withJSONObject: jsonArray, options: [])
        else { print("Could not recieve data form json object"); return }
        
        do {
            try data.write(to: archieveURL)
        } catch {
            print("Couldnot write data to file")
        }
       
    }
    
    func loadAllPlaces(from file: String = "shitPlaces") {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first!
        let archieveURL = documentsDirectory.appendingPathComponent(file).appendingPathExtension("json")
        
        guard let retrievedJsonData = try? Data(contentsOf: archieveURL)
        else {print("Could not retrieve json data"); return}
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: retrievedJsonData,
                                                                 options: []) as? [Any]
        else {print("Could not recieve json object"); return}
        
        shitPlaces = jsonObject.compactMap(ShitPlace.parse)
    }
}
