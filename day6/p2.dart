import 'dart:io';
import 'dart:convert';
import 'dart:async';

List<List<int>> lights = new List(1000);

RegExp rx = new RegExp(r"(turn on|turn off|toggle) (\d+?,\d+?) through (\d+?,\d+)");

main() {
	// make lights array
	for(var i = 0;i < lights.length;i++) {
		lights[i] = new List(1000);
		for(var j = 0;j < 1000;j++) {
			lights[i][j] = 0;
		}
	}

	// we read synchronously because who cares
	File input = new File('input');
	input.openRead()
		.transform(utf8.decoder)
		.transform(new LineSplitter())
		.listen((String line) {
			Iterable<Match> matches = rx.allMatches(line);
			var m = matches.first;
			var action = m.group(1);
			var c1 = coords(m.group(2));
			var c2 = coords(m.group(3));

			switch(action) {
				case 'turn on':
					turn(true, c1[0], c2[0], c1[1], c2[1]);
					break;
				case 'turn off':
					turn(false, c1[0], c2[0], c1[1], c2[1]);
					break;
				case 'toggle':
					toggle(c1[0], c2[0], c1[1], c2[1]);
					break;
			}
		},
		onDone: () {
			int brightness = 0;
			for(var row in lights) {
				for (var light in row) {
					brightness += light;
				}
			}
			print(brightness);
		},
		onError: (e) {});
}

List<int> coords(String commaString) {
	var nums = commaString.split(",");
	List<int> c = new List(2);
	c[0] = int.parse(nums[0]);
	c[1] = int.parse(nums[1]);

	return c;
}

turn(bool on, int xstart, int xend, int ystart, int yend) {
	for(int x = xstart;x <= xend;x++) {
    for(int y = ystart;y <= yend;y++) {
      if(on) {
        lights[x][y]++;
      } else {
        lights[x][y]--;
				if(lights[x][y] < 0) {
					lights[x][y] = 0;
				}
      }
    }
  }
}

toggle(int xstart, int xend, int ystart, int yend) {
	for(int x = xstart;x <= xend;x++) {
		for(int y = ystart;y <= yend;y++) {
			lights[x][y] += 2;
		}
	}
}
