//
//  CalendarGridCell.swift
//  Streaks
//
//  Created by Gregory Klein on 12/25/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit
import SwiftUI

protocol CalendarGridCellDelegate: class {
   func cellDoubleTapped(cell: CalendarGridCell)
   func cellTapped(cell: CalendarGridCell)
}

class CalendarGridCell: UICollectionViewCell {
   static var reuseID = "CalendarGridCell"
   
   static var monthNameDateFormatter: DateFormatter {
      let df = DateFormatter()
      df.dateFormat = "MMM"
      return df
   }
   
   static func register(collectionView cv: UICollectionView) {
      cv.register(self, forCellWithReuseIdentifier: reuseID)
   }
   
   static func dequeue(with collectionView: UICollectionView, at indexPath: IndexPath, date: Date, marker: Marker?, streakIndex: Int?, isToday: Bool) -> CalendarGridCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! CalendarGridCell
      cell.configure(with: date, marker: marker, streakIndex: streakIndex, isToday: isToday)
      return cell
   }
   
   fileprivate lazy var _monthLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 14, weight: .semibold)
      label.textColor = UIColor(.white)
      return label
   }()
   
   fileprivate(set) lazy var dayNumberLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 12, weight: .light)
      label.textColor = UIColor(.outerSpace, alpha: 0.25)
      return label
   }()
   
   fileprivate lazy var _streakNumberLabel: UILabel = {
      let label = UILabel()
      label.font = UIFont(10, .light)
      label.textColor = UIColor(.outerSpace, alpha: 0.25)
      label.alpha = 0
      return label
   }()
   
   fileprivate lazy var _todayImageView: UIImageView = {
      let imageView = UIImageView(image: #imageLiteral(resourceName: "maximize_3"))
      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true
      return imageView
   }()
   
   var _doubleTapRecognizer: UITapGestureRecognizer!
   var _singleTapRecognizer: UITapGestureRecognizer!
   
   weak var delegate: CalendarGridCellDelegate?
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      _todayImageView.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(_todayImageView)
      NSLayoutConstraint.activate([
         _todayImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         _todayImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
         _todayImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         _todayImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      ])
      
      _monthLabel.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(_monthLabel)
      NSLayoutConstraint.activate([
         _monthLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         _monthLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
      ])
      
      dayNumberLabel.alpha = 0
      dayNumberLabel.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(dayNumberLabel)
      NSLayoutConstraint.activate([
         dayNumberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         dayNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
      ])
      
      _streakNumberLabel.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(_streakNumberLabel)
      NSLayoutConstraint.activate([
         _streakNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
         _streakNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
      ])
      
      _doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CalendarGridCell._doubleTapped))
      _doubleTapRecognizer.numberOfTapsRequired = 2
      
      _singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CalendarGridCell._singleTapped))
      contentView.addGestureRecognizer(_doubleTapRecognizer)
      contentView.addGestureRecognizer(_singleTapRecognizer)
      
      _singleTapRecognizer.require(toFail: _doubleTapRecognizer)
   }
   
   override func prepareForReuse() {
      removeGestureRecognizer(_doubleTapRecognizer)
      removeGestureRecognizer(_singleTapRecognizer)
   }
   
   @objc private func _doubleTapped() {
      delegate?.cellDoubleTapped(cell: self)
   }
   
   @objc private func _singleTapped() {
      delegate?.cellTapped(cell: self)
   }
   
   required init?(coder aDecoder: NSCoder) { fatalError() }
   
   func configure(with date: Date, marker: Marker?, streakIndex: Int?, isToday: Bool) {
      let vm = ViewModel(marker: marker, date: date)
      
      _monthLabel.isHidden = vm.isMonthLabelHidden
      _monthLabel.textColor = vm.monthLabelTextColor
      _monthLabel.text = vm.monthLabelText
      dayNumberLabel.text = vm.dayNumberLabelText
      
//      if isToday {
//         _todayImageView.alpha = 1
//         _todayImageView.tintColor = vm.cellBackgroundColor(streakIndex: streakIndex)
//         contentView.backgroundColor = .clear
//         contentView.borderWidth = 0
//      } else {
         contentView.backgroundColor = vm.cellBackgroundColor(streakIndex: streakIndex)
         contentView.layer.borderColor = vm.cellBorderColor.cgColor
         contentView.layer.cornerRadius = vm.cellCornerRadius
         contentView.layer.borderWidth = vm.cellBorderWidth
         _todayImageView.alpha = 0
//      }
      
      if let streak = streakIndex {
         _streakNumberLabel.text = "\(streak)"
      } else {
         _streakNumberLabel.text = nil
      }
   }
}

extension CalendarGridCell {
   final class ViewModel {
      let marker: Marker?
      let date: Date
      let components: DateComponents
      init(marker: Marker?, date: Date) {
         self.marker = marker
         self.date = date
         components = Calendar.current.dateComponents([.month, .day], from: date)
      }
      
      var monthLabelTextColor: UIColor {
         guard let m = marker else { return .white }
         return m.progressColor.labelTextColor
      }
      
      var isMonthLabelHidden: Bool {
         switch components.day! {
         case 1: return false
         default: return true
         }
      }
      
      var monthLabelText: String {
         return CalendarGridCell.monthNameDateFormatter.string(from: date).uppercased()
      }
      
      var dayNumberLabelText: String {
         switch components.day! {
         case 1: return ""
         default: return "\(components.day!)"
         }
      }
      
      var cellCornerRadius: CGFloat {
         switch components.day! {
         case 1: return 6
         default: return 0
         }
      }
      
      var cellBorderWidth: CGFloat {
         switch components.day! {
         case 1: return marker == nil ? 0 : 2
         default: return 0
         }
      }
      
      var cellBorderColor: UIColor {
         switch marker {
         case .some: return UIColor(.outerSpace, alpha: 0.1)
         case .none: return UIColor(.chalkboard, alpha: 0.2)
         }
      }
      
      func cellBackgroundColor(streakIndex: Int?) -> UIColor {
         switch components.day! {
         case 1:
            switch marker {
            case .some(let m): return _streakColor(for: m, index: streakIndex)
            case .none: return UIColor(Color("FirstOfMonthTile"))
            }
         default:
            switch marker {
            case .some(let m): return _streakColor(for: m, index: streakIndex)
            case .none: return UIColor(Color("TileGray"))
            }
         }
      }
      
      private func _streakColor(for marker: Marker, index: Int?) -> UIColor {
         guard let index = index else { return UIColor(marker.progressColor) }
         let minSaturation: CGFloat = 0.2
         let maxSaturation: CGFloat = 1.1
         let step: CGFloat = 0.15
         let saturation = max(minSaturation, min(maxSaturation, step * CGFloat(index + 1)))
         let color = UIColor(marker.progressColor)
         let hbsa = color.hsbaComponents
         return UIColor(hue: hbsa.hue,
                        saturation: saturation,
                        brightness: hbsa.brightness,
                        alpha: hbsa.alpha)
      }
      
      private func _tileColor(day: Int) -> UIColor {
         let minSaturation: CGFloat = 0
         let maxSaturation: CGFloat = 0.1
         let step: CGFloat = 0.01
         let saturation = max(minSaturation, min(maxSaturation, step * CGFloat(day)))
         let color = UIColor(.tileGray)
         let hbsa = color.hsbaComponents
         print(saturation, day)
         return UIColor(hue: hbsa.hue,
                        saturation: 0,
                        brightness: hbsa.brightness,
                        alpha: hbsa.alpha)
      }
   }
}
