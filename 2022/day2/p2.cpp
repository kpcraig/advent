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

#define ROCK 1
#define PAPER 2
#define SCISSORS 3

#define LOSE 0
#define DRAW 3
#define WIN 6

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
      case 'A': // rock
        switch(me) {
          case 'X':
            // lose with scissors
            score += SCISSORS + LOSE;
            break;
          case 'Y':
            //draw with rock
            score += ROCK + DRAW;
            break;
          case 'Z':
            // win with paper
            score += PAPER + WIN;
            break;
        }
        break;
      case 'B': // paper
        switch(me) {
          case 'X':
            // lose with rock
            score += ROCK + LOSE;
            break;
          case 'Y':
            //draw with paper
            score += PAPER + DRAW;
            break;
          case 'Z':
            // win with scissors
            score += SCISSORS + WIN;
            break;
        }
        break;
      case 'C': // scis
        switch(me) {
          case 'X':
            // lose with paper
            score += PAPER + LOSE;
            break;
          case 'Y':
            //draw with scis
            score += SCISSORS + DRAW;
            break;
          case 'Z':
            // win with rock
            score += ROCK + WIN;
            break;
        }
        break;
      default:
        score += 0;
    }
  }

  cout << score << endl;
}
