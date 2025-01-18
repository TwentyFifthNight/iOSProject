//
//  TitleView.swift
//  ColorCrush
//
//  Created by TwentyFifth on 17/01/2025.
//

import SwiftUI

struct TitleView: View {
    
  let title: String
  let pauseFunction: () -> Void
    
  var body: some View {
      HStack(spacing: 8) {
        Text(title)
          .bold()
          .font(.largeTitle)
          .foregroundColor(Color(red: 120/255, green: 111/255, blue: 102/255))
        
        Button {
          pauseFunction()
        } label: {
          Image(systemName: "pause.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .foregroundColor(Color(red: 236/255, green: 140/255, blue: 85/255))
        }
        
        
      }
  }
}

// struct TitleView_Previews: PreviewProvider {
//     static var previews: some View {
//         TitleView(game: Game(columnCount: 8, rowCount: 8))
//     }
// }
