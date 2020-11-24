//
//  UIView+Progress.swift
//  Progress
//
//  Created by Gregory Klein on 5/25/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import UIKit

extension UIView {
   public func addAndFill(subview: UIView, at index: Int) {
      insertSubview(subview, at: index)
      subview.translatesAutoresizingMaskIntoConstraints = false
      subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
      subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
      subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
   }
   
   public func addAndFill(subview: UIView) {
      addSubview(subview)
      subview.translatesAutoresizingMaskIntoConstraints = false
      subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
      subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
      subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
   }
   
   static func autolayoutView() -> UIView {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
   }
   
   func setShadow(color: UIColor = UIColor(.chalkboard), opacity: Float = 0.2, xOffset: CGFloat = 0, yOffset: CGFloat = 0, radius: CGFloat = 20) {
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
      layer.shadowRadius = radius
      layer.shadowPath = UIBezierPath(rect: bounds).cgPath
   }
}
