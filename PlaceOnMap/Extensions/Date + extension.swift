//
//  Date + extension.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 24.11.2023.
//

import Foundation

extension Date {
    
    // Use to get ISO80601 formatted date from string
    static func date(from string: String) -> Date? {
        let formater = ISO8601DateFormatter()
        formater.timeZone = .current
        
        return formater.date(from: string)
    }
}
