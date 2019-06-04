/*
   Name:  djcv-sudoku

   Description

   This program implements the Backtracking algorithm.
   The backtracking algorithm, is a type of brute force search.

   A brute force algorithm visits the empty cells in some order, filling in digits sequentially, or backtracking when the number is found to be not valid. Briefly, a program would solve a puzzle by placing the digit "1" in the first cell and checking if it is allowed to be there. If there are no violations (checking row, column, and box constraints) then the algorithm advances to the next cell, and places a "1" in that cell. When checking for violations, if it is discovered that the "1" is not allowed, the value is advanced to "2". If a cell is discovered where none of the 9 digits is allowed, then the algorithm leaves that cell blank and moves back to the previous cell. The value in that cell is then incremented by one. This is repeated until the allowed value in the last (81st) cell is discovered.

   The explantion of the algorithm can be found in the link:

   https://en.wikipedia.org/wiki/Sudoku_solving_algorithms

  USAGE:

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
   17/03/2019   David C.        First Version

*/

// Libraries

use std::{
	env,
    fs::File,
    io::{BufRead, BufReader},
};

//use std::env;

//Constants
const NUMBER_MAX_CELLS: usize = 9;
const NUMBER_CELLS_IN_BOX: usize = 3;
const EMPTY_CELL: usize = 0;

//Global variables
static mut GRID: &'static mut [[usize; NUMBER_MAX_CELLS]; NUMBER_MAX_CELLS] =   &mut [[0; NUMBER_MAX_CELLS]; NUMBER_MAX_CELLS];

// Main Function
fn main() {
 
    // Get the arguments
    let args: Vec<String> = env::args().collect();

    //println! ( "numero de argumentos {} ", args.len() ) ;

	// Verify the argument quantity
	if args.len() != 2 {
		println!("\ndjcv-sudoku <filename>\n\n") ;
		panic! ( "" );
	}

	let filename = &args[1] ;

	//Read the file with the initial sudoku grid
	if !read_file_to_sudoku_grid(filename.to_string()) {
		println!("\nProblems with the input file\n");
	}

	println!("\n\nInitial Sudoku\n");

	print_sudoku_grid();

	if solve_sudoku() {
		// If a solution was founded, the final sudoku grid is printed
		println!("\n\nFinal Sudoku\n");
		print_sudoku_grid();
	} else {
		println!("No solution exists");
	}
}

// Function to verify if the guess number already exist in the column or not
fn is_guess_number_present_in_column(column: usize, guess_number: usize) -> bool {
	for row in 0..NUMBER_MAX_CELLS {
		unsafe {
			if GRID[row][column] == guess_number {
				return true;
			}
		}
	}
	return false
}

// Function to verify if the guess number already exist in the row or not
fn is_guess_number_present_in_row(row: usize, guess_number: usize) -> bool {
	for column in 0..NUMBER_MAX_CELLS {
		unsafe {
			if GRID[row][column] == guess_number {
				return true;
			}
		}
	}
	return false;
}

//Function to verify if the number is already in a box [3,3]
fn is_guess_number_present_in_box(box_start_row: usize, box_start_column: usize, guess_number: usize) -> bool {
	//check whether number is present in 3x3 box or not
	for row in 0..NUMBER_CELLS_IN_BOX {
		for column in 0..NUMBER_CELLS_IN_BOX {
			unsafe {
				if GRID[row+box_start_row][column+box_start_column] == guess_number {
					return true;
				}
			}
		}
	}
	return false;
}

// Function to print the sudoku grid after solve it
fn print_sudoku_grid() {

	for row in 0..NUMBER_MAX_CELLS {
		for column in 0..NUMBER_MAX_CELLS {
			if column == 3 || column == 6 {
				print!(" | ");
			}
			unsafe {
			   print!("{} ", GRID[row][column]) ;
			}
		}

		if row == 2 || row == 5 {
			println!();
			for _i in 0..NUMBER_MAX_CELLS {
				print!("---");
			}
		}
		println!();
	}
	println!();
}

// Function to get empty cell and update row and column
// THe emptyCell is defined as 0 value
fn find_empty_cell(row_in: &mut usize, column_in: &mut usize) -> bool {
	for row in 0..NUMBER_MAX_CELLS  {
		for column in 0..NUMBER_MAX_CELLS  {
			unsafe {
				if GRID[row][column] == EMPTY_CELL { //marked with 0 is empty
					*row_in = row;
					*column_in = column ;
					//println! ( "find_empty_cell" );
					//println! ( " row {} Column {}", *row_in, *column_in );
					return true;
				}
			}
		}
	}
	return false;
}

// Function that check it the guess number is valid in the cell.
// This is when the guess number is not found in col, row and the current 3x3 box
fn is_guess_number_valid_in_cell(row: usize, column: usize, guess_number: usize) -> bool {
	return !is_guess_number_present_in_row(row, guess_number) &&
		!is_guess_number_present_in_column(column, guess_number) &&
		!is_guess_number_present_in_box(row-row%NUMBER_CELLS_IN_BOX, column-column%NUMBER_CELLS_IN_BOX, guess_number) ;
}

// Function to solve the Sudoku using the Backtracking algorithm.
fn solve_sudoku() -> bool {
	let mut row: usize = 0;
	let mut column: usize = 0 ;

	if !find_empty_cell(&mut row, &mut column) {
		return true //when all places are filled
	}

	for guess_number in 1..NUMBER_MAX_CELLS+1 {
		//valid numbers are 1 - numberMaxCells
		if is_guess_number_valid_in_cell(row, column, guess_number) {
			//check validation, if yes, put the number in the grid
			unsafe {
			    GRID[row][column] = guess_number ;
				//println! ( "solve_sudoku" );
				//println! ( "Guest Number  {}", guess_number );
			}

			if solve_sudoku() { //recursively go for other rooms in the grid
				return true
			}
			unsafe {  
			    GRID[row][column] = 0 ; //turn to unassigned space when conditions are not satisfied
			}
		}
	}
	return false ;
}

// Function to read the file with the initial sudoku grid
fn read_file_to_sudoku_grid(filename: String) -> bool {

   let file = BufReader::new(File::open(filename).unwrap());

    // preallocate the array and read the data into it
    for (row, line) in file.lines().enumerate() {
        for (column, number) in line.unwrap().split(char::is_whitespace).enumerate() {
			unsafe {
               GRID[row][column] = number.trim().parse().unwrap();
			}
        }
    }

	return true ;
}

