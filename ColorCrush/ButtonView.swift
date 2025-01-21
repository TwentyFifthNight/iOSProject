//
//  ButtonView.swift
//  ColorCrush
//
//  Created by TwentyFifth on 17/01/2025.
//

import SwiftUI

struct ButtonView: View {
    let title: String
    let action: () -> Void
    
    
//    init(title: String, _ action: @escaping () -> Void){
//        self.title = title
//        self.action = action
//    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .bold()
                .font(.title)
                .padding()
                .foregroundColor(.white)
                .background(.orange)
                .cornerRadius(5)
      }
  }
}

struct ButtonView_Previews: PreviewProvider {
     static var previews: some View {
         ButtonView(title: "Button", action: {})
     }
}
