#include <iostream>
#include <fstream>
#include <set>
#include <cmath>

// Yeah, I know.
using namespace std;

typedef struct {
	int x,y;
} Point;

struct ptcmp {
	bool operator() (const Point& lhs, const Point& rhs) const{
		if(lhs.x < rhs.x) {
			return true;
		} else if(rhs.x < lhs.x) {
			return false;
		} else if(lhs.y < rhs.y) {
			return true;
		}
		return false;
	}
};

int main(int argc, char** argv) {
	set<Point, ptcmp> pts;
	Point santa_location = (Point){0,0};
	Point robo_location = (Point){0,0};
	Point mod;
	// initial delivery
	pts.insert(santa_location);
	// pts.insert((Point){2,-2});
	// pts.insert((Point){-2,-2});
	// cout << pts.size() << endl;
	// pts.insert((Point){-2,-2});
	// cout << pts.size() << endl;
	ifstream fin(argv[1]);
	char c;
	int count = 0;
	while(fin) {
		c = ' ';
		fin >> c;
		switch(c) {
			case '^':
				mod = (Point){0,1};
				break;
			case 'v':
			case 'V':
				mod = (Point){0,-1};
				break;
			case '>':
				mod = (Point){1,0};
				break;
			case '<':
				mod = (Point){-1,0};
				break;
			default:
				mod = (Point){0,0}; // The last carriage return?
		}
		if(count % 2 == 0) {
			santa_location = (Point){santa_location.x + mod.x, santa_location.y + mod.y};
			pts.insert(santa_location);
		} else {
			robo_location = (Point){robo_location.x + mod.x, robo_location.y + mod.y};
			pts.insert(robo_location);
		}
		count++;
	}
	cout << "Visits:" << pts.size() << endl;
}
