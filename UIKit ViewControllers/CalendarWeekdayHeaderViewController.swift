//
//  CalendarWeekdayHeaderViewController.swift
//  Streaks
//
//  Created by Gregory Klein on 12/25/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit

class CalendarWeekdayHeaderViewController: UIViewController {
   class Cell: UICollectionViewCell {
      static var reuseID = "CalendarWeekdayHeader.Cell"
      static var df: DateFormatter {
         let df = DateFormatter()
         df.dateFormat = "MM/dd"
         return df
      }
      
      static func register(collectionView cv: UICollectionView) {
         cv.register(self, forCellWithReuseIdentifier: reuseID)
      }
      
      static func dequeueCell(with collectionView: UICollectionView, at indexPath: IndexPath) -> Cell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! Cell
         cell.configure(with: indexPath.row)
         return cell
      }
      
      fileprivate lazy var _label: UILabel = {
         let label = UILabel()
         label.font = .systemFont(ofSize: 12, weight: .semibold)
         return label
      }()
      
      required init?(coder aDecoder: NSCoder) { fatalError() }
      override init(frame: CGRect) {
         super.init(frame: frame)
         
         _label.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(_label)
         NSLayoutConstraint.activate([
            _label.centerXAnchor.constraint(equalTo: centerXAnchor),
            _label.centerYAnchor.constraint(equalTo: centerYAnchor)
         ])
      }
      
      func configure(with dayIndex: Int) {
         let symbol = Calendar.current.veryShortWeekdaySymbols[dayIndex]
         _label.text = symbol
      }
   }
   
   fileprivate var _cv: UICollectionView!
   fileprivate var _spacingFraction: CGFloat = 0.032
   let calendar: Calendar
   
   required init?(coder aDecoder: NSCoder) { fatalError() }
   init(calendar: Calendar, spacingFraction: CGFloat) {
      self.calendar = calendar
      _spacingFraction = spacingFraction
      super.init(nibName: nil, bundle: nil)
   }
   
   override func loadView() {
      let view = UIView()
      view.backgroundColor = UIColor(.white)
      
      let layout = UICollectionViewFlowLayout()
      _cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
      _cv.dataSource = self
      _cv.delegate = self
      _cv.showsHorizontalScrollIndicator = false
      _cv.backgroundColor = .clear
      Cell.register(collectionView: _cv)
      
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
}

extension CalendarWeekdayHeaderViewController: UICollectionViewDataSource {
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 7
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = Cell.dequeueCell(with: collectionView, at: indexPath)
      return cell
   }
}

extension CalendarWeekdayHeaderViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      let sidePadding = collectionView.bounds.width * _spacingFraction
      return UIEdgeInsets(top: 0, left: sidePadding, bottom: 0, right: sidePadding)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let itemsPerRow = CGFloat(7)
      let spacing: CGFloat = collectionView.bounds.width * _spacingFraction
      let totalSpacing = (itemsPerRow + 1) * spacing
      
      let size = (collectionView.bounds.size.width - totalSpacing) / CGFloat(7)
      return CGSize(width: size, height: collectionView.bounds.height)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return collectionView.bounds.width * _spacingFraction
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return collectionView.bounds.width * _spacingFraction
   }
}
