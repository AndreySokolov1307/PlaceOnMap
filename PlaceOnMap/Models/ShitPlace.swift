//
//  ShitPlace.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 24.11.2023.
//

import Foundation
import UIKit

struct ShitPlace {
    var id: String
    var note: String?
    var place: Coordinate
    var rating: Int?
    var photo: UIImage?
    var date: Date
}

struct Coordinate {
    var latitude: Double
    var longitude: Double
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
        rating: Int?,
        photo: UIImage?,
        date: Date) {
            self.id = UUID().uuidString
            self.note = note
            self.place = place
            self.rating = rating
            self.photo = photo
            self.date = date
        }
}


//MARK: - Json property and json parsing

extension ShitPlace {
    
    var json: Any {
        var dictionary: [String : Any] = [:]
        
        dictionary[JsonKeys.id] = id
        dictionary[JsonKeys.date] = date.ISO8601Format()
        dictionary[JsonKeys.place] = place
        
        if let note = note {
            dictionary[JsonKeys.note] = note
        }
        
        if let rating = rating {
            dictionary[JsonKeys.rating] = rating
        }
        
        if let photo = photo {
            dictionary[JsonKeys.photo] = photo
        }
        
        return dictionary
    }
    
    static func parse(json: Any) -> ShitPlace? {
        guard let dictionary = json as? [String : Any] else { return nil }
        
        guard let id = dictionary[JsonKeys.id] as? String,
              let place = dictionary[JsonKeys.place] as? Coordinate,
              let date = (dictionary[JsonKeys.date] as? String).flatMap(Date.date(from:))
        else { return nil }
      
        let note = dictionary[JsonKeys.note] as? String
        let rating = dictionary[JsonKeys.rating] as? Int
        let photo = dictionary[JsonKeys.photo] as? UIImage
        
        let shitPlace = ShitPlace(id: id,
                                  note: note,
                                  place: place,
                                  rating: rating,
                                  photo: photo,
                                  date: date)
        return shitPlace
    }
}
