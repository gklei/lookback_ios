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
         guard let activity = parent.activity else { return nil }
         return activity.marker(for: date)
      }
      
      func dateTapped(_ date: Date, at indexPath: IndexPath, in viewController: ActivityViewController) {
         parent.selectedDate = date
         parent.showMarkerDetails = true
      }
      
      func dateDoubleTapped(_ date: Date, at indexPath: IndexPath, in viewController: ActivityViewController) {
         guard let activity = parent.activity else { return }
         if let marker = activity.marker(for: date) {
            parent.moc.delete(marker)
         } else {
            parent.createMarker(on: date)
         }
         try? parent.moc.save()
         parent.updateGrid.toggle()
      }
   }
   
   func makeCoordinator() -> Coordinator {
      return Coordinator(self)
   }
   
   @Environment(\.managedObjectContext) var moc
   @EnvironmentObject var userSettings: UserSettings
   
   @Binding var activity: Activity?
   @Binding var selectedDate: Date?
   @Binding var showMarkerDetails: Bool
   @Binding var updateGrid: Bool
   
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
      guard let activity = activity else { return nil }
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
