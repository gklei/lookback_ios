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
   let activity: Activity
   
   var body: some View {
      NavigationView {
         Form {
            Section(header: Text("Name")) {
               TextField("Name", text: $activityName)
            }
         }
         .navigationBarTitle("Activity Settings")
         .navigationBarTitleDisplayMode(.inline)
         .navigationBarItems(
            leading: Button("Cancel", action: _dismiss),
            trailing: Button("Save") {
               if !activityName.trimmed.isEmpty {
                  activity.name = activityName.trimmed
                  try? moc.save()
               }
               _dismiss()
            })
      }
      .onAppear {
         activityName = activity.name!
      }
      .environment(\.colorScheme, userSettings.selectedColorScheme)
   }
   
   private func _dismiss() {
      presentationMode.wrappedValue.dismiss()
   }
}
