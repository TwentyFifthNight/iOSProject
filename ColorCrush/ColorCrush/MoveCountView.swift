import SwiftUI

struct MoveCountView: View {
  let availableMoves: Int
  
  var body: some View {
    HStack() {
      Spacer()
      Capsule()
        .frame(width: 120, height: 40)
        .foregroundColor(Color(red: 236/255, green: 140/255, blue: 85/255))
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

// struct TimerView_Previews: PreviewProvider {
//     static var previews: some View {
//       GeometryReader { geometry in
//           TimerView(game: Game(columnCount: 8, rowCount: 8), geometry: geometry)
//       }
//     }
// }
