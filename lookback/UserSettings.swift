//
//  UserSettings.swift
//  lookback
//
//  Created by Gregory Klein on 12/14/20.
//

import Foundation
import SwiftUI

class UserSettings: ObservableObject {
   @Published var colorThemeIndex: Int {
      didSet {
         UserDefaults.standard.set(colorThemeIndex, forKey: "LookbackColorThemeIndex")
      }
   }
   
   var colorSchemes: [(name: String, value: ColorScheme)] {
      return [
         (name: "Light", value: .light),
         (name: "Dark", value: .dark),
      ]
   }
   
   var selectedColorScheme: ColorScheme {
      return colorSchemes[colorThemeIndex].value
   }
   
   init() {
      self.colorThemeIndex = UserDefaults.standard.integer(forKey: "LookbackColorThemeIndex")
   }
}
