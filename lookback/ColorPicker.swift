//
//  ColorPicker.swift
//  lookback
//
//  Created by Gregory Klein on 12/16/20.
//

import SwiftUI

struct ColorPicker: View {
   let text: String
   @Binding var selectedColor: Int
   var colors: [ProgressColor]
   
   var body: some View {
      Picker(
         selection: $selectedColor,
         label: Text(text).foregroundColor(.secondary)
      ) {
         ForEach(0 ..< colors.count) {
            Text(self.colors[$0].colorName)
               .bold()
               .foregroundColor(Color(UIColor(colors[$0])))
         }
      }
   }
}
