//
//  ActivityRowView.swift
//  lookback
//
//  Created by Gregory Klein on 11/24/20.
//

import SwiftUI

struct ActivityRowView: View {
   @EnvironmentObject var dataLayer: DataLayer
   let activity: Activity
   
   init(activity: Activity) {
      self.activity = activity
   }
   
   var body: some View {
      let vm = ActivityViewModel(activity: activity, dataLayer: dataLayer)
      NavigationLink(destination: ActivityView(viewModel: vm)) {
         Text(activity.name!)
      }
   }
}
