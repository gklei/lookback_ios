//
//  lookbackApp.swift
//  lookback
//
//  Created by Gregory Klein on 11/23/20.
//

import SwiftUI
import CoreData

@main
struct lookbackApp: App {
   private var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
       */
      let container = NSPersistentContainer(name: "lookback")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
         if let error = error as NSError? {
            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            fatalError("Unresolved error \(error), \(error.userInfo)")
         }
      })
      return container
   }()
   
   @State var selectedActivity: Activity?
   
   var body: some Scene {
      WindowGroup {
         TabView {
            ActivityListView(selectedActivity: $selectedActivity)
               .tabItem {
                  Image(systemName: "list.dash")
                  Text("Activities")
               }
               .environment(\.managedObjectContext, persistentContainer.viewContext)
            SelectedActivityView(selectedActivity: $selectedActivity)
               .tabItem {
                  Image(systemName: "square.grid.4x3.fill")
                  Text("Grid")
               }
               .environment(\.managedObjectContext, persistentContainer.viewContext)
            SettingsView()
               .tabItem {
                  Image(systemName: "gear")
                  Text("Settings")
               }
         }
      }
   }
}

struct SelectedActivityView: View {
   @Environment(\.managedObjectContext) var moc
   @FetchRequest(sortDescriptors: [], animation: .default) private var activities: FetchedResults<Activity>
   @Binding var selectedActivity: Activity?
   
   var body: some View {
      NavigationView {
         ActivityView(activity: $selectedActivity).environment(\.managedObjectContext, moc)
            .navigationBarTitle(selectedActivity?.name ?? "No Activity")
      }
   }
}

struct SettingsView: View {
   var body: some View {
      Text("Settings")
   }
}
