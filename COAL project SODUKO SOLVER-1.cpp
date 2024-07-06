#include <iostream>
#define N 9
using namespace std;
int grid[9][9] = {
   {0, 0, 0, 0, 0, 0, 1, 0, 9},
   {8, 0, 0, 0, 7, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 9, 3, 5, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 4, 0, 6, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 7, 0},
   {6, 7, 0, 0, 0, 0, 0, 8, 0},
   {0, 0, 0, 2, 0, 3, 0, 0, 0},
   {4, 0, 0, 9, 0, 0, 0, 0, 0}
};
bool isPresentInCol(int colic, int numic){ //check whether num is present in col or not
   for (int rowic = 0; rowic < 9; rowic++)
      if (grid[rowic][colic] == numic)
         return true;
   return false;
}
bool isPresentInRow(int rowir, int numir){ //check whether num is present in row or not
   for (int colir = 0; colir < 9; colir++)
      if (grid[rowir][colir] == numir)
         return true;
   return false;
}
bool isPresentInBox(int boxStartRow, int boxStartCol, int numbox){
//check whether num is present in 3x3 box or not
   for (int rowib = 0; rowib < 3; rowib++)
      for (int colib = 0; colib < 3; colib++)
         if (grid[rowib+boxStartRow][colib+boxStartCol] == numbox)
            return true;
   return false;
}
void sudokuGrid(){ //print the sudoku grid after solve
   for (int rowprint = 0; rowprint < 9; rowprint++){
      for (int colprint = 0; colprint < 9; colprint++){
         if(colprint == 3 || colprint == 6)
            cout << " | ";
         cout << grid[rowprint][colprint] <<" ";
      }
      if(rowprint == 2 || rowprint == 5){
         cout << endl;
         for(int i = 0; i<9; i++)
            cout << "---";
      }
      cout << endl;
   }
}
bool findEmptyPlace(int &row, int &col){ // isme global use honge
//get empty location and update row and column
   for (row = 0; row < 9; row++)
      for (col = 0; col < 9; col++)
         if (grid[row][col] == 0) //marked with 0 is empty
            return true;
   return false;
}
bool isValidPlace(int rowval, int colval, int numval){
   //when item not found in col, row and current 3x3 box
   int modcol=colval - colval%3;
   int modrow=rowval - rowval%3;
   return !isPresentInRow(rowval, numval) && !isPresentInCol(colval, numval) && 
   !isPresentInBox(modrow,modcol, numval);
}
bool solveSudoku(){
   int row, col;
   if (!findEmptyPlace(row, col))
      return true; //when all places are filled
   for (int num = 1; num <= 9; num++){ //valid numbers are 1 - 9
      if (isValidPlace(row, col, num)){ //check validation, if yes, put the number in the grid
         grid[row][col] = num;
         if (solveSudoku()) //recursively go for other rooms in the grid
            return true;
         grid[row][col] = 0; //turn to unassigned space when conditions are not satisfied
      }
   }
   return false;
}
int main(){
   if (solveSudoku() == true)
      sudokuGrid();
   else
      cout << "No solution exists";
   
}