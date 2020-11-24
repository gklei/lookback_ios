//
//  ActivityGridView.swift
//  lookback
//
//  Created by Gregory Klein on 11/24/20.
//

import SwiftUI

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
