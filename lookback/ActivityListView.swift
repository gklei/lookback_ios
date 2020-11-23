//
//  ContentView.swift
//  lookback
//
//  Created by Gregory Klein on 11/23/20.
//

import SwiftUI

struct Activity2: Identifiable {
   let id = UUID()
   let title: String
}

struct ActivityListView: View {
   @State private var editMode = EditMode.inactive
   
   @State private var activities: [Activity2] = [
      Activity2(title: "Push-Ups"),
      Activity2(title: "Reading")
   ]
   
   private var addButton: some View {
      switch editMode {
      case .inactive: return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
      default: return AnyView(EmptyView())
      }
   }
   
   var body: some View {
      NavigationView {
         List {
            ForEach(activities) { activity in
               NavigationLink(destination: ActivityView()) {
                     Text(activity.title)
               }
            }
            .onDelete(perform: onDelete)
            .onMove(perform: onMove)
         }
         .navigationBarTitle("Activities")
         .navigationBarItems(leading: EditButton(), trailing: addButton)
         .listStyle(PlainListStyle())
         .environment(\.editMode, $editMode)
      }
   }
   
   func onAdd() {
      let new = Activity2(title: "New activity \(activities.count + 1)")
      activities.append(new)
   }
   
   private func onDelete(offsets: IndexSet) {
      activities.remove(atOffsets: offsets)
   }
   
   private func onMove(source: IndexSet, destination: Int) {
      activities.move(fromOffsets: source, toOffset: destination)
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ActivityListView()
   }
}
