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
          .foregroundColor(.gray)
        
        Button {
          pauseFunction()
        } label: {
          Image(systemName: "pause.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .foregroundColor(.orange)
        }
        
        
      }
  }
}

 struct TitleView_Previews: PreviewProvider {
     static var previews: some View {
         TitleView(title: "Title", pauseFunction: {})
     }
 }
