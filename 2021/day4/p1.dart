import 'dart:io';
import 'dart:convert';
import 'dart:async';

class Bingo {
  List<int> values = [];
  int state = 0;

  Bingo(List<int> values) {
    this.values = [...values];
  }

  bool check(int n) {
    var i = this.values.indexOf(n);
    // print("found ${n} at index ${i}");
    if (i != -1) {
      this.state = this.state | (1 << (25 - i - 1));
    }
    // print("state is ${this.state}");
    for (final v in victories) {
      if (this.state & v == v) {
        return true;
      }
    }

    return false;
  }

  int score(int trigger) {
    var state = this.state.toRadixString(2).padLeft(25, "0").split("");
    var sum = 0;
    for (var i = 0; i < state.length; i++) {
      if (state[i] == "0") {
        // print("for index ${i}, adding to sum ${this.values[i]}");
        sum += this.values[i];
      }
    }
    return sum * trigger;
  }

  String toString() {
    return "${this.values[0]} : ${this.state.toString()}";
  }
}

var victories = {
  int.parse("1111100000000000000000000", radix: 2),
  int.parse("0000011111000000000000000", radix: 2),
  int.parse("0000000000111110000000000", radix: 2),
  int.parse("0000000000000001111100000", radix: 2),
  int.parse("0000000000000000000011111", radix: 2),
  int.parse("1000010000100001000010000", radix: 2),
  int.parse("0100001000010000100001000", radix: 2),
  int.parse("0010000100001000010000100", radix: 2),
  int.parse("0001000010000100001000010", radix: 2),
  int.parse("0000100001000010000100001", radix: 2),
  // diagonals don't count lol
  // int.parse("1000001000001000001000001", radix: 2),
  // int.parse("0000100010001000100010000", radix: 2),
};

var re = RegExp(r"\s+");
var re2 = RegExp(r"^\s*$");

void main() {
  // print(victories);

  File input = new File('input');
  int lc = 0;
  List<int> moves = [];
  List<Bingo> boards = [];
  List<int> currValues = [];
  input.openRead().transform(utf8.decoder).transform(new LineSplitter()).listen(
      (String line) {
    // this is kind of cheesy but...
    if (lc == 0) {
      // this is the set of numbers we get
      for (final v in line.split(",")) {
        moves.add(int.parse(v));
      }
    } else if (lc >= 2) {
      if (re2.hasMatch(line)) {
        boards.add(Bingo(currValues));
        currValues = [];
      } else {
        // print(line);
        for (final v in line.trim().split(re)) {
          currValues.add(int.parse(v));
        }
      }
    }
    lc++;
  }, onDone: () {
    boards.add(Bingo(currValues));
    print(moves);

    for (final m in moves) {
      // print("playing $m");
      boards.asMap().forEach((i, board) {
        var win = board.check(m);
        // print(board);
        // print(value.state);
        if (win) {
          print("win ${i}");
          var score = board.score(m);
          print("score: ${score}");
          exit(0);
        }
      });
    }
  }, onError: (e) {
    print(lc);
  });
}
