import Foundation
import SwiftUI


struct GameModel {
    @AppStorage("bestScore") private(set) var bestScore = 0
    private(set) var score: Int = 0
    private(set) var combo: Int = 0
    
    private(set) var grid: [Content]
    private let maxMoves: Int
    private(set) var availableMoves: Int = 0
    private(set) var wasMatch = false
    private(set) var isMoving = false
    private(set) var isPlaying = false
    private(set) var isPaused = false
    private(set) var columnCount = 7
    private(set) var rowCount = 9
    private var contentFactory: () -> ContentType

    init(columnCount: Int, rowCount: Int, maxMoves: Int, contentFactory: @escaping () -> ContentType) {
        self.contentFactory = contentFactory
        self.columnCount = columnCount
        self.rowCount = rowCount

        grid = Array(repeating: Content(contentType: .blank), count: columnCount * rowCount)
        
        self.maxMoves = maxMoves
    }

    mutating func gameStart() {
        self.score = 0
        self.combo = 0
        self.availableMoves = self.maxMoves
        generateGrid()
        isPlaying = true
        isPaused = false
        isMoving = false
    }

    mutating func pauseGame() {
        isPaused = true
    }

    mutating func resumeGame(){
        isPaused = false
    }

    mutating func generateGrid(){
        (0..<grid.count).forEach { index in
            grid[index].contentType = contentFactory()
            if [2...(columnCount - 1), (columnCount + 2)...(columnCount * 2 - 1)].joined().contains(index) {
                while([grid[index-2], grid[index-1]].allSatisfy({ $0.contentType == grid[index].contentType })) {
                    grid[index].contentType = contentFactory()
                }
            } else if [stride(from: (columnCount * 2), to: grid.count-columnCount, by: columnCount), stride(from: (columnCount * 2) + 1, to: grid.count - columnCount + 1, by: columnCount)].joined().contains(index) {
                while([grid[index-(columnCount * 2)], grid[index-columnCount]].allSatisfy({ $0.contentType == grid[index].contentType })) {
                    grid[index].contentType = contentFactory()
                }
            } else if ![0, 1, columnCount, columnCount + 1].contains(index) {
                while(
                    [grid[index-2], grid[index-1]].allSatisfy({ $0.contentType == grid[index].contentType })
                    ||
                    [grid[index-(columnCount * 2)], grid[index-columnCount]].allSatisfy({ $0.contentType == grid[index].contentType })
                ) {
                    grid[index].contentType = contentFactory()
                }
            }
        }
    }
    
    // return target index or -1 if target is invalid
    mutating func move(_ from: Int, _ direction: Direction) -> Int{
        if isMoving || !isPlaying || isPaused {
            return -1
        }
            
        let targetIndex = getTargetIndex(from, direction)
        
        if targetIndex > -1 {
            isMoving = true
            availableMoves -= 1
            grid.swapAt(from, targetIndex)
        }
            
        return targetIndex
    }
    
    private func getTargetIndex(_ from: Int, _ direction: Direction) -> Int {
        if direction == Direction.right && !((from + 1) % columnCount == 0) { // is not the right edge
            return from + 1
        }
        else if direction == Direction.left && !(from % columnCount == 0) { // is not the left edge
            return from - 1
        }
        else if direction == Direction.up && from >= columnCount { // is not the top edge
            return from - columnCount
        }
        else if direction == Direction.down && from < grid.count - columnCount { // is not the bottom edge
            return from + columnCount
        }
        
        return -1
    }
    
    mutating func process(){
        wasMatch = false
        checkMatch()
    }
    
    mutating func finishMove(_ from: Int, _ to: Int){
        if !wasMatch{
            grid.swapAt(from, to)
        }
        combo = 0
        checkGameOver()
        isMoving = false
    }

    private mutating func checkGameOver(){
        if(availableMoves < 1){
            if self.score > self.bestScore {
                self.bestScore = self.score
            }
            self.isPlaying = false
            (0..<grid.count).forEach { index in
                grid[index].contentType = .blank
            }
        }
    }
    
