class P1 {
  static public function main() {
    var total = 0;
    var v1 = 0;
    var v2 = 0;
    try {
      while(true) {
        var bt = Sys.stdin().readByte();
        if(bt == 10){
          // carriage return
          Sys.println('$v1 $v2');
          total += v1 * 10 + v2;
          v1 = 0; v2 = 0;
        } else if(bt >= 0x30 && bt < 0x3A) {
          if(v1 == 0) {
            v1 = bt-0x30; v2 = bt-0x30;
          } else {
            v2 = bt-0x30;
          }
        }
      }
    }
    catch (e:haxe.io.Eof) {
      trace('caught');
    }
    Sys.println('$total');
  }
}
