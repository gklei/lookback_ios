//
//  ColorGridViewController.swift
//  Streaks
//
//  Created by Gregory Klein on 5/19/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import UIKit

protocol ColorGridViewControllerDataSource: class {
   var colors: [ProgressColor] { get }
   var markerColor: ProgressColor { get }
}

protocol ColorGridViewControllerDelegate: class {
   func colorSelected(_ color: ProgressColor, in viewController: ColorGridViewController)
}

class ColorGridViewController: UIViewController {
   fileprivate var _cv: UICollectionView!
   fileprivate let _spacingFraction: CGFloat = 0.02
   fileprivate let _cellsPerRow: CGFloat = 4
   
   weak var dataSource: ColorGridViewControllerDataSource?
   weak var delegate: ColorGridViewControllerDelegate?
   
   override func loadView() {
      let view = UIView()
      
      let layout = UICollectionViewFlowLayout()
      _cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
      _cv.dataSource = self
      _cv.delegate = self
      _cv.showsVerticalScrollIndicator = false
      _cv.backgroundColor = .clear
      _cv.delaysContentTouches = false
      ColorGridCell.register(collectionView: _cv)
      
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
      _cv.collectionViewLayout.invalidateLayout()
      _cv.reloadData()
   }
   
   func reload() {
      _cv.reloadData()
   }
}

extension ColorGridViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      let sidePadding = collectionView.bounds.width * _spacingFraction
      return UIEdgeInsets(top: sidePadding, left: sidePadding, bottom: sidePadding, right: sidePadding)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let spacing: CGFloat = collectionView.bounds.width * _spacingFraction
      let totalSpacing = (_cellsPerRow + 1) * spacing
      
      let size = floor((collectionView.bounds.size.width - totalSpacing) / _cellsPerRow)
      return CGSize(width: size, height: size)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return collectionView.bounds.width * _spacingFraction
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return collectionView.bounds.width * _spacingFraction
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      guard let colors = dataSource?.colors else { return }
      delegate?.colorSelected(colors[indexPath.row], in: self)
   }
}

extension ColorGridViewController: UICollectionViewDataSource {
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return dataSource?.colors.count ?? 0
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let colors = dataSource?.colors, let activityColor = dataSource?.markerColor else { fatalError() }
      let color = colors[indexPath.row]
      let selected = color == activityColor
      let cell = ColorGridCell.dequeueCell(with: collectionView, at: indexPath, with: color, selected: selected)
      return cell
   }
}
