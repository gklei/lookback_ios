//
//  UIFont+Progress.swift
//  Progress
//
//  Created by Gregory Klein on 5/22/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import UIKit

enum FontWeight: String {
   case xLight = "ExtraLight", light = "Light", medium = "Medium", bold = "Bold", book = "Book", black = "Black"
}

extension UIFont {
   convenience init(_ size: CGFloat, _ weight: FontWeight) {
      self.init(name: "GothamSSm-\(weight.rawValue)", size: size)!
   }
}
