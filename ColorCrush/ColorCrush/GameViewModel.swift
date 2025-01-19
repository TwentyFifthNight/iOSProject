import SwiftUI

class GameViewModel: ObservableObject {
    @Published private var model: GameModel
    private var startDetectDrag = false

    init(_ columnCount: Int, _ rowCount: Int, _ maxMoves: Int, _ contentFactory: @escaping () -> ContentType) {
        var column = columnCount
        var row = rowCount
        var moves = maxMoves
        if columnCount < 4{
            column = 4
        }
        if rowCount < 4{
            row = 4
        }
        if maxMoves < 5{
            moves = 5
        }
        
        self.model = GameViewModel.createGameModel(column, row, moves, contentFactory)
    }

    private static func createGameModel(_ columnCount: Int, _ rowCount: Int, _ maxMoves: Int, _ factory: @escaping () -> ContentType) -> GameModel {
        return GameModel(columnCount: columnCount, rowCount: rowCount, maxMoves: maxMoves, contentFactory: factory)
    }

    func dragAction(_ translation: CGSize, _ index: Int){
        if startDetectDrag && !model.isProcessing && model.isPlaying && !model.isPaused {
            var to: Int = -1
            if translation.width > 5 { // swipe right
                if !stride(from: model.columnCount - 1, through: model.grid.count - 1, by: model.columnCount).contains(index) {
                    to = index + 1
                }
            } else if translation.width < -5 { // swipe left
                if !stride(from: 0, through: model.grid.count - model.columnCount, by: model.columnCount).contains(index) {
                    to = index - 1
                }
            } else if translation.height < -5 { // swipe up
                if !(0..<model.columnCount).contains(index) {
                    to = index - model.columnCount
                }
            } else if translation.height > 5 { // swipe down
                if !(model.grid.count - model.columnCount..<model.grid.count).contains(index) {
                    to = index + model.columnCount
                }
            }

            if to > -1{
                startDetectDrag = false
                withAnimation(.easeInOut(duration: 0.5)) {
                    model.move(index, to)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                    model.process()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [self] in
                    withAnimation(.easeInOut(duration: 0.5)){
                        model.finishMove(index, to)
                    }
                }
//                withAnimation(.easeInOut(duration: 0.4)) {
//                    model.swap(index, to)
//                }
//            
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [self] in
//                    withAnimation(.linear(duration: 1)) {
//                        model.move(index, to)
//                    }
//                }
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [self] in
//                    while model.isProcessing{
//                        
//                    }
//                    if !model.wasMatch && model.isPlaying{
//                        withAnimation(.linear(duration: 0.4)) {
//                            model.swap(index, to)
//                        }
//                    }
//                }
            }
      } else {
          if translation == .zero {
              startDetectDrag = true
          }
      }
    }
    
    func pauseGame(){
        model.pauseGame()
    }

    func resumeGame(){
        model.resumeGame()
    }

    func startGame(){
        model.gameStart()
    }

    var score: Int{
        model.score
    }

    var bestScore: Int{
        model.bestScore
    }

    var combo: Int{
        model.combo
    }
    
    var isPaused: Bool {
        model.isPaused
    }

    var isPlaying: Bool {
        model.isPlaying
    }

    var availableMoves: Int{
        model.availableMoves
    }

    var columnCount: Int{
        model.columnCount
    }

    var grid: [Content] {
        model.grid
    }
}
