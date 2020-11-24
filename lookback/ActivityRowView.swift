//
//  ActivityRowView.swift
//  lookback
//
//  Created by Gregory Klein on 11/24/20.
//

import SwiftUI

class ActivityRowViewModel: ObservableObject {
   @ObservedObject var activity: Activity
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
   @ObservedObject var viewModel: ActivityRowViewModel
   @EnvironmentObject var dataLayer: DataLayer
   
   init(activity: Activity) {
      self.viewModel = ActivityRowViewModel(activity: activity)
   }
   
   var body: some View {
      NavigationLink(
         destination: ActivityView(activity: viewModel.activity, dataLayer: dataLayer)
      ) {
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
