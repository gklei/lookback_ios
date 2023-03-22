//
//  CalendarGridViewController.swift
//  Progress
//
//  Created by Gregory Klein on 12/17/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit

protocol CalendarGridViewControllerDataSource: AnyObject {
   var calendar: Calendar { get }
   var startDate: Date { get }
   var endDate: Date { get }
   
   func marker(at date: Date) -> Marker?
}

protocol CalendarGridViewControllerDelegate: AnyObject {
   func dateDoubleTapped(_ date: Date, at indexPath: IndexPath, in viewController: CalendarGridViewController)
   func dateTapped(_ date: Date, at indexPath: IndexPath, in viewController: CalendarGridViewController)
}

class CalendarGridViewController : UIViewController {
   var viewModel = ViewModel()
   weak var dataSource: CalendarGridViewControllerDataSource?
   weak var delegate: CalendarGridViewControllerDelegate?
   
   fileprivate var _headerVC: CalendarWeekdayHeaderViewController!
   fileprivate let _headerFadeInOffset: CGFloat = 40
   fileprivate let _headerFadeInPoints: CGFloat = 40
   
   fileprivate var _cv: UICollectionView!
   fileprivate let _spacingFraction: CGFloat = 0.015
   
   fileprivate var _propertyAnimatorIn: UIViewPropertyAnimator?
   fileprivate var _propertyAnimatorOut: UIViewPropertyAnimator?
   
   fileprivate lazy var _refreshControl: UIRefreshControl = {
      let control = UIRefreshControl()
      control.tintColor = UIColor(.tileGray)
      let selector = #selector(CalendarGridViewController._refreshControlChanged(control:))
      control.addTarget(self, action: selector, for: .valueChanged)
      control.layer.zPosition = -1
      return control
   }()
   
   var collectionView: UICollectionView { return _cv }
   
   required init?(coder aDecoder: NSCoder) { fatalError() }
   init(dataSource: CalendarGridViewControllerDataSource) {
      self.dataSource = dataSource
      super.init(nibName: nil, bundle: nil)
      _headerVC = CalendarWeekdayHeaderViewController(calendar: dataSource.calendar, spacingFraction: _spacingFraction)
   }
   
   override func loadView() {
      let view = UIView()
      
      let layout = ReversedFlowLayout()
      _cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
      _cv.dataSource = self
      _cv.delegate = self
      _cv.showsVerticalScrollIndicator = false
      _cv.backgroundColor = .clear
      _cv.delaysContentTouches = false
//      _cv.refreshControl = _refreshControl
      CalendarGridCell.register(collectionView: _cv)
      
      _cv.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(_cv)
      
      NSLayoutConstraint.activate([
         _cv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         _cv.topAnchor.constraint(equalTo: view.topAnchor),
         _cv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         _cv.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])

      self.view = view
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      addChild(_headerVC)
      let headerView = _headerVC.view!
      headerView.translatesAutoresizingMaskIntoConstraints = false
      view.insertSubview(headerView, at: 0)
      
      NSLayoutConstraint.activate([
         headerView.topAnchor.constraint(equalTo: view.topAnchor),
         headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         headerView.heightAnchor.constraint(equalToConstant: 60),
      ])
      
      _refreshControl.bounds = _refreshControl.bounds.insetBy(dx: 0, dy: -40)
      _updateHeaderViewAlpha(scrollViewOffset: 0)
   }
   
   func reload() {
      _cv.reloadData()
   }
   
   func animateDays(duration: TimeInterval) {
      _cv.visibleCells.forEach { cell in
         let animateDuration = duration / 4.0
         let pauseDuration = animateDuration * 2
         _propertyAnimatorIn = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: animateDuration,
                                                                              delay: 0,
                                                                              options: .curveEaseIn,
                                                                              animations: {
            (cell as? CalendarGridCell)?.dayNumberLabel.alpha = 1
         }) { (pos) in
            self._propertyAnimatorOut = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: animateDuration,
                                                                                       delay: pauseDuration,
                                                                                       options: .curveEaseOut,
                                                                                       animations: {
               (cell as? CalendarGridCell)?.dayNumberLabel.alpha = 0
            })
         }
      }
   }
   
   fileprivate func _updateHeaderViewAlpha(scrollViewOffset: CGFloat) {
      if scrollViewOffset < -_headerFadeInOffset {
         let progress = ((scrollViewOffset * -1) - _headerFadeInOffset) / _headerFadeInPoints
         _headerVC.view.alpha = min(progress, 1)
         _refreshControl.alpha = min(progress, 1)
      } else {
         _headerVC.view.alpha = 0
         _refreshControl.alpha = 0
      }
   }
   
   @objc private func _refreshControlChanged(control: UIRefreshControl) {
      guard control.isRefreshing else { return }
      reload()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { control.endRefreshing() }
   }
}

