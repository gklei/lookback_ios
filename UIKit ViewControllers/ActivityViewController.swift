//
//  ViewController.swift
//  Progress
//
//  Created by Gregory Klein on 12/14/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit

protocol ActivityViewControllerDataSource: AnyObject {
   func marker(at date: Date) -> Marker?
}

protocol ActivityViewControllerDelegate: AnyObject {
   func activityViewControllerDidShake()
   func dateDoubleTapped(_ date: Date, at indexPath: IndexPath, in viewController: ActivityViewController)
   func dateTapped(_ date: Date, at indexPath: IndexPath, in viewController: ActivityViewController)
}

extension ActivityViewControllerDelegate {
   func activityViewControllerDidShake() {}
}

class ActivityViewController: UIViewController {
   fileprivate var _calendarGrid: CalendarGridViewController!
   weak var dataSource: ActivityViewControllerDataSource?
   weak var delegate: ActivityViewControllerDelegate?
   
   fileprivate let _bobRossQuoteLabel: UILabel = {
      let label = UILabel()
      label.numberOfLines = 0
      label.font = UIFont(28, .light)
      label.textColor = UIColor(.outerSpace, alpha: 0.5)
      label.textAlignment = .center
      return label
   }()
   
   var daysBack: TimeInterval = 90 {
      didSet {
         guard isViewLoaded else { return }
         _calendarGrid.reload()
      }
   }
   
   override var canBecomeFirstResponder: Bool {
      get {
         return true
      }
   }
   
   override func loadView() {
      let view = UIView()
      _calendarGrid = CalendarGridViewController(dataSource: self)
      _calendarGrid.delegate = self
      addChild(_calendarGrid)
      
      _bobRossQuoteLabel.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(_bobRossQuoteLabel)
      NSLayoutConstraint.activate([
         _bobRossQuoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
         _bobRossQuoteLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
         _bobRossQuoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
         _bobRossQuoteLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
      ])
      
      _calendarGrid.view.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(_calendarGrid.view)
      NSLayoutConstraint.activate([
         _calendarGrid.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         _calendarGrid.view.topAnchor.constraint(equalTo: view.topAnchor),
         _calendarGrid.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         _calendarGrid.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
      
      self.view = view
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   // Enable detection of shake motion
   override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
      switch motion {
      case .motionShake: delegate?.activityViewControllerDidShake()
      default: return
      }
   }
   
   func reload() {
      _calendarGrid.reload()
   }
   
   func animateDays(duration: TimeInterval) {
      _calendarGrid.animateDays(duration: duration)
   }
   
   func showBobRossQuote(duration: TimeInterval) {
      _bobRossQuoteLabel.text = BobRossQuoteGenerator().random()
      UIView.animate(withDuration: duration) {
         self._bobRossQuoteLabel.alpha = 1
      }
   }
   
   func hideBobRossQuote(duration: TimeInterval, delay: TimeInterval) {
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
         UIView.animate(withDuration: duration) {
            self._bobRossQuoteLabel.alpha = 0
         }
      }
   }
   
   func showCalendar() {
      _calendarGrid.view.alpha = 1
   }
   
   func hideCalendar() {
      _calendarGrid.view.alpha = 0
   }
}

extension ActivityViewController: CalendarGridViewControllerDataSource {
   var calendar: Calendar {
      return Calendar(identifier: .gregorian)
   }
   
   var startDate: Date {
      let timeIntervalSinceNow: TimeInterval = 60 * 60 * 24 * daysBack
      let daysAgo = calendar.startOfDay(for: Date(timeIntervalSinceNow: -timeIntervalSinceNow))
      let date =  calendar.startOfDay(for: daysAgo.startOfWeek(calendar: calendar)!)
      return date
   }
   
   var endDate: Date {
      return calendar.startOfDay(for: Date())
   }
   
   func marker(at date: Date) -> Marker? {
      return dataSource?.marker(at: date)
   }
}

extension ActivityViewController: CalendarGridViewControllerDelegate {
   func dateDoubleTapped(_ date: Date, at indexPath: IndexPath, in viewController: CalendarGridViewController) {
      delegate?.dateDoubleTapped(date, at: indexPath, in: self)
   }
   
   func dateTapped(_ date: Date, at indexPath: IndexPath, in viewController: CalendarGridViewController) {
      delegate?.dateTapped(date, at: indexPath, in: self)
   }
}

extension Date {
   func startOfWeek(calendar: Calendar) -> Date? {
      let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
      return calendar.date(from: components)
   }
}
