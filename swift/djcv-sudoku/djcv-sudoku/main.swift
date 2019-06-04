/*
 Package djcv-sudoku
 
 Description
 
 This program implements the Backtracking algorithm.
 The backtracking algorithm, is a type of brute force search.
 
 A brute force algorithm visits the empty cells in some order, filling in digits sequentially, or backtracking when the number is found to be not valid. Briefly, a program would solve a puzzle by placing the digit "1" in the first cell and checking if it is allowed to be there. If there are no violations (checking row, column, and box constraints) then the algorithm advances to the next cell, and places a "1" in that cell. When checking for violations, if it is discovered that the "1" is not allowed, the value is advanced to "2". If a cell is discovered where none of the 9 digits is allowed, then the algorithm leaves that cell blank and moves back to the previous cell. The value in that cell is then incremented by one. This is repeated until the allowed value in the last (81st) cell is discovered.
 
 The explantion of the algorithm can be found in the link:
 
 https://en.wikipedia.org/wiki/Sudoku_solving_algorithms
 
 Synopsis
 
 sudokugo <filename>
 
 Filename: file with the original sudoku to be solved
 
 Structure of the file:
 
 Nine lines where each line contains nune numbers form 0 to nine where 0 represent
 an empty cell.
 
 Example of the file:
 
 0 0 0 0 2 0 3 0 5
 0 7 8 1 0 0 0 0 0
 0 9 0 0 0 0 0 0 0
 0 3 0 0 0 7 0 0 4
 0 0 0 0 9 0 0 0 0
 1 0 0 6 0 0 0 2 0
 0 0 0 0 0 0 0 4 0
 0 0 0 0 0 5 7 9 0
 6 0 2 0 1 0 0 0 0
 
 Return Value:
 
 None
 
 History
 
 Data         Programmer      Commentaries
 23/04/2019   David C.        First Version
 
 */

import Foundation

//Costants

let numberMaxCells: Int = 9
let numberCellsInBox: Int = 3
let emptyCell: Int = 0

//Global variables

var sudokuGrid = [[Int]](repeating: [Int](repeating: 0, count: numberMaxCells), count: numberMaxCells)

// Function to verify if the guess number already exist in the column or not
func isGuessNumberPresentInColumn( column: Int, guessNumber: Int) -> Bool {
    for row in 0..<numberMaxCells {
        if sudokuGrid[row][column] == guessNumber {
            return true
        }
    }
    return false
}

// Function to verify if the guess number already exist in the row or not
func isGuessNumberPresentInRow( row: Int, guessNumber: Int)  -> Bool {
    for column in 0..<numberMaxCells  {
        if sudokuGrid[row][column] == guessNumber {
            return true
        }
    }
    return false
}

//Function to verify if the number is already in a box [3,3]
func isGuessNumberPresentInBox( boxStartRow: Int, boxStartColumn: Int, guessNumber: Int)  -> Bool {
    //check whether number is present in 3x3 box or not
    for row in 0..<numberCellsInBox {
        for column in 0..<numberCellsInBox {
            if sudokuGrid[row+boxStartRow][column+boxStartColumn] == guessNumber {
                return true
            }
        }
    }
    return false
}

// Function to print the sudoku grid after solve it
func printSudokuGrid() {
    
    for row in 0..<numberMaxCells {
        for column in 0..<numberMaxCells {
            if column == 3 || column == 6 {
                print (" | ", terminator: "")
            }
            print( "\(sudokuGrid[row][column]) ", terminator: "" )
        }
        
        if row == 2 || row == 5 {
            print()
            for _ in 0..<numberMaxCells {
               print("---", terminator: "")
            }
        }
        print()
    }
    print()
}

// Function to get empty cell and update row and column
// THe emptyCell is defined as 0 value
func findEmptyCell( row: inout Int, column: inout Int)  -> Bool {
    for rowWork in 0..<numberMaxCells {
        for columnWork in 0..<numberMaxCells {
            if sudokuGrid[rowWork][columnWork] == emptyCell { //marked with 0 is empty
                row = rowWork
                column = columnWork
                return true
            }
        }
    }
    return false
}

// Function that check it the guess number is valid in the cell.
// This is when the guess number is not found in col, row and the current 3x3 box
func isGuessNumberValidInCell( row: Int, column: Int, guessNumber: Int)  -> Bool {
    return !isGuessNumberPresentInRow( row: row, guessNumber: guessNumber) &&
        !isGuessNumberPresentInColumn( column: column, guessNumber: guessNumber) &&
        !isGuessNumberPresentInBox( boxStartRow: row-row%numberCellsInBox, boxStartColumn: column-column%numberCellsInBox, guessNumber: guessNumber)
}

// Function to solve the Sudoku using the Backtracking algorithm.
func solveSudoku()  -> Bool {
    var row: Int = 0
    var column: Int = 0
    
    if !findEmptyCell(row: &row, column: &column) {
        return true //when all places are filled
    }
    
    for guessNumber in 1..<numberMaxCells+1 {
        //valid numbers are 1 - numberMaxCells
        if isGuessNumberValidInCell(row: row, column: column, guessNumber: guessNumber) {
            //check validation, if yes, put the number in the grid
            sudokuGrid[row][column] = guessNumber
            //Debug
            //fmt.Println("solveSudoku")
            //fmt.Printf("Guess Number (%v)\n", guessNumber)
            //Debug
            
            if solveSudoku() { //recursively go for other rooms in the grid
                return true
            }
            sudokuGrid[row][column] = 0 //turn to unassigned space when conditions are not satisfied
        }
    }
    return false
}

// Function to read the file with the initial sudoku grid
func readFileToSudokuGrid( fileNameSudoku: String)  -> Bool {
    
    //
    do {
        // Read an entire text file into an NSString.
        let contents = try NSString(contentsOfFile: fileNameSudoku,
                                    encoding: String.Encoding.ascii.rawValue)
        
        // Print all lines.
       // contents.enumerateLines({ (line, stop) -> () in
       //     print("Line = \(line)")
       // })
        var row: Int = 0
        for line in (contents.components(separatedBy: "\n")){
            if line != "" {
                let sep = " " // separator is here
                let numbers = line.components(separatedBy: sep)
                sudokuGrid[row][0] = Int(numbers[0])!
                sudokuGrid[row][1] = Int(numbers[1])!
                sudokuGrid[row][2] = Int(numbers[2])!
                sudokuGrid[row][3] = Int(numbers[3])!
                sudokuGrid[row][4] = Int(numbers[4])!
                sudokuGrid[row][5] = Int(numbers[5])!
                sudokuGrid[row][6] = Int(numbers[6])!
                sudokuGrid[row][7] = Int(numbers[7])!
                sudokuGrid[row][8] = Int(numbers[8])!
            }
            row = row + 1
        }

    } catch let error as NSError {
        print("Ooops! Something went wrong: \(error)")
    }
    
    return true
}

// Main
    
    // Verify the argument quantity
    if CommandLine.arguments.count != 2 {
        print("\ndjcv-sudoku <filename>\n\n")
        exit (0)
    }
        //Read the file with the initial sudoku grid
    if !readFileToSudokuGrid( fileNameSudoku: CommandLine.arguments[1]) {
        print("\nProblems with the input file\n")
    }
    
    print("\n\nInitial Sudoku\n")
    
    printSudokuGrid()
    
    if solveSudoku()  {
        // If a solution was founded, the final sudoku grid is printed
        print("\n\nFinal Sudoku\n")
        printSudokuGrid()
    } else {
        print("No solution exists")
    }



