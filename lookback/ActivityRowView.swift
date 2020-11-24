//
//  ActivityRowView.swift
//  lookback
//
//  Created by Gregory Klein on 11/24/20.
//

import SwiftUI

struct ActivityRowViewModel {
   let activity: Activity
   static let dateFormatter = DateFormatter()
   
   init(activity: Activity) {
      self.activity = activity
      Self.dateFormatter.dateStyle = .medium
   }
   
   var creationDate: String {
      return Self.dateFormatter.string(from: activity.creationDate!)
   }
   
   var name: String {
      return activity.name!
   }
}

struct ActivityRowView: View {
   let activity: Activity
   let viewModel: ActivityRowViewModel
   @EnvironmentObject var dataLayer: DataLayer
   
   init(activity: Activity) {
      self.activity = activity
      self.viewModel = ActivityRowViewModel(activity: activity)
   }
   
   var body: some View {
      NavigationLink(destination: ActivityView(activity: activity, dataLayer: dataLayer)) {
         VStack(alignment: .leading) {
            Text(viewModel.name)
               .font(.system(size: 16, weight: .semibold))
            Text(viewModel.creationDate)
               .font(.system(size: 14))
               .foregroundColor(.gray)
         }
         .frame(height: 60)
      }
   }
}
