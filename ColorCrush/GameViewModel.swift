import SwiftUI

class GameViewModel: ObservableObject {
    @Published private var model: GameModel
    private var detectDrag = false

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
        if detectDrag && !model.isMoving && model.isPlaying && !model.isPaused {
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
                detectDrag = false
                let targetIndex = to
                Task{
                    await animate(duration: 0.5){
                        self.model.move(index, targetIndex)
                    }
                    await animate(duration: 1){
                        self.model.process()
                    }
                    await animate(duration: 0.5){
                        self.model.finishMove(index, targetIndex)
                    }
                }
            }
      } else {
          if translation == .zero {
              detectDrag = true
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
    
    func animate(duration: CGFloat, _ execute: @escaping () -> Void) async{
        await withCheckedContinuation{ continuation in
            withAnimation(.easeInOut(duration: duration)){
                execute()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                continuation.resume()
            }
        }
    }
}
