//
//  String+Progress.swift
//  Progress
//
//  Created by Gregory Klein on 5/22/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import UIKit

extension String {
   public var trimmed: String {
      let whitespaceCharacters = NSCharacterSet.whitespacesAndNewlines
      return trimmingCharacters(in: whitespaceCharacters)
   }
   
   func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
      let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
      let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
      return boundingBox.height
   }
}
