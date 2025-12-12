#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>

typedef struct {
	long start;
	int start_digits;
	long end;
	int end_digits;
} range;

bool inrange(range* rg, long val) {
	return val >= rg->start && val <= rg->end;
}

bool in_any_range(range** rgs, int len, long val) {
	for(int i = 0;i < len;i++) {
		if(inrange(rgs[i], val)) {
			return true;
		}
	}
	return false;
}

int num_digits(long val) {
	// yeah, this is slow
	return floor(log10(val)) + 1;
}

int main() {
	char* line = NULL;
	size_t size = 0;
	if(getline(&line, &size, stdin) == -1) {
		return 1;
	}
	// printf("%s\n", line);

	// work through the ranges until we get to the end
	char* endptr = NULL;
	range** ranges = (range**)calloc(0, sizeof(range*));
	int ranges_len = 0;
	int min_dig = 20000; int max_dig = 0;
	do {
		// read the value in. this will stop reading the string
		// at the first non-numeric value.
		long start = strtol(line, &endptr, 10);
		// skip the hyphen
		line = endptr+sizeof(char);

		// read the next value in
		long end = strtol(line, &endptr, 10);
		// skip the comma
		line = endptr+sizeof(char);
		range* rg = calloc(1, sizeof(range));
		rg->start = start;
		rg->start_digits = num_digits(start);
		rg->end = end;
		rg->end_digits = num_digits(end);
		printf("constructed range with bounds %ld(%d), %ld(%d)\n", 
				rg->start, 
				rg->start_digits, 
				rg->end,
				rg->end_digits);

		// append to array
		ranges = realloc(ranges, sizeof(range*) * (ranges_len+1));
		ranges[ranges_len++] = rg;

		if(rg->start_digits > max_dig) { max_dig = rg->start_digits; }
		if(rg->start_digits < min_dig) { min_dig = rg->start_digits; }
		if(rg->end_digits > max_dig) { max_dig = rg->end_digits; }
		if(rg->end_digits < min_dig) { min_dig = rg->end_digits; }

	} while(*endptr != '\0' && *endptr != '\n');
	printf("digit range: %d, %d\n", min_dig, max_dig);

	long long total = 0;
	// start with the low digit
	for(int i = min_dig;i <= max_dig;i++) {
		// track values to avoid duplication
		long* hits = NULL;
		int hits_len = 0;

		for(int width = 1;width <= i / 2;width++) {
			if(i%width != 0) {
				continue;
			}
			int start = pow(10, width-1);
			int end = pow(10, width);
			printf("start %d(%d), end %d\n", start, width, end);
			int repeats = i / width;
			for(int j = start;j < end;j++) {
				// construct the number
				long id = 0;
				for(int r = 0;r < repeats;r++) {
					id += j * pow(end, r);
				}
				if(in_any_range(ranges, ranges_len, id)) {
					bool already = false;
					for(int s = 0;s < hits_len;s++) {
						if(id == hits[s]) {
							already = true;
							break;
						}
					}
					if(!already) {
						printf("hit %ld\n", id);
						hits = realloc(hits, sizeof(long) * (hits_len+1));
						hits[hits_len++] = id;
						total += id;
					} else {
						printf("already included %d\n", id);
					}
				}
			}
		}
	}
	printf("total: %ld\n", total);

	return 0;
}
