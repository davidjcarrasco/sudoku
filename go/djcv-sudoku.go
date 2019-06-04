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
   14/03/2019   David C.        First Version

*/
package main

// Libraries
import (
	"fmt"
	"io"
	"log"
	"os"
)

//Costants

const numberMaxCells int = 9
const numberCellsInBox int = 3
const emptyCell int = 0

//Global variables

var sudokuGrid [numberMaxCells][numberMaxCells]int

// Function to verify if the guess number already exist in the column or not
func isGuessNumberPresentInColumn(column int, guessNumber int) bool {
	for row := 0; row < numberMaxCells; row++ {
		if sudokuGrid[row][column] == guessNumber {
			return true
		}
	}
	return false
}

// Function to verify if the guess number already exist in the row or not
func isGuessNumberPresentInRow(row int, guessNumber int) bool {
	for column := 0; column < numberMaxCells; column++ {
		if sudokuGrid[row][column] == guessNumber {
			return true
		}
	}
	return false
}

//Function to verify if the number is already in a box [3,3]
func isGuessNumberPresentInBox(boxStartRow int, boxStartColumn int, guessNumber int) bool {
	//check whether number is present in 3x3 box or not
	for row := 0; row < numberCellsInBox; row++ {
		for column := 0; column < numberCellsInBox; column++ {
			if sudokuGrid[row+boxStartRow][column+boxStartColumn] == guessNumber {
				return true
			}
		}
	}
	return false
}

// Function to print the sudoku grid after solve it
func printSudokuGrid() {

	for row := 0; row < numberMaxCells; row++ {
		for column := 0; column < numberMaxCells; column++ {
			if column == 3 || column == 6 {
				fmt.Print(" | ")
			}
			fmt.Print(sudokuGrid[row][column], " ")
		}

		if row == 2 || row == 5 {
			fmt.Println()
			for i := 0; i < numberMaxCells; i++ {
				fmt.Print("---")
			}
		}
		fmt.Println()
	}
	fmt.Println()
}

// Function to get empty cell and update row and column
// THe emptyCell is defined as 0 value
func findEmptyCell(row *int, column *int) bool {
	for *row = 0; *row < numberMaxCells; (*row)++ {
		for *column = 0; *column < numberMaxCells; (*column)++ {
			if sudokuGrid[*row][*column] == emptyCell { //marked with 0 is empty
				//Debug
				//fmt.Println("findEmptyCell")
				//fmt.Printf("row (%v) Column (%v)\n", *row, *column)
				//Debug
				return true
			}
		}
	}
	return false
}

// Function that check it the guess number is valid in the cell.
// This is when the guess number is not found in col, row and the current 3x3 box
func isGuessNumberValidInCell(row int, column int, guessNumber int) bool {
	return !isGuessNumberPresentInRow(row, guessNumber) &&
		!isGuessNumberPresentInColumn(column, guessNumber) &&
		!isGuessNumberPresentInBox(row-row%numberCellsInBox, column-column%numberCellsInBox, guessNumber)
}

// Function to solve the Sudoku using the Backtracking algorithm.
func solveSudoku() bool {
	var row, column int

	if !findEmptyCell(&row, &column) {
		return true //when all places are filled
	}

	for guessNumber := 1; guessNumber <= numberMaxCells; guessNumber++ {
		//valid numbers are 1 - numberMaxCells
		if isGuessNumberValidInCell(row, column, guessNumber) {
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
func readFileToSudokuGrid(fileNameSudoku string) bool {

	file, err := os.Open(fileNameSudoku) // For read access.
	if err != nil {
		log.Fatal(err)
	}

	// Read the file
	for row := 0; row < numberMaxCells; row++ {

		_, err := fmt.Fscanf(file, "%d %d %d %d %d %d %d %d %d\n", &sudokuGrid[row][0],
			&sudokuGrid[row][1], &sudokuGrid[row][2], &sudokuGrid[row][3],
			&sudokuGrid[row][4], &sudokuGrid[row][5], &sudokuGrid[row][6],
			&sudokuGrid[row][7], &sudokuGrid[row][8])

		if err != nil {
			if err == io.EOF {
				break // stop reading the file
			}
			fmt.Println(err)
			os.Exit(1)
		}

	}

	file.Close()
	return true
}

// Main Function
func main() {

	// Verify the argument quantity
	if len(os.Args) != 2 {
		fmt.Printf("\ndjcv-sudoku <filename>\n\n")
		os.Exit(1)
	}

	//Read the file with the initial sudoku grid
	if !readFileToSudokuGrid(os.Args[1]) {
		fmt.Printf("\nProblems with the input file\n")
	}

	fmt.Printf("\n\nInitial Sudoku\n")

	printSudokuGrid()

	if solveSudoku() {
		// If a solution was founded, the final sudoku grid is printed
		fmt.Printf("\n\nFinal Sudoku\n")
		printSudokuGrid()
	} else {
		fmt.Println("No solution exists")
	}
}
