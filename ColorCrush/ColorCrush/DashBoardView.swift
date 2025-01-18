import SwiftUI

struct DashBoardView: View {
    let score: Int
    let bestScore: Int
    
    var body: some View {
      HStack(spacing: 16) {
        Spacer()
          ScoreCard(text: "SCORE", value: score)
          ScoreCard(text: "BEST", value: bestScore)
        Spacer()
        }
    }
  
  func ScoreCard(text: String, value: Int) -> some View{
    VStack {
      Text(text)
            .bold()
            .font(.title2)
            .foregroundColor(Color(red: 240/255, green: 224/255, blue: 213/255))
        
      Text("\(value)")
            .bold()
            .font(.title)
            .foregroundColor(.white)
    }
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity)
    .background(Color(red: 187/255, green: 174/255, blue: 161/255))
    .cornerRadius(10)
  }
}

// struct DashboardView_Previews: PreviewProvider {
//     static var previews: some View {
//         DashBoardView(game: Game(columnCount: 8, rowCount: 8))
//     }
// }
