//
//  ActivityView.swift
//  lookback
//
//  Created by Gregory Klein on 11/23/20.
//

import SwiftUI
import UIKit
import CoreData

struct ActivityView: View {
   @Environment(\.managedObjectContext) var moc
   @State private var showNameAlert: Bool = false
   @State private var selectedDate: Date?
   private var selectedDateBinding: Binding<Date?> {
      Binding(
         get: { self.selectedDate },
         set: { (newValue) in
            self.selectedDate = newValue
         }
      )
   }
   @State private var showMarkerDetails: Bool = false
   @State private var markerText: String = ""
   @ObservedObject private var activity: Activity
   
   private var isNew: Bool = false
   private var editButton: some View {
      Button(action: {
         showNameAlert.toggle()
      }) {
         Image(systemName: "square.and.pencil").imageScale(.large)
      }
   }
   
   init(activity: Activity, isNew: Bool = false) {
      self.activity = activity
      self.isNew = isNew
   }
   
   var body: some View {
      ActivityGridView(
         activity: activity,
         selectedDate: selectedDateBinding,
         showMarkerDetails: $showMarkerDetails
      )
      .environment(\.managedObjectContext, moc)
      .alert(
         isPresented: $showNameAlert,
         TextAlert(
            title: "Activity Name",
            message: "Enter the name of this activity",
            action: updateActivityName
         )
      )
      .sheet(isPresented: $showMarkerDetails) {
         MarkerView(
            activity: activity,
            date: selectedDate!,
            markerText: $markerText
         )
         .environment(\.managedObjectContext, moc)
      }
      .navigationBarTitle(activity.name!)
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(trailing: editButton)
      .onAppear(perform: {
         if self.isNew {
            showNameAlert.toggle()
         }
      })
   }
   
   func updateActivityName(_ name: String?) {
      guard let name = name, !name.trimmed.isEmpty else { return }
      activity.name = name.trimmed
      try? moc.save()
   }
}
