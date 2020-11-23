//
//  ContentView.swift
//  lookback
//
//  Created by Gregory Klein on 11/23/20.
//

import SwiftUI

struct ActivityListView: View {
   @State private var editMode = EditMode.inactive
   
   @Environment(\.managedObjectContext) private var viewContext
   
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
            ForEach(activities) { activity in
               let vm = ActivityGridViewModel(activity: activity)
               NavigationLink(destination: ActivityView(viewModel: vm)) {
                     Text(activity.name!)
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
      withAnimation {
         let newActivity = DataLayer.shared.createActivity()
         print("creating new activity: \(newActivity)")
          do {
              try viewContext.save()
          } catch {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              let nsError = error as NSError
              fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
          }
      }
   }
   
   private func onDelete(offsets: IndexSet) {
      withAnimation {
          offsets.map { activities[$0] }.forEach(viewContext.delete)
          do {
              try viewContext.save()
          } catch {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              let nsError = error as NSError
              fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
          }
      }
   }
   
   private func onMove(source: IndexSet, destination: Int) {
   }
}

//struct ContentView_Previews: PreviewProvider {
//   static var previews: some View {
//      ActivityListView()
//   }
//}
