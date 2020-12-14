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
            Section(header: Text("Color Theme")) {
               Picker(selection: $userSettings.colorThemeIndex, label: Text("Choose a color theme")) {
                  ForEach(0 ..< userSettings.colorSchemes.count) {
                     Text(userSettings.colorSchemes[$0].name)
                  }
               }
               .pickerStyle(SegmentedPickerStyle())
            }
         }
         .navigationBarTitle("Settings")
      }
   }
}
