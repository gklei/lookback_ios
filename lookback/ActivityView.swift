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
   @EnvironmentObject var userSettings: UserSettings
   
   @State private var showNameAlert: Bool = false
   @State private var updateGrid: Bool = false
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
   @Binding var activity: Activity?
   
   var body: some View {
      NavigationView {
         Group {
            if let activity = activity {
               ActivityGridView(
                  activity: self.$activity,
                  selectedDate: selectedDateBinding,
                  showMarkerDetails: $showMarkerDetails,
                  updateGrid: $updateGrid
               )
               .environmentObject(userSettings)
               .environment(\.managedObjectContext, moc)
               .sheet(isPresented: $showMarkerDetails) {
                  MarkerView(
                     activity: activity,
                     date: selectedDate!,
                     markerText: $markerText
                  )
                  .environmentObject(userSettings)
                  .environment(\.managedObjectContext, moc)
                  .onDisappear(perform: {
                     updateGrid.toggle()
                  })
               }
            } else {
               Text("No activity selected")
            }
         }
         .navigationBarTitle(activity?.name ?? "No Activity")
         .navigationBarTitleDisplayMode(.inline)
      }
   }
}
