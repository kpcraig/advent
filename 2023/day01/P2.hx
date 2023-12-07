class P2 {
  static public function main() {
    var total = 0;
    var reg = ~/one|two|three|four|five|six|seven|eight|nine|\d/;
    try {
      while(true) {
        var line = Sys.stdin().readLine();
        var matches = [];
        while(reg.match(line)) {
          matches.push(reg.matched(0));
          line = reg.matchedRight();
        }
        total += (str2val(matches[0]) * 10 + str2val(matches[matches.length-1]));
      }
    }
    catch (e:haxe.io.Eof) {
      trace('caught');
    }
    Sys.println('$total');
  }

  static function str2val(s:String):Int {
    return switch s {
      case 'one' | '1':
        1;
      case 'two' | '2':
        2;
      case 'three' | '3':
        3;
      case 'four' | '4':
        4;
      case 'five' | '5':
        5;
      case 'six' | '6':
        6;
      case 'seven' | '7':
        7;
      case 'eight' | '8':
        8;
      case 'nine' | '9':
        9;
      case _:
        0;
    }
  }
}