    private mutating func checkMatch() {
        var checkList = Array(repeating: false, count: grid.count)
        var points = 0
        var combos = 0
        var isMatch = false
        //check row
        for row in 0..<rowCount {
            var count = 1
            var currentGridType = grid[0 + row * columnCount].contentType
            for col in 1..<columnCount{
                if(grid[col + row * columnCount].contentType != currentGridType){
                    if(count > 2){
                        (col + row * columnCount - count..<col + row * columnCount).forEach { checkList[$0] = true }
                        isMatch = true
                        combos += 1
                        points += count
                    }
                    currentGridType = grid[col + row * columnCount].contentType
                    count = 1
                }else{
                    count += 1
                }
            }
            if(count > 2){
                (columnCount + row * columnCount - count..<columnCount + row * columnCount).forEach { checkList[$0] = true }
                isMatch = true
                points += count
                combos += 1
            }
        }
        //check column
        for col in 0..<columnCount {
            var count = 1
            var currentGridType = grid[col].contentType
            for row in 1..<rowCount {
                if(grid[col + row * columnCount].contentType != currentGridType){
                    if(count > 2){
                        stride(from: col + (row - count) * columnCount, through: col + (row - 1) * columnCount, by: columnCount).forEach {checkList[$0] = true }
                        isMatch = true
                        combos += 1
                        points += count
                    }
                    currentGridType = grid[col + row * columnCount].contentType
                    count = 1
                }else{
                    count += 1
                }
            }
            if(count > 2){
                stride(from: col + (rowCount - count) * columnCount, through: col + (rowCount - 1) * columnCount, by: columnCount).forEach { checkList[$0] = true }
                isMatch = true
                points += count
                combos += 1
            }
        }
        
        
        for index in 0..<grid.count{
            if checkList[index] == true {
                grid[index].contentType = .blank
            }
        }
        score += points
        combo += combos
        if isMatch {
            wasMatch = true
            fallDown()
        } else {
            if canNotMove() {
                grid.shuffle()
                fallDown()
            }
        }
    }

    private mutating func fallDown() {
        var keepChecking = true
		while keepChecking {
			keepChecking = false
			for index in 0..<grid.count{
				if grid[index].contentType == .blank {
					keepChecking = true
					if (0..<columnCount).contains(index) {
						grid[index].contentType = contentFactory()
					} else {
						grid.swapAt(index, index-columnCount)
					}
				}
			}
		}
        checkMatch()
    }

    private func canNotMove() -> Bool {
        var gridCopy = grid
        //test for row move
        for index in 0..<grid.count {
            if !stride(from: columnCount - 1, through: grid.count - 1, by: columnCount).contains(index) {
                gridCopy.swapAt(index, index+1)
                //check row
                for row in 0..<rowCount {
                    var count = 1
                    var currentGridType = gridCopy[0 + row * columnCount].contentType
                    for col in 1..<columnCount{
                        if(gridCopy[col + row * columnCount].contentType != currentGridType){
                            if(count > 2){
                                return false
                            }
                            currentGridType = gridCopy[col + row * columnCount].contentType
                            count = 1
                        }else{
                            count += 1
                        }
                    }
                }
                //check column
                for col in 0..<columnCount {
                    var count = 1
                    var currentGridType = gridCopy[col].contentType
                    for row in 1..<rowCount {
                        if(gridCopy[col + row * columnCount].contentType != currentGridType){
                            if(count > 2){
                                return false
                            }
                            currentGridType = gridCopy[col + row * columnCount].contentType
                            count = 1
                        }else{
                            count += 1
                        }
                    }
                }
                gridCopy.swapAt(index, index+1)
            }
        }
        
        //test for column move
        for index in 0..<grid.count {
            if !(grid.count-columnCount..<grid.count).contains(index) {
                gridCopy.swapAt(index, index+columnCount)
                //check row
                for row in 0..<rowCount {
                    var count = 1
                    var currentGridType = gridCopy[0 + row * columnCount].contentType
                    for col in 1..<columnCount{
                        if(gridCopy[col + row * columnCount].contentType != currentGridType){
                            if(count > 2){
                                return false
                            }
                            currentGridType = gridCopy[col + row * columnCount].contentType
                            count = 1
                        }else{
                            count += 1
                        }
                    }
                }
                //check column
                for col in 0..<columnCount {
                    var count = 1
                    var currentGridType = gridCopy[col].contentType
                    for row in 1..<rowCount {
                        if(gridCopy[col + row * columnCount].contentType != currentGridType){
                            if(count > 2){
                                return false
                            }
                            currentGridType = gridCopy[col + row * columnCount].contentType
                            count = 1
                        }else{
                            count += 1
                        }
                    }
                }
                gridCopy.swapAt(index, index+columnCount)
            }
        }
        return true
    }
    
}
