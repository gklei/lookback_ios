//
//  ViewController.swift
//  Progress
//
//  Created by Gregory Klein on 12/14/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit

protocol ActivityViewControllerDataSource: class {
   func marker(at date: Date) -> Marker?
}

class ActivityViewController: UIViewController {
   fileprivate var _calendarGrid: CalendarGridViewController!
   weak var dataSource: ActivityViewControllerDataSource?
   var viewModel = ViewModel()
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
      _calendarGrid.viewModel.delegate = self
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
      view.backgroundColor = .white
   }
   
   // Enable detection of shake motion
   override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
      switch motion {
      case .motionShake: viewModel.shake()
      default: return
      }
   }
   
   func reload() {
      _calendarGrid.reload()
   }
   
   func animateDays(duration: TimeInterval) {
      _calendarGrid.animateDays(duration: duration)
   }
   
   func animateCalendar(duration: TimeInterval, delay: TimeInterval, leftToRight: Bool = true) {
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
         let fromAnimation = AnimationType.from(direction: .top, offset: 30.0)
         let zoomAnimation = AnimationType.zoom(scale: 0.2)
         let cells = self._calendarGrid.collectionView.orderedVisibleCells
         
         self._calendarGrid.collectionView.isScrollEnabled = false
         UIView.animate(views: leftToRight ? cells : cells.reversed(),
                        animations: [fromAnimation, zoomAnimation],
                        delay: 0,
                        animationInterval: 0,
                        duration: duration) {
                           self._calendarGrid.collectionView.isScrollEnabled = true
         }
      }
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

protocol ActivityViewControllerDelegate: class {
   func dateDoubleTapped(_ date: Date, in: ActivityViewController.ViewModel, at: IndexPath)
   func dateTapped(_ date: Date, in: ActivityViewController.ViewModel, at: IndexPath)
   func activityViewControllerDidShake()
}

extension ActivityViewController {
   class ViewModel {
      weak var delegate: ActivityViewControllerDelegate?
      func dateDoubleTapped(_ date: Date, at indexPath: IndexPath) {
         delegate?.dateDoubleTapped(date, in: self, at: indexPath)
      }
      
      func dateTapped(_ date: Date, at indexPath: IndexPath) {
         delegate?.dateTapped(date, in: self, at: indexPath)
      }
      
      func shake() {
         delegate?.activityViewControllerDidShake()
      }
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

extension ActivityViewController: CalendarGridViewModelDelegate {
   func dateDoubleTapped(_ date: Date, in viewModel: CalendarGridViewController.ViewModel, at indexPath: IndexPath) {
      self.viewModel.dateDoubleTapped(date, at: indexPath)
   }
   
   func dateTapped(_ date: Date, in: CalendarGridViewController.ViewModel, at indexPath: IndexPath) {
      self.viewModel.dateTapped(date, at: indexPath)
   }
}

extension Date {
   func startOfWeek(calendar: Calendar) -> Date? {
      let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
      return calendar.date(from: components)
   }
}
