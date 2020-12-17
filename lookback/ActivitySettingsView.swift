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
               ColorPicker(
                  text: "Color",
                  selectedColor: $selectedColor,
                  colors: ProgressColor.markerColors
               )
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
               let color = ProgressColor.markerColors[selectedColor]
               activity.markerColorHex = color.rawValue
               try? moc.save()
               _dismiss()
            })
      }
      .onAppear {
         activityName = activity.name!
         
         let color = ProgressColor(rawValue: activity.markerColorHex!)!
         selectedColor = ProgressColor.markerColors.indexes(of: color).first ?? 0
      }
      .environment(\.colorScheme, userSettings.appColorScheme)
   }
   
   private func _dismiss() {
      presentationMode.wrappedValue.dismiss()
   }
}
