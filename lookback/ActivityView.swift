//
//  ActivityView.swift
//  lookback
//
//  Created by Gregory Klein on 11/23/20.
//

import SwiftUI
import UIKit

struct ActivityView: View {
   @ObservedObject var viewModel: ActivityViewModel
   @State private var showEditSheet: Bool = false
   private var isNew: Bool = false
   
   private var editButton: some View {
      Button(action: {
         showEditSheet = true
      }) {
         Image(systemName: "square.and.pencil").imageScale(.large)
      }
   }
   
   init(activity: Activity, dataLayer: DataLayer, isNew: Bool = false) {
      self.viewModel = ActivityViewModel(activity: activity, dataLayer: dataLayer)
      self.isNew = isNew
   }
   
   var body: some View {
      ActivityGridView(viewModel: viewModel)
         .alert(
            isPresented: $showEditSheet,
            TextAlert(
               title: "Activity Name",
               placeholder: viewModel.name,
               action: viewModel.updateName)
         )
         .navigationBarTitle(viewModel.name)
         .navigationBarTitleDisplayMode(.inline)
         .navigationBarItems(trailing: editButton)
         .onAppear(perform: {
            if isNew {
               showEditSheet.toggle()
            }
         })
   }
}

class ActivityViewModel: ObservableObject, ActivityViewControllerDataSource, ActivityViewControllerDelegate {
   let activity: Activity
   let dataLayer: DataLayer
   
   init(activity: Activity, dataLayer: DataLayer) {
      self.activity = activity
      self.dataLayer = dataLayer
   }
   
   var name: String {
      return activity.name!
   }
   
   func updateName(_ name: String?) {
      guard let name = name?.trimmed, name != "" else { return }
      activity.name = name
      dataLayer.save()
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
