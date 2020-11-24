//
//  ActivityView.swift
//  lookback
//
//  Created by Gregory Klein on 11/23/20.
//

import SwiftUI
import UIKit

struct ActivityView: View {
   let viewModel: ActivityViewModel
   
   var body: some View {
      ActivityGridView(viewModel: viewModel)
         .navigationTitle(viewModel.activity.name!)
         .navigationBarTitleDisplayMode(.inline)
   }
}

struct ActivityGridView: UIViewControllerRepresentable {
   typealias UIViewControllerType = ActivityViewController
   
   @EnvironmentObject var dataLayer: DataLayer
   let viewModel: ActivityViewModel
   
   func makeUIViewController(context: Context) -> ActivityViewController {
      let vc = ActivityViewController()
      vc.dataSource = viewModel
      vc.delegate = viewModel
      return vc
   }
   
   func updateUIViewController(_ uiViewController: ActivityViewController, context: Context) {}
}

class ActivityViewModel: ActivityViewControllerDataSource, ActivityViewControllerDelegate {
   let activity: Activity
   let dataLayer: DataLayer
   
   init(activity: Activity, dataLayer: DataLayer) {
      self.activity = activity
      self.dataLayer = dataLayer
   }
   
   func marker(at date: Date) -> Marker? {
      return activity.marker(for: date)
   }
   
   func dateTapped(_ date: Date, at indexPath: IndexPath, in viewController: ActivityViewController) {
   }
   
   func dateDoubleTapped(_ date: Date, at indexPath: IndexPath, in viewController: ActivityViewController) {
      dataLayer.toggleActivity(at: date, for: activity)
      dataLayer.save()
      viewController.reload()
   }
}
