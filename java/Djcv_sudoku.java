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
   27/04/2019   David C.        First Version

 */
package djcv_sudoku;

import java.io.BufferedReader;
import java.io.FileReader;

public class Djcv_sudoku {

    // Constants
    public static final int NUMBER_MAX_CELLS = 9;
    public static final int NUMBER_CELLS_IN_BOX = 3;
    public static final int EMPTY_CELL = 0;

    //Variaveis Globais
    private final int sudokuGrid[][] = new int[NUMBER_MAX_CELLS][NUMBER_MAX_CELLS];

    // Function to verify if the guess number already exist in the column or not
    private Boolean isGuessNumberPresentInColumn(int column, int guessNumber) {
        for (int row = 0; row < NUMBER_MAX_CELLS; row++) {
            if (sudokuGrid[row][column] == guessNumber) {
                return true;
            }
        }
        return false;
    }

    // Function to verify if the guess number already exist in the row or not
    private Boolean isGuessNumberPresentInRow(int row, int guessNumber) {
        for (int column = 0; column < NUMBER_MAX_CELLS; column++) {

            if (sudokuGrid[row][column] == guessNumber) {
                return true;
            }
        }
        return false;
    }

    //Function to verify if the number is already in a box [3,3]
    private Boolean isGuessNumberPresentInBox(int boxStartRow, int boxStartColumn, int guessNumber) {
        //check whether number is present in 3x3 box or not
        for (int row = 0; row < NUMBER_CELLS_IN_BOX; row++) {
            for (int column = 0; column < NUMBER_CELLS_IN_BOX; column++) {
                if (sudokuGrid[row + boxStartRow][column + boxStartColumn] == guessNumber) {
                    return true;
                }
            }
        }
        return false;
    }

    // Function to print the sudoku grid after solve it
    private void printSudokuGrid() {

        for (int row = 0; row < NUMBER_MAX_CELLS; row++) {
            for (int column = 0; column < NUMBER_MAX_CELLS; column++) {
                if (column == 3 || column == 6) {
                    System.out.print(" | ");
                }
                System.out.print(sudokuGrid[row][column] + " ");
            }

            if (row == 2 || row == 5) {
                System.out.println("");
                for (int i = 0; i < NUMBER_MAX_CELLS; i++) {
                    System.out.print("---");
                }
            }
            System.out.println("");
        }
        System.out.println("");
    }

    // Function that check it the guess number is valid in the cell.
// This is when the guess number is not found in col, row and the current 3x3 box
    private Boolean isGuessNumberValidInCell(int row, int column, int guessNumber) {

        return !isGuessNumberPresentInRow(row, guessNumber)
                && !isGuessNumberPresentInColumn(column, guessNumber)
                && !isGuessNumberPresentInBox(row - row % NUMBER_CELLS_IN_BOX, column - column % NUMBER_CELLS_IN_BOX, guessNumber);
    }

// Function to get empty cell and update row and column
// THe emptyCell is defined as 0 value
    private Boolean findEmptyCell(int[] coordinates) {

        for (int row = coordinates[0]; row < NUMBER_MAX_CELLS; row++) {
            for (int column = coordinates[1]; column < NUMBER_MAX_CELLS; column++) {
                if (sudokuGrid[row][column] == EMPTY_CELL) { //marked with 0 is empty
                    coordinates[0] = row;
                    coordinates[1] = column;
                    return true;
                }
            }
        }
        return false;
    }

// Function to solve the Sudoku using the Backtracking algorithm.
    private Boolean solveSudoku() {
        //row, column
        int[] coordinates = {0, 0};

        if (!findEmptyCell(coordinates)) { //Use array due to the fact that java pass the arguments as VALUE
            return true; //when all places are filled
        }

        int row = coordinates[0];
        int column = coordinates[1];

        for (int guessNumber = 1; guessNumber <= NUMBER_MAX_CELLS; guessNumber++) {

            //valid numbers are 1 - numberMaxCells
            if (isGuessNumberValidInCell(row, column, guessNumber)) {
                //check validation, if yes, put the number in the grid
                sudokuGrid[row][column] = guessNumber;
                if (solveSudoku()) { //recursively go for other rooms in the grid
                    return true;
                }
                sudokuGrid[row][column] = 0; //turn to unassigned space when conditions are not satisfied
            }
        }
        return false;
    }

    // Function to read the file with the initial sudoku grid
    private Boolean readFileToSudokuGrid(String fileNameSudoku) {

        String linha = null;
        int row;
        try {
            FileReader leArquivo = new FileReader(fileNameSudoku);
            BufferedReader bufferRead = new BufferedReader(leArquivo);
            //bufferRead.readLine();
            row = 0;
            while ((linha = bufferRead.readLine()) != null) {
                String tokens[] = linha.split(" ");

                sudokuGrid[row][0] = Integer.parseInt(tokens[0]);
                sudokuGrid[row][1] = Integer.parseInt(tokens[1]);
                sudokuGrid[row][2] = Integer.parseInt(tokens[2]);
                sudokuGrid[row][3] = Integer.parseInt(tokens[3]);
                sudokuGrid[row][4] = Integer.parseInt(tokens[4]);
                sudokuGrid[row][5] = Integer.parseInt(tokens[5]);
                sudokuGrid[row][6] = Integer.parseInt(tokens[6]);
                sudokuGrid[row][7] = Integer.parseInt(tokens[7]);
                sudokuGrid[row][8] = Integer.parseInt(tokens[8]);
                row++;
            }

            bufferRead.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }

    /*
     * Main Function
     */
    public static void main(String[] args) {

        if (args.length != 1) { //Diferent that the other languages
            System.out.println("\ndjcv-sudoku <filename>\n\n");
            System.exit(0);
        }

        Djcv_sudoku sudoku = new Djcv_sudoku();

        //Read the file with the initial sudoku grid
        if (!sudoku.readFileToSudokuGrid(args[0])) {
            System.out.println("\nProblems with the input file\n");
        }

        System.out.println("\n\nInitial Sudoku\n");

        sudoku.printSudokuGrid();

        //if (sudoku.solveSudoku() == true) {
        if (sudoku.solveSudoku() ) {
            // If a solution was founded, the final sudoku grid is printed
            System.out.println("\n\nFinal Sudoku\n");
            sudoku.printSudokuGrid();
        } else {
            System.out.println("No solution exists");
        }

          System.exit(0);
    }

}
