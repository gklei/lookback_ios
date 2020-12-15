//
//  ContentView.swift
//  lookback
//
//  Created by Gregory Klein on 11/23/20.
//

import SwiftUI

struct ActivityListView: View {
   @EnvironmentObject var userSettings: UserSettings
   @Environment(\.managedObjectContext) var moc
   @FetchRequest(
      sortDescriptors: [NSSortDescriptor(keyPath: \Activity.creationDate, ascending: true)],
      animation: .default
   )
   private var activities: FetchedResults<Activity>
   
   @State private var editMode = EditMode.inactive

   @Binding var selectedActivity: Activity?
   @State var settingsActivity: Activity?
   
   private var addButton: some View {
      switch editMode {
      case .inactive: return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
      default: return AnyView(EmptyView())
      }
   }
   
   var body: some View {
      NavigationView {
         HStack {
            List {
               ForEach(activities) { activity in
                  HStack {
                     ActivityRowView(activity: activity, selection: selectedActivity)
                        .padding(.trailing)
                        .onTapGesture {
                           selectedActivity = activity
                        }
                     Button(action: {
                        settingsActivity = activity
                     }) {
                        Image(systemName: "pencil")
                           .frame(width: 25, height: 25)
                           .padding(2)
                           .foregroundColor(.blue)
                           .background(Color(white: 0.5, opacity: 0.15))
                           .clipShape(Circle())
                     }
                  }
                  .buttonStyle(PlainButtonStyle())
               }
               .onDelete(perform: onDelete)
            }
         }
         .sheet(item: $settingsActivity) { activity in
            ActivitySettingsView(activity: activity)
               .environmentObject(userSettings)
               .environment(\.managedObjectContext, moc)
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
         activity.markerColorHex = userSettings.defaultActivityColor.rawValue
         try? moc.save()
         settingsActivity = activity
      }
   }
   
   private func onDelete(offsets: IndexSet) {
      withAnimation {
         for offset in offsets {
            let activity = activities[offset]
            if activity.id == selectedActivity?.id {
               selectedActivity = nil
            }
            moc.delete(activity)
         }
         try? moc.save()
      }
      if activities.count == 0 {
         editMode = .inactive
      }
   }
}
