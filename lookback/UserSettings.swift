//
//  UserSettings.swift
//  lookback
//
//  Created by Gregory Klein on 12/14/20.
//

import Foundation
import SwiftUI

extension ColorScheme {
   var userDefaultsKey: Int {
      switch self {
      case .light: return 0
      case .dark: return 1
      default: return 2
      }
   }
   
   static func fromUserDefaultsKey(_ key: Int) -> ColorScheme {
      switch key {
      case 0: return .light
      case 1: return .dark
      default: return .light
      }
   }
}

class UserSettings: ObservableObject {
   @Published var appColorScheme: ColorScheme {
      didSet {
         UserDefaults.standard.set(appColorScheme.userDefaultsKey, forKey: "LookbackAppColorScheme")
      }
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
      let colorSchemeKey = UserDefaults.standard.integer(forKey: "LookbackAppColorScheme")
      self.appColorScheme = ColorScheme.fromUserDefaultsKey(colorSchemeKey)
      self.defaultActivityColorIndex = UserDefaults.standard.integer(forKey: "LookbackDefaultActivityColorIndex")
   }
}
