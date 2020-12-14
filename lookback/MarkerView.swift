//
//  MarkerView.swift
//  lookback
//
//  Created by Gregory Klein on 12/1/20.
//

import SwiftUI
import CoreData

struct MarkerView: View {
   @Environment(\.managedObjectContext) var moc
   @Environment(\.presentationMode) var presentationMode
   @EnvironmentObject var userSettings: UserSettings
   
   let activity: Activity
   let date: Date
   @Binding var markerText: String
   
   var body: some View {
      NavigationView {
         ZStack(alignment: .topLeading) {
            if markerText.isEmpty {
               Text("What did you do?")
                  .font(.title2)
                  .foregroundColor(Color(UIColor.placeholderText))
                  .padding(.horizontal, 22)
                  .padding(.vertical, 24)
                  .zIndex(1)
            }
            TextEditor(text: $markerText)
               .font(.title2)
               .padding()
         }
         .navigationBarTitle("Details")
         .navigationBarTitleDisplayMode(.inline)
         .navigationBarItems(
            leading: Button("Cancel") {
               presentationMode.wrappedValue.dismiss()
            },
            trailing: Button("Done") {
               if let marker = activity.marker(for: date) {
                  marker.descriptionText = markerText.trimmed
               } else if !markerText.trimmed.isEmpty {
                  createMarker(on: date, with: markerText.trimmed)
               }
               try? moc.save()
               presentationMode.wrappedValue.dismiss()
         })
      }
      .environment(\.colorScheme, userSettings.selectedColorScheme)
      .onAppear(perform: {
         if let marker = activity.marker(for: date) {
            markerText = marker.descriptionText ?? ""
         } else {
            markerText = ""
         }
      })
   }
   
   @discardableResult func createMarker(on date: Date, with description: String = "") -> Marker? {
      guard activity.marker(for: date) == nil else { return nil }
      let entity = NSEntityDescription.entity(forEntityName: "Marker", in: moc)
      let marker = Marker(entity: entity!, insertInto: moc)
      marker.id = UUID()
      marker.date = date
      marker.epoch = date.timeIntervalSince1970
      marker.timeZoneID = TimeZone.autoupdatingCurrent.identifier
      marker.descriptionText = description
      marker.activity = activity
      return marker
   }
}
