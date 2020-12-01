//
//  ActivityGridView.swift
//  lookback
//
//  Created by Gregory Klein on 11/24/20.
//

import SwiftUI
import CoreData

struct ActivityGridView: UIViewControllerRepresentable {
   typealias UIViewControllerType = ActivityViewController
   
   class Coordinator: NSObject, ActivityViewControllerDelegate, ActivityViewControllerDataSource {
      var parent: ActivityGridView
      
      init(_ parent: ActivityGridView) {
         self.parent = parent
      }
      
      func marker(at date: Date) -> Marker? {
         return parent.activity.marker(for: date)
      }
      
      func dateTapped(_ date: Date, at indexPath: IndexPath, in viewController: ActivityViewController) {
         parent.selectedDate = date
         parent.showMarkerDetails = true
      }
      
      func dateDoubleTapped(_ date: Date, at indexPath: IndexPath, in viewController: ActivityViewController) {
         if let marker = parent.activity.marker(for: date) {
            parent.moc.delete(marker)
         } else {
            parent.createMarker(on: date)
         }
         try? parent.moc.save()
      }
   }
   
   func makeCoordinator() -> Coordinator {
      return Coordinator(self)
   }
   
   @Environment(\.managedObjectContext) var moc
   var activity: Activity
   @Binding var selectedDate: Date?
   @Binding var showMarkerDetails: Bool
   
   func makeUIViewController(context: Context) -> ActivityViewController {
      let vc = ActivityViewController()
      vc.dataSource = context.coordinator
      vc.delegate = context.coordinator
      return vc
   }
   
   func updateUIViewController(_ uiViewController: ActivityViewController, context: Context) {
      uiViewController.reload()
   }
   
   @discardableResult func createMarker(on date: Date, with description: String = "") -> Marker? {
      guard activity.marker(for: date) == nil else { return nil }
      let entity = NSEntityDescription.entity(forEntityName: "Marker", in: moc)
      let marker = Marker(entity: entity!, insertInto: moc)
      marker.id = UUID()
      marker.date = date
      marker.epoch = date.timeIntervalSince1970
      marker.timeZoneID = TimeZone.autoupdatingCurrent.identifier
      marker.descriptionText = description
      marker.activity = activity
      return marker
   }
}
