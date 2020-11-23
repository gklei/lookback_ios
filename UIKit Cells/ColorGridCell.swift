//
//  ColorGridCell.swift
//  Streaks
//
//  Created by Gregory Klein on 5/19/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import UIKit

class ColorGridCell: UICollectionViewCell {
   static var reuseID = "ColorGridCell"
   
   static func register(collectionView cv: UICollectionView) {
      cv.register(self, forCellWithReuseIdentifier: reuseID)
   }
   
   static func dequeueCell(with collectionView: UICollectionView, at indexPath: IndexPath, with color: ProgressColor, selected: Bool) -> ColorGridCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! ColorGridCell
      cell.configure(with: color, selected: selected)
      return cell
   }
   
   func configure(with color: ProgressColor, selected: Bool) {
      contentView.layer.borderWidth = 4
      contentView.layer.cornerRadius = 12
      contentView.layer.borderColor = UIColor(color).cgColor
      switch selected {
      case true:
         contentView.layer.backgroundColor = UIColor(color).cgColor
      case false:
         contentView.layer.backgroundColor = UIColor(color, alpha: 0.1).cgColor
      }
   }
}
