import Vapor




func routes(_ app: Application) throws {
    
  
    //let numberMaxCells: Int = 9
    struct SudokuJSON: Content {
        var grid = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
    }
    
    
    struct Response: Content {
        var sucess = false
        var message: String?
        var data = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
    }
  
    app.get { req in
        return "It works!"
    }

    app.post ("resolveSudoku") { req -> Response in

        var dataSudoku = try req.content.decode(SudokuJSON.self)
        
        var solutionSudoku = Response()
        
        do {
            
            dataSudoku.grid = try doSudoku ( sudokuGridData : dataSudoku.grid)
            
            solutionSudoku.sucess = true
            solutionSudoku.message = "Ok"
            solutionSudoku.data = dataSudoku.grid
        } catch {
            solutionSudoku.sucess = false
            solutionSudoku.message = "Wrong data in the sudoku"
            solutionSudoku.data =  [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
        }

        return solutionSudoku
    }
}
