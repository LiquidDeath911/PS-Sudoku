# PS-Sudoku
A recursive Sudoku solver written as a PowerShell module.

## Current Version - 1.3.4
Install from the [PowerShell Gallery](https://www.powershellgallery.com/packages/PS-Sudoku/1.2.2)!
```pwsh
Install-Module -Name PS-Sudoku
```
### Instructions
First, generate a sudoku board, specify difficulty of "Easy, Medium, Hard, Expert, Insane, or UniqueSolution"
```pwsh
$SudokuBoard = GenerateGrid -Difficulty "Medium"
```
Print the board to see the starting state
```pwsh
PrintGrid -SudokuGrid $SudokuBoard
```
Solve the sudoku board. Note that depending on the difficulty of the puzzle, it may take a while. (The unique solution took 3.5 hrs on a 10th gen intel i5 processor)
```pwsh
SolveSudoku -SudokuGrid $SudokuBoard #add the -WatchAlgorithm switch to see the algorithm in action
```
After the solver is complete, print the finished Sudoku board!
```pwsh
PrintGrid -SudokuGrid $SudokuBoard
```


## Build Status - Main Branch
| CI System | Environment | Job Name & Status |
| :--- | :--- | :--- |
| GitHub Actions | Windows(v2019 - Current) | ![Build Status](https://github.com/DavisHenckel/PS-Sudoku/actions/workflows/WindowsProd.yml/badge.svg)  |
| GitHub Actions | Ubuntu(v18 - Current) | ![Build Status](https://github.com/DavisHenckel/PS-Sudoku/actions/workflows/LinuxProd.yml/badge.svg) |  
| GitHub Actions | MacOS(v10 - Current) | ![Build Status](https://github.com/DavisHenckel/PS-Sudoku/actions/workflows/MacOSProd.yml/badge.svg)

### Build Status - Development Branch
| CI System | Environment | Job Name & Status |
| :--- | :--- | :--- |
| GitHub Actions | Windows(v2019 - Current) | ![Build Status](https://github.com/DavisHenckel/PS-Sudoku/actions/workflows/WindowsDev.yml/badge.svg)  |
| GitHub Actions | Ubuntu(v18 - Current) | ![Build Status](https://github.com/DavisHenckel/PS-Sudoku/actions/workflows/LinuxDev.yml/badge.svg) |  
| GitHub Actions | MacOS(v10 - Current) | ![Build Status](https://github.com/DavisHenckel/PS-Sudoku/actions/workflows/MacOSDev.yml/badge.svg)
