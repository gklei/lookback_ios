//
//  UIImage+Progress.swift
//  Progress
//
//  Created by Gregory Klein on 5/24/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import UIKit

extension UIImage {
   static func with(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
      let rect = CGRect(origin: CGPoint.zero, size: size)
      UIGraphicsBeginImageContextWithOptions(size, false, 0)
      
      color.setFill()
      UIRectFill(rect)
      
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      return image
   }
   
   static func with(color: ProgressColor) -> UIImage? {
      return with(color: UIColor(color))
   }
}
