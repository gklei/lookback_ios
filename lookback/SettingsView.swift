//
//  SettingsView.swift
//  lookback
//
//  Created by Gregory Klein on 12/11/20.
//

import SwiftUI

struct SettingsView: View {
   @EnvironmentObject var userSettings: UserSettings
   
   var body: some View {
      NavigationView {
         Form {
            Section {
               ColorSchemePicker(colorScheme: $userSettings.appColorScheme)
               ColorPicker(
                  text: "Default Activity Color",
                  selectedColor: $userSettings.defaultActivityColorIndex,
                  colors: ProgressColor.markerColors
               )
            }
         }
         .navigationBarTitle("Settings")
      }
   }
}
