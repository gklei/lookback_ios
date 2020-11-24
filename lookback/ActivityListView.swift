//
//  ContentView.swift
//  lookback
//
//  Created by Gregory Klein on 11/23/20.
//

import SwiftUI

struct ActivityListView: View {
   @State private var editMode = EditMode.inactive
   @EnvironmentObject var dataLayer: DataLayer
   
   @FetchRequest(
      sortDescriptors: [NSSortDescriptor(keyPath: \Activity.creationDate, ascending: true)],
      animation: .default
   )
   private var activities: FetchedResults<Activity>
   @State private var newActivity: Activity?
   @State var activityCreated: Bool = false
   
   private var addButton: some View {
      switch editMode {
      case .inactive: return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
      default: return AnyView(EmptyView())
      }
   }
   
   var body: some View {
      NavigationView {
         HStack {
            if let activity = newActivity {
               NavigationLink(
                  destination: ActivityView(activity: activity, dataLayer: dataLayer, isNew: true),
                  isActive: $activityCreated
               ) {
                  EmptyView()
               }
            }
            List {
               ForEach(activities, content: ActivityRowView.init)
               .onDelete(perform: onDelete)
            }
         }
         .navigationBarTitle("Activities")
         .navigationBarItems(
            leading: EditButton().disabled(activities.count == 0 && editMode == .inactive),
            trailing: addButton
         )
         .listStyle(PlainListStyle())
         .environment(\.editMode, $editMode)
      }
   }
   
   private func onAdd() {
      withAnimation {
         newActivity = dataLayer.createActivity()
         dataLayer.save()
         dataLayer.updateFetchedActivities()
      }
      activityCreated = true
   }
   
   private func onDelete(offsets: IndexSet) {
      withAnimation {
         offsets.map { activities[$0] }.forEach(dataLayer.delete)
         dataLayer.save()
         dataLayer.updateFetchedActivities()
      }
      if activities.count == 0 {
         editMode = .inactive
      }
   }
}
