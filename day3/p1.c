#include <stdio.h>
#include <stdlib.h>

typedef struct {
	int x;
	int y;
} point;

int pteq(point p1, point p2) {
	return p1.x == p2.x && p1.y == p2.y;
}

point* append_if_unique(point* pts, int* len, point pt) {
	int i, j = *len;
	for(i = 0;i < j;i++) {
		if(pteq(pts[i], pt)) {
			return pts;
		}
	}
	// No matches, so append
	pts = realloc(pts, sizeof(point) * (j+1));
	pts[j] = pt;
	*len = j+1;
	return pts;
}

int main() {
	point* points = (point*)malloc(0);
	int len = 0;
	point location = (point){0,0};
	points = append_if_unique(points, &len, location);
	FILE* fd = fopen("input", "r");
	int c;
	while((c = fgetc(fd)) != EOF) {
		switch(c) {
			case '^':
				location = (point){location.x, location.y+1};
				break;
			case 'v':
			case 'V':
				location = (point){location.x, location.y-1};
				break;
			case '<':
				location = (point){location.x-1,location.y};
				break;
			case '>':
				location = (point){location.x+1,location.y};
		}
		points = append_if_unique(points, &len, location);
		// printf("%d\n", len);
	}
	printf("Visits: %d\n", len);
	free(points);
	fclose(fd);
	return 0;
}
