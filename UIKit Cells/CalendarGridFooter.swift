//
//  CalendarGridFooter.swift
//  Streaks
//
//  Created by Gregory Klein on 12/25/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit

class CalendarGridFooter: UICollectionReusableView {
   class Cell: UICollectionViewCell {
      static var reuseID = "CalendarGridFooter.Cell"
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
         label.font = UIFont(12, .bold)
         label.textColor = UIColor(.white)
         return label
      }()
      
      override init(frame: CGRect) {
         super.init(frame: frame)
         
         _label.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(_label)
         NSLayoutConstraint.activate([
            _label.centerXAnchor.constraint(equalTo: centerXAnchor),
            _label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
      }
      
      required init?(coder aDecoder: NSCoder) { fatalError() }
      
      func configure(with dayIndex: Int) {
         let symbol = Calendar.current.veryShortWeekdaySymbols[dayIndex]
         _label.text = symbol
      }
   }
   
   static var reuseID = "CalendarGridHeader"
   static func register(collectionView cv: UICollectionView) {
      cv.register(self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseID)
   }
   
   static func dequeueFooter(with collectionView: UICollectionView, at indexPath: IndexPath) -> CalendarGridFooter {
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                   withReuseIdentifier: reuseID,
                                                                   for: indexPath) as! CalendarGridFooter
      return header
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = UIColor(.chalkboard)
      
      let layout = UICollectionViewFlowLayout()
      _cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
      _cv.dataSource = self
      _cv.delegate = self
      _cv.showsHorizontalScrollIndicator = false
      Cell.register(collectionView: _cv)
      
      _cv.translatesAutoresizingMaskIntoConstraints = false
      addSubview(_cv)
      NSLayoutConstraint.activate([
         _cv.leadingAnchor.constraint(equalTo: leadingAnchor),
         _cv.topAnchor.constraint(equalTo: topAnchor),
         _cv.trailingAnchor.constraint(equalTo: trailingAnchor),
         _cv.bottomAnchor.constraint(equalTo: bottomAnchor)
         ])
   }
   
   required init?(coder aDecoder: NSCoder) { fatalError() }
   
   fileprivate var _cv: UICollectionView!
   fileprivate let _spacingFraction: CGFloat = 0.032
}

extension CalendarGridFooter: UICollectionViewDataSource {
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

extension CalendarGridFooter: UICollectionViewDelegateFlowLayout {
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
