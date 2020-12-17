//
//  ColorSchemePicker.swift
//  lookback
//
//  Created by Gregory Klein on 12/16/20.
//

import SwiftUI

struct ColorSchemePicker: View {
   @Binding var colorScheme: ColorScheme
   
   var body: some View {
      let binding = Binding(
         get: { return colorScheme == .dark },
         set: { colorScheme = $0 ? .dark : .light }
      )
      HStack {
         Text("Dark Mode")
            .foregroundColor(.secondary)
         Spacer()
         Toggle("", isOn: binding)
      }
      .pickerStyle(SegmentedPickerStyle())
   }
}
