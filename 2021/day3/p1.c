#include <stdlib.h>
#include <stdio.h>

#define NUM_LENGTH 12 // in the input
// #define NUM_LENGTH 5 // in the sample 

int ones[NUM_LENGTH]; // how many 1s in each position
int zeros[NUM_LENGTH];

int main() {
    FILE* fd = fopen("input", "r"); // open input for reading
    
    // this is advent of code, so assume there are values and assume the input is right
    int c;
    while(1) {
        c = fgetc(fd);
        if(c == EOF) {
            break; // if the first value is eof, we're done
        } else if(c == '\n') {
            continue;
        }
        // put it back
        ungetc(c, fd);

        // read NUM_LENGTH values
        for(int i = 0;i < NUM_LENGTH;i++) {
            c = fgetc(fd);
            if(c == '1') {
                ones[i]++;
            } else {
                zeros[i]++;
            }
        }

        // consume carriage return
        fgetc(fd);
    }

    int pow = (1 << (NUM_LENGTH - 1));
    int gamma = 0;
    int epsilon = 0;
    for(int i = 0;i < NUM_LENGTH;i++) {
        // the puzzle does not specify what happens if the counts are equal, i assume it doesn't happen.
        if(ones[i] > zeros[i]) {
            gamma += pow;
        } else {
            epsilon += pow;
        }
        pow >>= 1;
    }

    printf("gamma: %d\nepsilon: %d\npower: %d\n", gamma, epsilon, gamma * epsilon);

    fclose(fd);
}