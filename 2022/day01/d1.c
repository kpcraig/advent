#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>

int main() {
  // the bulk of this code is STOLEN from MYSELF from LAST YEAR

  FILE* fd = fopen("input", "r"); // open input for reading

  // this is advent of code, so assume there are values and assume the input is correct
  char* line = NULL;
  size_t len = 0;
  ssize_t read;
  int max_food = 0;
  int second_food = 0;
  int third_food = 0;
  int elf_food = 0;
  while((read = getline(&line, &len, fd)) != -1) {
    if(read > 1) {
      elf_food += atoi(line);
    } else {
      if(elf_food > max_food) {
        third_food = second_food;
        second_food = max_food;
        max_food = elf_food;
      } else if(elf_food > second_food) {
        third_food = second_food;
        second_food = elf_food;
      } else if(elf_food > third_food) {
        third_food = elf_food;
      }
      elf_food = 0;
    }
  }

  printf("max food: %d\n", max_food);
  printf("second food: %d\n", second_food);
  printf("third food: %d\n", third_food);
  printf("total food: %d\n", max_food + second_food + third_food);

}