import SwiftUI

enum Direction { case left, right, up, down}

class GameViewModel: ObservableObject {
    @Published private var model: GameModel
    private var detectDrag = false
	private var moveCount = 0

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
        if detectDrag {
            var direction: Direction?
            if translation.width > 5 { // swipe right
                direction = Direction.right
            }
            else if translation.width < -5 { // swipe left
                direction = Direction.left
            }
            else if translation.height < -5 { // swipe up
                direction = Direction.up
            }
            else if translation.height > 5 { // swipe down
                direction = Direction.down
			}

            if let target = direction{
                detectDrag = false
                
                var targetIndex = -1
                withAnimation(.easeInOut(duration: 0.5)){
                    targetIndex = model.move(index, target)
                }
                
                if targetIndex > -1 {
                    executeAfter(delay: 0.5){
                        withAnimation(.linear(duration: 1)){
                            self.model.process()
                        }
                        
                        self.executeAfter(delay: 1){
                            withAnimation(.easeInOut(duration: 0.5)){
                                self.model.finishMove(index, targetIndex)
                            }
                        }
                    }
                }
            }
        } else if translation == .zero{
            detectDrag = true
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
    
    func executeAfter(delay: CGFloat, _ execute: @escaping () -> Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            execute()
        }
    }
}
