//
//  ActivityRowView.swift
//  lookback
//
//  Created by Gregory Klein on 11/24/20.
//

import SwiftUI

class ActivityRowViewModel: ObservableObject {
   var activity: Activity
   var selection: Activity?
   static let dateFormatter = DateFormatter()
   
   init(activity: Activity, selection: Activity?) {
      self.activity = activity
      self.selection = selection
      Self.dateFormatter.dateStyle = .medium
   }
   
   var creationDate: String {
      return Self.dateFormatter.string(from: activity.creationDate!)
   }
   
   var totalMarkersText: String {
      let total = activity.markers?.count ?? 0
      switch total {
      case 0: return "No markers"
      case 1: return "1 marker"
      default: return "\(activity.markers?.count ?? 0) markers"
      }
   }
   
   var name: String {
      return activity.name!
   }
   
   var isSelected: Bool {
      guard let selection = selection else { return false }
      return activity.id == selection.id
   }
   
   var color: Color {
      let progressColor = ProgressColor(rawValue: activity.markerColorHex!)!
      return Color(UIColor(progressColor))
   }
}

struct ActivityRowView: View {
   @ObservedObject var viewModel: ActivityRowViewModel
   @Environment(\.managedObjectContext) var moc
   
   init(activity: Activity, selection: Activity?) {
      self.viewModel = ActivityRowViewModel(activity: activity, selection: selection)
   }
   
   var body: some View {
      HStack {
         Image(systemName: viewModel.isSelected ? "circle.fill" : "circle")
            .foregroundColor(viewModel.color)
            .padding(.trailing, 8)
         VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.name)
               .font(.system(size: 16, weight: .semibold))
            Text(viewModel.creationDate)
               .font(.system(size: 14))
               .foregroundColor(.gray)
         }
         Spacer()
         HStack {
            VStack(alignment: .trailing) {
               Text(viewModel.totalMarkersText)
                  .font(.system(size: 14))
                  .foregroundColor(.gray)
            }
         }
      }
      .frame(height: 60)
      .contentShape(Rectangle())
   }
}
