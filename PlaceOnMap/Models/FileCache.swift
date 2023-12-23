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
                print("midified")
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
        let archieveURL = documentsDirectory.appendingPathComponent("shit_places").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodedPlaces = try? propertyListEncoder.encode(shitPlaces)
        
        try? encodedPlaces?.write(to: archieveURL, options: .noFileProtection)
        
    }
    
    func loadAllPlaces(from file: String = "shitPlaces") {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first!
        let archieveURL = documentsDirectory.appendingPathComponent("shit_places").appendingPathExtension("plist")
        let propertyListDecoder = PropertyListDecoder()
        
        if let retrievedNotesData = try? Data.init(contentsOf: archieveURL), let decodedPlaces = try? propertyListDecoder.decode(Array<ShitPlace>.self, from: retrievedNotesData) {
            self.shitPlaces = decodedPlaces
        }
    }
}
