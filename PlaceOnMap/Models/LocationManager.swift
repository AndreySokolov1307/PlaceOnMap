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
                                      coordinates: Coordinate(latitude: (place.location?.coordinate.latitude)!, longitude: (place.location?.coordinate.longitude)!))
                return result
            })
            
            completion(models)
        }
    }
    
//    public func getAddress(from coordinates: CLLocation, completion: @escaping (Location) -> Void) {
//        let geocoder = CLGeocoder()
//        
//        geocoder.reverseGeocodeLocation(coordinates) { places, error in
//            let address: [Location] = (places?.compactMap({ place in
//                var name = ""
//                if let locationName = place.name {
//                    name += locationName
//                }
//                
//                if let adminRegion = place.administrativeArea {
//                    name += ", \(adminRegion)"
//                }
//                
//                if let locality = place.locality {
//                    name += ", \(locality)"
//                }
//                
//                if let country = place.country {
//                    name += ", \(country)"
//                }
//                
//                let result = Location(title: name,
//                                      coordinates: Coordinate(latitude: (place.location?.coordinate.latitude)!, longitude: (place.location?.coordinate.longitude)!))
//                return result
//            }))!
//            completion(address.first!)
//        }
//    }
}
