//
//  LocationManager.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 04.12.2023.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    public func findLocations(with query: String, completion: @escaping(([Location]) -> Void)) {
        let geocoder = CLGeocoder()
    
        geocoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            print(places.count)
            
            let models: [Location] = places.compactMap({ place in
                var name = ""
                if let locationName = place.name {
                    name += locationName
                }
                
                if let adminRegion = place.administrativeArea {
                    name += ", \(adminRegion)"
                }
                
                if let locality = place.locality {
                    name += ", \(locality)"
                }
                
                if let country = place.country {
                    name += ", \(country)"
                }
                
                let result = Location(title: name,
                                      coordinates: place.location?.coordinate)
                return result
            })
            
            completion(models)
        }
    }
}
