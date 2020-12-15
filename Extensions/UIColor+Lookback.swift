//
//  UIColor+Progress.swift
//  Progress
//
//  Created by Gregory Klein on 5/22/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import UIKit

enum ProgressColor: String {
   case mint, spearmint, lime, lipstick, darkGray, lightGray, chalkboard, white, pink, markerRed, markerOrange, markerYellow, markerGreen, markerBlue, markerIndigo, markerViolet, markerGray, outerSpace, tileGray
   
   var hex: String {
      switch self {
      case .mint: return "3EF4BC"
      case .spearmint: return "38FFD3"
      case .lime: return "D9F668"
      case .lipstick: return "FB1563"
      case .darkGray: return "515151"
      case .lightGray: return "727272"
      case .chalkboard: return "152235"
      case .outerSpace: return "030D15"
      case .white: return "FFFFFF"
      case .pink: return "FF30EE"
      case .markerRed: return "F57A7A"
      case .markerOrange: return "F5AD7A"
      case .markerYellow: return "DCF57A"
      case .markerGreen: return "7AF5C8"
      case .markerBlue: return "7ACCF5"
      case .markerIndigo: return "AB7AF5"
      case .markerViolet: return "F57AE0"
      case .markerGray: return "B2B6C1"
      case .tileGray: return "EBEBEB"
      }
   }
   
   var colorName: String {
      switch self {
      case .markerRed: return "Red"
      case .markerOrange: return "Orange"
      case .markerYellow: return "Yellow"
      case .markerGreen: return "Green"
      case .markerBlue: return "Blue"
      case .markerIndigo: return "Indigo"
      case .markerViolet: return "Violet"
      case .markerGray: return "Gray"
      default: return hex
      }
   }
   
   var labelTextColor: UIColor {
      switch self {
      case .markerYellow, .markerGreen: return UIColor(.outerSpace, alpha: 0.2)
      default: return .white
      }
   }
   
   static var markerColors: [ProgressColor] {
      return [
         .markerRed,
         .markerOrange,
         .markerYellow,
         .markerGreen,
         .markerBlue,
         .markerIndigo,
         .markerViolet,
         .markerGray
      ]
   }
}

extension UIColor {
   convenience init(_ color: ProgressColor, alpha: CGFloat? = 1) {
      self.init(hex: color.hex, alpha: alpha)
   }
   
   convenience init(hex: String, alpha: CGFloat? = 1) {
      let hex = hex.trimmingCharacters(in: NSCharacterSet.alphanumerics.inverted)
      var int = UInt32()
      Scanner(string: hex).scanHexInt32(&int)
      let a, r, g, b: UInt32
      switch hex.count {
      case 3: // RGB (12-bit)
         (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
      case 6: // RGB (24-bit)
         (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
      case 8: // ARGB (32-bit)
         (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
      default:
         (a, r, g, b) = (1, 1, 1, 0)
      }
      
      let alpha = alpha ?? CGFloat(a) / 255
      self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: alpha)
   }
   
   var isLight: Bool {
      let components = cgColor.components!
      let brightness = (((components[0] * 299.0) as CGFloat) + ((components[1] * 587.0) as CGFloat) + ((components[2] * 114.0)) as CGFloat) / (1000.0 as CGFloat)
      
      return brightness >= 0.7
   }
}
