//
//  ActivityView.swift
//  lookback
//
//  Created by Gregory Klein on 11/23/20.
//

import SwiftUI
import UIKit

struct ActivityView: View {
   let gridViewModel = ActivityGridViewModel()
   var body: some View {
      ActivityGridViewController(viewModel: gridViewModel)
         .navigationTitle("Activity")
         .navigationBarTitleDisplayMode(.inline)
   }
}

class ActivityGridViewModel: ActivityViewControllerDataSource, ActivityViewControllerDelegate {
   func activityViewControllerDidShake() {
   }
   
   func marker(at date: Date) -> Marker? {
      return nil
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
