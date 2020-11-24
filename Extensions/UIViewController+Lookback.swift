//
//  UIViewController+Progress.swift
//  Progress
//
//  Created by Gregory Klein on 5/25/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import UIKit

extension UIViewControllerContextTransitioning {
   public var toViewController: UIViewController? {
      return viewController(forKey: UITransitionContextViewControllerKey.to)
   }
   
   public var fromViewController: UIViewController? {
      return viewController(forKey: UITransitionContextViewControllerKey.from)
   }
}
