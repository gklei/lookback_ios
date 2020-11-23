//
//  lookbackApp.swift
//  lookback
//
//  Created by Gregory Klein on 11/23/20.
//

import SwiftUI

@main
struct lookbackApp: App {
   let dataLayer = DataLayer.shared
   
   var body: some Scene {
      WindowGroup {
         TabView {
            ActivityListView()
               .tabItem {
                  Image(systemName: "list.dash")
                  Text("Activities")
               }
               .environment(\.managedObjectContext, dataLayer.context)
         }
      }
   }
}