extension CalendarGridViewController: UICollectionViewDataSource {
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      guard let ds = dataSource else { return 0 }
      let components = ds.calendar.dateComponents([.day], from: ds.startDate, to: ds.endDate)
      guard let totalDays = components.day else { return 0 }
      return totalDays + 1
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let date = _date(for: indexPath)
      let marker = dataSource?.marker(at: date)
      let idx = _streakIndex(at: indexPath)
      let isToday = date == dataSource?.endDate
      let cell = CalendarGridCell.dequeue(with: collectionView, at: indexPath, date: date, marker: marker, streakIndex: idx, isToday: isToday)
      cell.delegate = self
      return cell
   }
   
   // Given the nature of this method being called in the order of the cells rendered, it only needs to count
   // the markers that are sequentially before the index path passed in
   private func _streakIndex(at indexPath: IndexPath) -> Int? {
      var totalBefore: Int? = nil
      var idx = indexPath.row
      while idx >= 0, dataSource?.marker(at: _date(for: _ip(idx))) != nil {
         switch totalBefore {
         case .none: totalBefore = 0
         case .some(let val): totalBefore = val + 1
         }
         idx -= 1
      }
      return totalBefore
   }
   
   private func _ip(_ index: Int) -> IndexPath {
      return IndexPath(row: index, section: 0)
   }
   
   fileprivate func _date(for indexPath: IndexPath) -> Date {
      guard let ds = dataSource else { fatalError() }
      var components = DateComponents()
      components.day = indexPath.row
      return ds.calendar.date(byAdding: components, to: ds.startDate)!
   }
}

extension CalendarGridViewController: CalendarGridCellDelegate {
   func cellDoubleTapped(cell: CalendarGridCell) {
      guard let indexPath = _cv.indexPath(for: cell) else { return }
//      viewModel.dateDoubleTapped(_date(for: indexPath), at: indexPath)
      delegate?.dateDoubleTapped(_date(for: indexPath), at: indexPath, in: self)
   }
   
   func cellTapped(cell: CalendarGridCell) {
      guard let indexPath = _cv.indexPath(for: cell) else { return }
//      viewModel.dateTapped(_date(for: indexPath), at: indexPath)
      delegate?.dateTapped(_date(for: indexPath), at: indexPath, in: self)
   }
}

extension CalendarGridViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      let sidePadding = collectionView.bounds.width * _spacingFraction
      return UIEdgeInsets(top: sidePadding, left: sidePadding, bottom: sidePadding, right: sidePadding)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      guard let ds = dataSource else { return .zero }
      
      let itemsPerRow = CGFloat(ds.calendar.weekdaySymbols.count)
      let spacing: CGFloat = collectionView.bounds.width * _spacingFraction
      let totalSpacing = (itemsPerRow + 1) * spacing
      
      let size = (collectionView.bounds.size.width - totalSpacing) / CGFloat(ds.calendar.weekdaySymbols.count)
      return CGSize(width: size, height: size)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return collectionView.bounds.width * _spacingFraction
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return collectionView.bounds.width * (_spacingFraction / 2)
   }
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      _updateHeaderViewAlpha(scrollViewOffset: scrollView.contentOffset.y)
   }
}

protocol CalendarGridViewModelDelegate: AnyObject {
   func dateDoubleTapped(_ date: Date, in: CalendarGridViewController.ViewModel, at indexPath: IndexPath)
   func dateTapped(_ date: Date, in: CalendarGridViewController.ViewModel, at indexPath: IndexPath)
}

extension CalendarGridViewController {
   class ViewModel {
      weak var delegate: CalendarGridViewModelDelegate?
      
      func dateDoubleTapped(_ date: Date, at indexPath: IndexPath) {
         delegate?.dateDoubleTapped(date, in: self, at: indexPath)
      }
      
      func dateTapped(_ date: Date, at indexPath: IndexPath) {
         delegate?.dateTapped(date, in: self, at: indexPath)
      }
   }
}
