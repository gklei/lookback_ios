//
//  ReversedFlowLayout.swift
//  lookback
//
//  Created by Gregory Klein on 12/14/20.
//

import UIKit

class ReversedFlowLayout: UICollectionViewFlowLayout {
   var expandContentSizeToBounds: Bool
   
   required init?(coder: NSCoder) {
      self.expandContentSizeToBounds = true
      super.init(coder: coder)
   }
   
   override init() {
      self.expandContentSizeToBounds = true
      super.init()
   }
   
   override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
      guard let cv = collectionView else { return super.shouldInvalidateLayout(forBoundsChange: newBounds) }
      
      let heightDiff = cv.bounds.size.height - newBounds.size.height
      if expandContentSizeToBounds && Float(abs(heightDiff)) > Float.ulpOfOne {
         return true
      } else {
         return super.shouldInvalidateLayout(forBoundsChange: newBounds)
      }
   }
   
   override var collectionViewContentSize: CGSize {
      guard let cv = collectionView else { return super.collectionViewContentSize }
      
      if expandContentSizeToBounds {
         let cvContentSize = super.collectionViewContentSize
         let cvBounds = cv.bounds.size
         let width = cvContentSize.width
         let height = max(cvContentSize.height, cvBounds.height)
         return CGSize(width: width, height: height)
      } else {
         return super.collectionViewContentSize
      }
   }
   
   override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      guard let attribute = super.layoutAttributesForItem(at: indexPath) else { return nil }
      self.modifyLayoutAttribute(attribute)
      return attribute
   }
   
   override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      let normalRect = self.normalRect(for: rect)
      let original = super.layoutAttributesForElements(in: normalRect) ?? []
      let attributes = NSArray(array: original, copyItems: true) as? [UICollectionViewLayoutAttributes] ?? []
      attributes.forEach {
         self.modifyLayoutAttribute($0)
      }
      return attributes
   }
   
   func modifyLayoutAttribute(_ attribute: UICollectionViewLayoutAttributes) {
      let normalCenter = attribute.center
      let reversedCenter = self.reversedPoint(for: normalCenter)
      attribute.center = reversedCenter
   }
   
   func reversedRect(for normalRect: CGRect) -> CGRect {
      let size = normalRect.size
      let normalTopLeft = normalRect.origin
      let reversedBottomLeft = self.reversedPoint(for: normalTopLeft)
      let reversedTopLeft = CGPoint(x: reversedBottomLeft.x, y: reversedBottomLeft.y - size.height)
      return CGRect(
         x: reversedTopLeft.x,
         y: reversedTopLeft.y,
         width: size.width,
         height: size.height
      )
   }
   
   func normalRect(for reversedRect: CGRect) -> CGRect {
      return self.reversedRect(for: reversedRect)
   }
   
   func reversedPoint(for normalPoint: CGPoint) -> CGPoint {
      return CGPoint(x: normalPoint.x, y: self.reversedY(for: normalPoint.y))
   }
   
   func normalPoint(for reversedPoint: CGPoint) -> CGPoint {
      return self.reversedPoint(for: reversedPoint)
   }
   
   func reversedY(for normalY: CGFloat) -> CGFloat {
      return collectionViewContentSize.height - normalY
   }
   
   func normalY(for reversedY: CGFloat) -> CGFloat {
      return self.reversedY(for: reversedY)
   }
}
