import std.range, std.stdio, std.string, std.regex, std.conv;

int[1000][1000] lights;

void main() {
  auto input = File("input", "r");
  auto range = input.byLine();
  foreach( line; range) {
    auto parts = split(line);
    switch(parts[0]) {
      case "toggle":
        auto s = array(splitter(parts[1], regex(",")));
        auto e = array(splitter(parts[3], regex(",")));
        toggle(to!int(s[0]), to!int(e[0]), to!int(s[1]), to!int(e[1]));
        break;
      case "turn":
        auto s = array(splitter(parts[2], regex(",")));
        auto e = array(splitter(parts[4], regex(",")));
        turn(parts[1], to!int(s[0]), to!int(e[0]), to!int(s[1]), to!int(e[1]));
        break;
      default:
        writeln(parts[0]);
    }
  }

  int count = 0;
  for(int x = 0;x < 1000;x++) {
    for(int y = 0;y < 1000;y++) {
      if(lights[x][y] == 1) {
        count++;
      }
    }
  }
  writeln(count);
}

void toggle(int xstart, int xend, int ystart, int yend) {
  writeln("Toggling", xstart, xend, ystart, yend);
  for(int x = xstart;x <= xend;x++) {
    for(int y = ystart;y <= yend;y++) {
      lights[x][y] = !lights[x][y];
    }
  }
}

void turn(char[] state, int xstart, int xend, int ystart, int yend) {
  writeln("Turning", state, xstart, xend, ystart, yend);
  for(int x = xstart;x <= xend;x++) {
    for(int y = ystart;y <= yend;y++) {
      if(state == "on") {
        lights[x][y] = 1;
      } else {
        lights[x][y] = 0;
      }
    }
  }
}
