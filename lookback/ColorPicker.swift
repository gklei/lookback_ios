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
         ForEach(0 ..< colors.count, id: \.self) { index in
            Text(self.colors[index].colorName)
               .bold()
               .foregroundColor(Color(UIColor(colors[index])))
         }
      }
   }
}
