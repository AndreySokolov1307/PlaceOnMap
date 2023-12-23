//
//  ShitPlace.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 24.11.2023.
//

import Foundation
import UIKit
import CoreLocation

struct ShitPlace: Codable {
    var id: String
    var note: String?
    var place: Coordinate
    var rating: Int
    var photo: Image?
    var date: Date
    var address: String?
    
    mutating func getAddress() async {
        let geocoder = CLGeocoder()
        let coordinates = place.locationCoordinates()
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        let addresses = try? await geocoder.reverseGeocodeLocation(location)
        guard let address = addresses?.first else {
            self.address = "Address"
            return
        }
        
        var name = ""
        if let locationName = address.name {
            name += locationName
        }
        
        if let adminRegion = address.administrativeArea {
            name += ", \(adminRegion)"
        }
        
        if let locality = address.locality {
            name += ", \(locality)"
        }
        
        if let country = address.country {
            name += ", \(country)"
        }
        self.address = name
    }
}

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
    
    func locationCoordinates() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

struct Image: Codable {
    let imageData: Data?
    
    init(withImage image: UIImage?) {
        if let image = image {
            self.imageData = image.jpegData(compressionQuality: 1)
        } else {
            self.imageData = nil
        }
    }
    
    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        
        let image = UIImage(data: imageData)
        
        return image
    }
}
//MARK: - Keys for json dictionary

fileprivate enum JsonKeys {
    static let id = "id"
    static let note = "note"
    static let place = "place"
    static let rating = "rating"
    static let photo = "photo"
    static let date = "date"
}


//MARK: - init

extension ShitPlace {
    init(
        note: String?,
        place: Coordinate,
        rating: Int,
        photo: Image?,
        date: Date,
        address: String?) {
            self.id = UUID().uuidString
            self.note = note
            self.place = place
            self.rating = rating
            self.photo = photo
            self.date = date
            self.address = address
        }
}


//MARK: - Json property and json parsing

//extension ShitPlace {
//
//    var json: Any {
//        var dictionary: [String : Any] = [:]
//
//        dictionary[JsonKeys.id] = id
//        dictionary[JsonKeys.date] = date.ISO8601Format()
//        dictionary[JsonKeys.place] = place
//
//        if let note = note {
//            dictionary[JsonKeys.note] = note
//        }
//
//        if let rating = rating {
//            dictionary[JsonKeys.rating] = rating
//        }
//
//        if let photo = photo {
//            dictionary[JsonKeys.photo] = photo
//        }
//
//        return dictionary
//    }
//
//    static func parse(json: Any) -> ShitPlace? {
//        guard let dictionary = json as? [String : Any] else { return nil }
//
//        guard let id = dictionary[JsonKeys.id] as? String,
//              let place = dictionary[JsonKeys.place] as? Coordinate,
//              let date = (dictionary[JsonKeys.date] as? String).flatMap(Date.date(from:))
//        else { return nil }
//
//        let note = dictionary[JsonKeys.note] as? String
//        let rating = dictionary[JsonKeys.rating] as? Int
//        let photo = dictionary[JsonKeys.photo] as? Image
//
//        let shitPlace = ShitPlace(id: id,
//                                  note: note,
//                                  place: place,
//                                  rating: rating,
//                                  photo: photo,
//                                  date: date)
//        return shitPlace
//    }
//}
