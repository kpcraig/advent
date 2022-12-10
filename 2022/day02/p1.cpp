#include <iostream>
#include <fstream>

// yeah, i know
using namespace std;

// a = x == 1 Rock
// b = y == 2 Paper
// c = z == 3 Scissors

// 0 = loss
// 3 = draw
// 6 = win



int main(int arc, char** argv) {
  ifstream fin(argv[1]);

  char you, me, trash, trash2;
  int score = 0;

  while(fin) {
    you = ' ';
    me = ' ';
    trash = ' ';
    fin >> you; // first char
    fin >> me; // second char

    switch(you) {
      case 'A':
        switch(me) {
          case 'X':
            // draw
            score += 1 + 3;
            break;
          case 'Y':
            // win
            score += 2 + 6;
            break;
          case 'Z':
            score += 3 + 0;
            break;
        }
        break;
      case 'B':
        switch(me) {
          case 'X':
            // loss
            score += 1 + 0;
            break;
          case 'Y':
            // draw
            score += 2 + 3;
            break;
          case 'Z':
            // win
            score += 3 + 6;
            break;
        }
        break;
      case 'C':
        switch(me) {
          case 'X':
            // win
            score += 1 + 6;
            break;
          case 'Y':
            // loss
            score += 2 + 0;
            break;
          case 'Z':
            // draw
            score += 3 + 3;
            break;
        }
        break;
      default:
        score += 0;
    }
  }

  cout << score << endl;
}

