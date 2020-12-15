//
//  ActivitySettingsView.swift
//  lookback
//
//  Created by Gregory Klein on 12/14/20.
//

import SwiftUI

struct ActivitySettingsView: View {
   @EnvironmentObject var userSettings: UserSettings
   @Environment(\.managedObjectContext) var moc
   @Environment(\.presentationMode) var presentationMode
   
   @State private var activityName: String = ""
   
   @State var selectedColor = 0
   var colors: [ProgressColor] {
      return [
         .markerRed,
         .markerOrange,
         .markerYellow,
         .markerGreen,
         .markerBlue,
         .markerIndigo,
         .markerViolet,
         .markerGray
      ]
   }
   
   let activity: Activity
   
   var body: some View {
      NavigationView {
         Form {
            Section {
               HStack {
                  Text("Name")
                     .foregroundColor(.secondary)
                  Spacer()
                  TextField("", text: $activityName)
                     .multilineTextAlignment(.trailing)
               }
               Picker(
                  selection: $selectedColor,
                  label: Text("Marker Color").foregroundColor(.secondary)
               ) {
                  ForEach(0 ..< colors.count) {
                     Text(self.colors[$0].colorName)
                        .bold()
                        .foregroundColor(Color(UIColor(colors[$0])))
                  }
               }
            }
         }
         .navigationBarTitle("Activity Settings")
         .navigationBarTitleDisplayMode(.inline)
         .navigationBarItems(
            leading: Button("Cancel", action: _dismiss),
            trailing: Button("Save") {
               if !activityName.trimmed.isEmpty {
                  activity.name = activityName.trimmed
               }
               let color = colors[selectedColor]
               activity.markerColorHex = color.rawValue
               try? moc.save()
               _dismiss()
            })
      }
      .onAppear {
         activityName = activity.name!
         
         let color = ProgressColor(rawValue: activity.markerColorHex!)!
         selectedColor = colors.indexes(of: color).first ?? 0
      }
      .environment(\.colorScheme, userSettings.selectedColorScheme)
   }
   
   private func _dismiss() {
      presentationMode.wrappedValue.dismiss()
   }
}
