//
//  StreaksDataLayer.swift
//  Streaks
//
//  Created by Gregory Klein on 5/17/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Foundation
import CoreData

extension Date {
   func convertToLocalTime(fromTimeZone identifier: String) -> Date? {
      guard let timeZone = TimeZone(identifier: identifier) else { return nil }
      let targetOffset = TimeInterval(timeZone.secondsFromGMT(for: self))
      let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self))
      return self.addingTimeInterval(targetOffset - localOffeset)
   }
}

extension Activity {
   func marker(for date: Date) -> Marker? {
      return self.markers?.filter {
         let marker = $0 as! Marker
         let markerDate = Date(timeIntervalSince1970: marker.epoch)
         let convertedDate = markerDate.convertToLocalTime(fromTimeZone: marker.timeZoneID!)
         return convertedDate!.timeIntervalSince1970 == date.timeIntervalSince1970
      }.first as? Marker
   }
}

extension Marker {
   var progressColor: ProgressColor {
      return ProgressColor(rawValue: activity!.markerColorHex!)!
   }
}

class DataLayer: ObservableObject {
   static let shared = DataLayer()
   
   // MARK: - Core Data Stack
   private lazy var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
       */
      let container = NSPersistentContainer(name: "lookback")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
         if let error = error as NSError? {
            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            fatalError("Unresolved error \(error), \(error.userInfo)")
         }
      })
      return container
   }()
   
   var context: NSManagedObjectContext {
      return persistentContainer.viewContext
   }
   
   fileprivate(set) var fetchedActivities: [Activity] = []
   
   init() {
      updateFetchedActivities()
   }
   
   fileprivate func _newActivityName() -> String {
      switch fetchedActivities.count {
      case 0: return "New Activity"
      default: return "\(fetchedActivities.count + 1).New Activity"
      }
   }
   
   @discardableResult func updateFetchedActivities() -> [Activity] {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
      request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
      request.returnsObjectsAsFaults = false
      fetchedActivities = try! context.fetch(request) as! [Activity]
      return fetchedActivities
   }
   
   func createActivity() -> Activity {
      let name = _newActivityName()
      let entity = NSEntityDescription.entity(forEntityName: "Activity", in: context)
      let newStreak = NSManagedObject(entity: entity!, insertInto: context)
      
      newStreak.setValue(name, forKey: "name")
      newStreak.setValue(Date(), forKey: "creationDate")
      newStreak.setValue(ProgressColor.markerYellow.rawValue, forKey: "markerColorHex")
      
      fetchedActivities.append(newStreak as! Activity)
      return newStreak as! Activity
   }
   
   // MARK: - Core Data Saving support
   func save() {
      let context = persistentContainer.viewContext
      guard context.hasChanges else { return }
      do {
         try context.save()
      } catch {
         let nserror = error as NSError
         fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
   }
   
   func delete(activity: Activity) {
      context.delete(activity)
   }
   
   func toggleActivity(at date: Date, for activity: Activity) {
      if let marker = activity.marker(for: date) {
         context.delete(marker)
      } else {
         createMarker(on: date, for: activity)
      }
   }
   
   @discardableResult func createMarker(on date: Date, for activity: Activity, with description: String = "") -> Marker? {
      guard activity.marker(for: date) == nil else { return nil }
      let entity = NSEntityDescription.entity(forEntityName: "Marker", in: context)
      let newMarker = NSManagedObject(entity: entity!, insertInto: context)
      
      newMarker.setValue(date, forKey: "date")
      newMarker.setValue(date.timeIntervalSince1970, forKey: "epoch")
      newMarker.setValue(TimeZone.autoupdatingCurrent.identifier, forKey: "timeZoneID")
      newMarker.setValue(description, forKey: "descriptionText")
      newMarker.setValue(activity, forKey: "activity")
      return newMarker as? Marker
   }
   
   func marker(before date: Date, in activity: Activity) -> Marker? {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Marker")
      request.predicate = NSPredicate(format: "activity == %@ AND date < %@", activity, date as NSDate)
      request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
      request.returnsObjectsAsFaults = false
      let markers = try! context.fetch(request) as! [Marker]
      return markers.last
   }
   
   func markerWithText(before date: Date, in activity: Activity) -> Marker? {
      guard let m = marker(before: date, in: activity) else { return nil }
      return m.descriptionText!.trimmed.isEmpty ? markerWithText(before: m.date! as Date, in: activity) : m
   }
}
