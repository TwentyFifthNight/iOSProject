import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 16){
            TitleView(title: "Color Crash", pauseFunction: viewModel.pauseGame)
            MoveCountView(availableMoves: viewModel.availableMoves)
            DashBoardView(score: viewModel.score, bestScore: viewModel.bestScore)
            
            gridDisplay
                .padding(12)
                .background(.gray)
                .cornerRadius(5)
                .overlay {
                    if !viewModel.isPlaying {
                        ButtonView(title: "Start", action: {
                            withAnimation(.linear(duration: 0.4)){
                                viewModel.startGame()
                            }
                        })
                    }
                    else if viewModel.isPaused {
                        VStack(spacing: 15) {
                            ButtonView(title: "Continue", action: viewModel.resumeGame)
                            ButtonView(title: "Restart", action: {
                                withAnimation(.linear(duration: 0.4)){
                                    viewModel.startGame()
                                }
                            })
                        }
                    }
                }

            if viewModel.combo != 0 {
                withAnimation(.linear(duration: 0.4)) {
                    Text("Combo ")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    +
                    Text("\(viewModel.combo)")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    +
                    Text(" !")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .background(.white)
    }
    
    
    var gridDisplay: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 4), count: viewModel.columnCount), spacing: 4) {
            ForEach(0..<viewModel.grid.count, id: \.self){ index in
              GeometryReader { geo in
                GridCellView(
                    content: viewModel.grid[index],
                    isVisible: !viewModel.isPaused,
                    width: geo.size.width
                )
                .gesture(dragGesture(index: index))
              }
              .aspectRatio(contentMode: .fit)
            }
        }
    }

    func dragGesture(index: Int) -> some Gesture {
		DragGesture(minimumDistance: 0)
            .onChanged { value in
				viewModel.dragAction(value.translation, index)
            }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let model = GameViewModel(6, 6, 20){
            [.oval, .drop, .app, .circle, .star, .heart, .snow].randomElement()!
        }
        ContentView(viewModel: model)
    }
}
