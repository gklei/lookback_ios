//
//  UILabel+Progress.swift
//  Progress
//
//  Created by Gregory Klein on 5/22/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import UIKit

extension UILabel {
   static func with(text: String?, font: UIFont, color: UIColor, alignment: NSTextAlignment = .center) -> UILabel {
      let label = UILabel()
      label.text = text
      label.font = font
      label.textColor = color
      label.sizeToFit()
      label.textAlignment = alignment
      return label
   }
   
   func sizeToFit(constrainedWidth width: CGFloat) {
      guard let text = text else { return }
      let height = text.heightWithConstrainedWidth(width: width, font: font)
      let newFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
      frame = newFrame
   }
}
