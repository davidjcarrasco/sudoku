/*
   Name   
    djcv-sudoku

   Description

   This program implements the Backtracking algorithm. 
   The backtracking algorithm, is a type of brute force search.

   A brute force algorithm visits the empty cells in some order, filling in digits sequentially, or backtracking when the number is found to be not valid. Briefly, a program would solve a puzzle by placing the digit "1" in the first cell and checking if it is allowed to be there. If there are no violations (checking row, column, and box constraints) then the algorithm advances to the next cell, and places a "1" in that cell. When checking for violations, if it is discovered that the "1" is not allowed, the value is advanced to "2". If a cell is discovered where none of the 9 digits is allowed, then the algorithm leaves that cell blank and moves back to the previous cell. The value in that cell is then incremented by one. This is repeated until the allowed value in the last (81st) cell is discovered.

   The explantion of the algorithm can be found in the link:

   https://en.wikipedia.org/wiki/Sudoku_solving_algorithms
   
   Synopsis

   djcv-sudoku <filename>

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
   14/03/2019   David C.        First Version

*/

// Libraries 


#include <iostream>
#include <cctype>

using namespace std;

//Definitions
#define NumberMaxCells 9
#define NumberCellsInBox 3
#define EmptyCell 0

//Global variables
int sudokuGrid[NumberMaxCells][NumberMaxCells] = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
};

// Function to verify if the guess number already exist in the column or not
bool isGuessNumberPresentInColumn(int column, int guessNumber)
{
    for (int row = 0; row < NumberMaxCells; row++)
        if (sudokuGrid[row][column] == guessNumber)
            return true;
    return false;
}

// Function to verify if the guess number already exist in the row or not
bool isGuessNumberPresentInRow(int row, int guessNumber)
{
    for (int column = 0; column < NumberMaxCells; column++)
        if (sudokuGrid[row][column] == guessNumber)
            return true;
    return false;
}

//Function to verify if the number is already in a box [3,3]
bool isGuessNumberPresentInBox(int boxStartRow, int boxStartColumn, int guessNumber)
{ //check whether number is present in 3x3 box or not
    for (int row = 0; row < NumberCellsInBox; row++)
        for (int column = 0; column < NumberCellsInBox; column++)
            if (sudokuGrid[row + boxStartRow][column + boxStartColumn] == guessNumber)
                return true;
    return false;
}

// Function to print the sudoku grid after solve it
void printSudokuGrid()
{

    for (int row = 0; row < NumberMaxCells; row++)
    {
        for (int column = 0; column < NumberMaxCells; column++)
        {
            if (column == 3 || column == 6)
                cout << " | ";
            cout << sudokuGrid[row][column] << " ";
        }

        if (row == 2 || row == 5)
        {
            cout << endl;
            for (int i = 0; i < NumberMaxCells; i++)
                cout << "---";
        }
        cout << endl;
    }
    cout << endl << endl;
}

// Function to get empty cell and update row and column
// THe EmptyCell is defined as 0 value
bool findEmptyCell(int *row, int *column)
{
    for (*row = 0; *row < NumberMaxCells; (*row)++)
        for (*column = 0; *column < NumberMaxCells; (*column)++)
            if (sudokuGrid[*row][*column] == EmptyCell) //marked with 0 is empty
                return true;
    return false;
}

// Function that check it the guess number is valid in the cell.
// This is when the guess number is not found in col, row and the current 3x3 box
bool isGuessNumberValidInCell(int row, int column, int guessNumber)
{
    return !isGuessNumberPresentInRow(row, guessNumber) &&
           !isGuessNumberPresentInColumn(column, guessNumber) &&
           !isGuessNumberPresentInBox(row - row % NumberCellsInBox, column - column % NumberCellsInBox, guessNumber);
}

// Function to solve the Sudoku using the Backtracking algorithm.
bool solveSudoku()
{
    int row, column;

    if (!findEmptyCell( &row, &column))
        return true; //when all places are filled

    for (int guessNumber = 1; guessNumber <= NumberMaxCells; guessNumber++)
    { //valid numbers are 1 - NumberMaxCells
        if (isGuessNumberValidInCell(row, column, guessNumber))
        { //check validation, if yes, put the number in the grid
            sudokuGrid[row][column] = guessNumber;
            if (solveSudoku()) //recursively go for other rooms in the grid
                return true;
            sudokuGrid[row][column] = 0; //turn to unassigned space when conditions are not satisfied
        }
    }
    return false;
}


// Function to read the file with the initial sudoku grid
bool readFileToSudokuGrid(char *fileNameSudoku )
{

    FILE *fr = fopen(fileNameSudoku, "r");

    // Read the file
    int row = 0;
    char character ;
  
    for (int row = 0; row < NumberMaxCells; row++) {
        for (int column = 0; column < NumberMaxCells; column++) {
            try {
                fscanf(fr, "%c ", &character ) ;
                if ( isdigit (character) )  
                    sudokuGrid[row][column] = (int) character - 48;
            }
            catch(const std::exception& e) {
                std::cerr << e.what() << '\n';
            }
        }  
        fscanf(fr, "\n");
    }

    fclose(fr);
    return true ;
}


// Main Function
int main(int argc, char **argv)
{
    // Verify the argument quantity
    if (argc != 2) {
        printf ( "\ndjcv-sudoku <filename>\n" ) ;
        return (-1);
    }

    //Read the file with the initial sudoku grid
    if (!readFileToSudokuGrid(argv[1]))
        return (-1);

    printf ( "\n\nInitial Sudoku\n") ;

    printSudokuGrid();

    if (solveSudoku() ) {
            // If a solution was founded, the final sudoku grid is printed
            printf("\n\nFinal Sudoku\n");
            printSudokuGrid();
    } else
        cout << "No solution exists" << endl << endl;
}