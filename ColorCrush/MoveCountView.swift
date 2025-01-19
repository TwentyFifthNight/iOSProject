import SwiftUI

struct MoveCountView: View {
  let availableMoves: Int
  
  var body: some View {
    HStack() {
      Spacer()
      Capsule()
        .frame(width: 120, height: 40)
        .foregroundColor(.orange)
        .overlay(alignment: .center){
            Text("\(availableMoves)")
            .bold()
            .font(.title2)
            .foregroundColor(.white)
        }
      Spacer()
    }
  }
}

 struct MoveCountView_Previews: PreviewProvider {
     static var previews: some View {
          MoveCountView(availableMoves: 8)
       
     }
 }
