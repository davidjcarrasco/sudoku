#
#    Name   
#     djcv-sudoku
#
#    Description
#    This program implements the Backtracking algorithm. 
#    The backtracking algorithm, is a type of brute force search.
#
#    A brute force algorithm visits the empty cells in some order, filling in digits sequentially, or
#    backtracking when the number is found to be not valid. Briefly, a program would solve a puzzle by 
#    placing the digit "1" in the first cell and checking if it is allowed to be there. If there are no 
#    violations (checking row, column, and box constraints) then the algorithm advances to the next cell, 
#    and places a "1" in that cell. When checking for violations, if it is discovered that the "1" is not
#    allowed, the value is advanced to "2". If a cell is discovered where none of the 9 digits is allowed, 
#    then the algorithm leaves that cell blank and moves back to the previous cell. The value in that cell 
#    is then incremented by one. This is repeated until the allowed value in the last (81st) cell is 
#    discovered.
#
#    The explantion of the algorithm can be found in the link:
#
#    https://en.wikipedia.org/wiki/Sudoku_solving_algorithms
#   
#    Synopsis
#
#    djcv-sudoku <filename>
#
#    Filename: file with the original sudoku to be solved
#
#    Structure of the file:
#
#    Nine lines where each line contains nune numbers form 0 to nine where 0 represent 
#    an empty cell.
#
#    Example of the file:
#
#     0 0 0 0 2 0 3 0 5
#     0 7 8 1 0 0 0 0 0
#     0 9 0 0 0 0 0 0 0
#     0 3 0 0 0 7 0 0 4
#     0 0 0 0 9 0 0 0 0
#     1 0 0 6 0 0 0 2 0
#     0 0 0 0 0 0 0 4 0
#     0 0 0 0 0 5 7 9 0
#     6 0 2 0 1 0 0 0 0
#
#    Return Value:
#
#          None
#
#    History
#
#    Data         Programmer      Commentaries
#    27/05/2019   David C.        First Version
#
# 

# Libraries 
import sys

#Definitions
NUMBER_MAX_CELLS = 9
NUMBER_CELLS_IN_BOX = 3
EMPTY_CELL  = 0

# Global variables
sudokuGrid = [
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    ]

# Function to verify if the guess number already exist in the column or not
def isGuessNumberPresentInColumn(column, guessNumber):
    for row in range(0, NUMBER_MAX_CELLS):
        if (sudokuGrid[row][column] == guessNumber):
            return True
    return False


# Function to verify if the guess number already exist in the row or not
def isGuessNumberPresentInRow(row, guessNumber):
    for column in range(0, NUMBER_MAX_CELLS):
        if (sudokuGrid[row][column] == guessNumber):
            return True
    return False

# Function to verify if the number is already in a box [3,3]
def isGuessNumberPresentInBox(boxStartRow, boxStartColumn, guessNumber):
   #check whether number is present in 3x3 box or not
   for row in range(0, NUMBER_CELLS_IN_BOX):
        for column in range(0, NUMBER_CELLS_IN_BOX):
            if (sudokuGrid[row + boxStartRow][column + boxStartColumn] == guessNumber):
                return True
   return False


# Function that check it the guess number is valid in the cell.
# This is when the guess number is not found in col, row and the current 3x3 box
def isGuessNumberValidInCell(row, column, guessNumber):
    isPresentInRow = isGuessNumberPresentInRow(row, guessNumber)
    isPresentInColumn = isGuessNumberPresentInColumn(column, guessNumber)
    isPresentInBox = isGuessNumberPresentInBox(row - row % NUMBER_CELLS_IN_BOX, column - column % NUMBER_CELLS_IN_BOX, guessNumber)
    return not isPresentInRow and not isPresentInColumn and not isPresentInBox

# Function to print the sudoku grid after solve it
def printSudokuGrid():

    for row in range(0, NUMBER_MAX_CELLS):
        for column in range(0, NUMBER_MAX_CELLS):
            if (column == 3 or column == 6):
                print ("| ", end ="")
            print( sudokuGrid[row][column], end = " ")
        if (row == 2 or row == 5):
           print ("")
           for  i in range(2, NUMBER_MAX_CELLS):
                print("---", end="")
        print ("")
    print("\n")



# Function to get empty cell and update row and column
# THe EmptyCell is defined as 0 value
def findEmptyCell( position ):
    row = position[0]
    column = position[1]
    for row in range(0, NUMBER_MAX_CELLS):
        for column in range(0, NUMBER_MAX_CELLS):
        # marked with 0 is empty
            if (sudokuGrid[row][column] == EMPTY_CELL): 
                position[0] = row
                position[1] = column
                return True
    position[0] = row
    position[1] = column
    return False

# Function to solve the Sudoku using the Backtracking algorithm.
def solveSudoku():
    global sudokuGrid
    row = 0
    column = 0

    position =[row,column]

    if (not findEmptyCell(position)):
        # when all places are filled
        return True 

    row = position[0]
    column = position[1]
    for guessNumber in range(1, NUMBER_MAX_CELLS+1):
        #valid numbers are 1 - NumberMaxCells
        if (isGuessNumberValidInCell(row, column, guessNumber)):
            #check validation, if yes, put the number in the grid
            sudokuGrid[row][column] = guessNumber;
            # recursively go for other rooms in the grid
            if (solveSudoku()): 
                return True
            # turn to unassigned space when conditions are not satisfied
            sudokuGrid[row][column] = 0; 
    return False



# Function to read the file with the initial sudoku grid
def readFileToSudokuGrid( fileNameSudoku ):
    global sudokuGrid

    file = open(fileNameSudoku, "r")

    # Read the file
    row = 0
    character = ' '
    
    fl = file.readlines()  # readlines reads the individual lines into a list

    for line in fl:
        rowValues = line.split(" ", NUMBER_MAX_CELLS)

        for column in range(0, NUMBER_MAX_CELLS): 
            sudokuGrid[row][column] = int(rowValues[column])
        row += 1
    file.close()
    return True 


# Main Function
def main():

    # Verify the argument quantity
    if (len(sys.argv) != 2):
        print ( "\ndjcv-sudoku <filename>\n" ) 
        return (-1)


    #Read the file with the initial sudoku grid
    if (not readFileToSudokuGrid(sys.argv[1])):
        return (-1)

    print ( "\n\nInitial Sudoku\n") 

    printSudokuGrid()

    if solveSudoku() :
        # If a solution was founded, the final sudoku grid is printed
        print("\n\nFinal Sudoku\n")
        printSudokuGrid()
    else:
        print ( "No solution exists\n\n")
if __name__ == "__main__":
    main()
