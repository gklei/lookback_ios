//
//  UserSettings.swift
//  lookback
//
//  Created by Gregory Klein on 12/14/20.
//

import Foundation
import SwiftUI

class UserSettings: ObservableObject {
   @Published var darkMode: Bool {
      didSet {
         if darkMode {
            colorThemeIndex = 1
         } else {
            colorThemeIndex = 0
         }
      }
   }
   
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
   
   @Published var defaultActivityColorIndex: Int {
      didSet {
         UserDefaults.standard.setValue(defaultActivityColorIndex, forKey: "LookbackDefaultActivityColorIndex")
      }
   }
   
   var defaultActivityColor: ProgressColor {
      return ProgressColor.markerColors[defaultActivityColorIndex]
   }
   
   init() {
      let index = UserDefaults.standard.integer(forKey: "LookbackColorThemeIndex")
      self.colorThemeIndex = index
      self.darkMode = index == 1
      self.defaultActivityColorIndex = UserDefaults.standard.integer(forKey: "LookbackDefaultActivityColorIndex")
   }
}
