//
//  ActivityView.swift
//  lookback
//
//  Created by Gregory Klein on 11/23/20.
//

import SwiftUI
import UIKit

struct ActivityView: View {
   let viewModel: ActivityGridViewModel
   
   var body: some View {
      ActivityGridViewController(viewModel: viewModel)
         .navigationTitle("Activity")
         .navigationBarTitleDisplayMode(.inline)
   }
}

class ActivityGridViewModel: ActivityViewControllerDataSource, ActivityViewControllerDelegate {
   let activity: Activity
   
   init(activity: Activity) {
      self.activity = activity
   }
   
   func activityViewControllerDidShake() {
   }
   
   func marker(at date: Date) -> Marker? {
      return activity.marker(for: date)
   }
   
   func dateTapped(_ date: Date, in: ActivityViewController.ViewModel, at: IndexPath) {
      print("tapped: \(date)")
   }
   
   func dateDoubleTapped(_ date: Date, in: ActivityViewController.ViewModel, at: IndexPath) {
      print("double-tapped: \(date)")
   }
}

struct ActivityGridViewController: UIViewControllerRepresentable {
   typealias UIViewControllerType = ActivityViewController
   let viewModel: ActivityGridViewModel
   
   func makeUIViewController(context: Context) -> ActivityViewController {
      let vc = ActivityViewController()
      vc.dataSource = viewModel
      vc.viewModel.delegate = viewModel
      return vc
   }
   
   func updateUIViewController(_ uiViewController: ActivityViewController, context: Context) {
   }
}
