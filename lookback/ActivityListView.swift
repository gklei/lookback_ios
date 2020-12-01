//
//  ContentView.swift
//  lookback
//
//  Created by Gregory Klein on 11/23/20.
//

import SwiftUI

struct ActivityListView: View {
   @Environment(\.managedObjectContext) var moc
   @FetchRequest(
      sortDescriptors: [NSSortDescriptor(keyPath: \Activity.creationDate, ascending: true)],
      animation: .default
   )
   private var activities: FetchedResults<Activity>
   @State private var newActivity: Activity?
   @State var activityCreated: Bool = false
   @State private var editMode = EditMode.inactive
   
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
                  destination: ActivityView(activity: activity, isNew: true).environment(\.managedObjectContext, moc),
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
         let activity = Activity(context: moc)
         activity.id = UUID()
         activity.name = "New Activity"
         activity.creationDate = Date()
         activity.markerColorHex = ProgressColor.markerGreen.rawValue
         try? moc.save()
         newActivity = activity
      }
      activityCreated = true
   }
   
   private func onDelete(offsets: IndexSet) {
      withAnimation {
         for offset in offsets {
            let activity = activities[offset]
            moc.delete(activity)
         }
         try? moc.save()
      }
      if activities.count == 0 {
         editMode = .inactive
      }
   }
}
