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
            .foregroundColor(.white)
        
      Text("\(value)")
            .bold()
            .font(.title)
            .foregroundColor(.white)
    }
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity)
    .background(.gray)
    .cornerRadius(10)
  }
}

 struct DashboardView_Previews: PreviewProvider {
     static var previews: some View {
         DashBoardView(score: 5, bestScore: 5)
     }
 }
