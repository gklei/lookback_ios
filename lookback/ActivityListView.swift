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
   
   private var addButton: some View {
      switch editMode {
      case .inactive: return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
      default: return AnyView(EmptyView())
      }
   }
   
   var body: some View {
      NavigationView {
         List {
            ForEach(activities, content: ActivityRowView.init)
            .onDelete(perform: onDelete)
         }
         .navigationBarTitle("Activities")
         .navigationBarItems(leading: EditButton(), trailing: addButton)
         .listStyle(PlainListStyle())
         .environment(\.editMode, $editMode)
      }
   }
   
   private func onAdd() {
      withAnimation {
         let _ = dataLayer.createActivity()
         dataLayer.save()
      }
   }
   
   private func onDelete(offsets: IndexSet) {
      withAnimation {
         offsets.map { activities[$0] }.forEach(dataLayer.delete)
         dataLayer.save()
      }
   }
}
