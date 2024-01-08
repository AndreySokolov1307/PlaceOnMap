//
//  AddPlaceOnMapCell + ShadowAnimation.swift
//  PlaceOnMap
//
//  Created by Андрей Соколов on 08.01.2024.
//

import Foundation
import UIKit

extension AddPlaceOnMapCell {
    
    func addShadowAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction] , animations: {
                  self.layer.shadowColor = UIColor.blue.cgColor
                  self.layer.shadowOpacity = 0.4
              }) { (_) in
                  UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {
                      self.layer.shadowColor = UIColor.lightGray.cgColor
                      self.layer.shadowOpacity = 0.2
                  }) { (_) in
                      UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {
                          self.layer.shadowColor = UIColor.blue.cgColor
                          self.layer.shadowOpacity = 0.4
                      }) { (_) in
                          UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {
                              self.layer.shadowColor = UIColor.lightGray.cgColor
                              self.layer.shadowOpacity = 0.2
                          }) { (_) in
                              UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {
                                  self.layer.shadowColor = UIColor.blue.cgColor
                                  self.layer.shadowOpacity = 0.4
                              }) { (_) in
                                  UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {
                                      self.layer.shadowColor = UIColor.lightGray.cgColor
                                      self.layer.shadowOpacity = 0.2
                                  })
                              }
                          }
                      }
                  }
              }
    }
}
