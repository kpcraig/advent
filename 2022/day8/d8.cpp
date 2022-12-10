#include <iostream>
#include <fstream>
#include <string>

// yeah, i know
using namespace std;

int main(int argc, char** argv) {
  ifstream fin(argv[1]);

  size_t width = 0, height = 0;
  string line;
  // i suppose the easy lazy way is to read the file twice
  while(fin) {
    fin >> line;
    width = line.size();
    height++;
  }
  height--; // terminating carriage return that i promise is there

  fin.close();

  unsigned int grid[height][width];

  // reopen
  fin.open(argv[1]);
  unsigned line_num = 0;
  while(fin) {
    if(line_num == height) {
      // last line is nothing
      break;
    }
    fin >> line;
    cout << line << endl;
    for(unsigned i = 0;i < line.size();i++) {
      auto val = line.substr(i, 1);
      grid[line_num][i] = stoi(val);
    }
    line_num++;
  }

  // slow way to do this
  unsigned visible = 2*height + 2*width - 4, max_scenic = 0;
  for(unsigned i = 0;i < height;i++) {
    for(unsigned j = 0;j < width;j++) {
      unsigned sl = 0, su = 0, sd = 0, sr = 0;
      if(i == 0 || j == 0 || i == height-1 || j == width-1) {
        continue;
      }
      // there's a faster way to do the visible calculation that involves precomputing max tree heights that runs O(n)
      // there's probably a similar algorithm for scenic but this is AoC and this runs fast enough, despite being O(n^2)
      // (we run an operation proportional to the size of the grid for each element of the grid, so n*Kn)
      bool is_visible = false;
      // look left (-j direction)
      for(int jp = j-1;jp >= -1;jp--) {
        if(jp < 0) {
          sl = j;
          is_visible = true;
          break;
        }
        auto tree = grid[i][j];
        auto view = grid[i][jp];
        if (view >= tree) {
          sl = j - jp;
          break;
        }
      }

      // look right
      for(unsigned jp = j+1;jp <= width;jp++) {
        if(jp >= width) {
          sr = width - 1 - j;
          is_visible = true;
          break;
        }
        auto tree = grid[i][j];
        auto view = grid[i][jp];
        if(view >= tree) {
          sr = jp - j;
          break;
        }
      }

      // look up
      for(int ip = i - 1;ip >= -1;ip--) {
        if(ip < 0) {
          su = i;
          is_visible = true;
          break;
        }
        auto tree = grid[i][j];
        auto view = grid[ip][j];
        if(view >= tree) {
          su = i - ip;
          break;
        }
      }

      // look down
      for(unsigned ip = i + 1;ip <= height;ip++) {
        if(ip >= height) {
          sd = height - 1 - i;
          is_visible = true;
          break;
        }
        auto tree = grid[i][j];
        auto view = grid[ip][j];
        if(view >= tree) {
          sd = ip - i;
          break;
        }
      }

      if(is_visible) {
        visible++;
      }
      auto scenic = sl * sr * su * sd;
      if(scenic > max_scenic) {
        max_scenic = scenic;
      }
    }
  }

  cout << "p1:" << visible << endl << "p2:" << max_scenic << endl;
}