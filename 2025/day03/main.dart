import 'dart:io';

(int, int) highestWithin(List<int> bank, int first, int last) {
  var max = 0;
  var maxIndex = -1;
  for(var i = first;i <= last;i++) {
    if(bank[i] > max) {
      max = bank[i];
      maxIndex = i;
    }
  }

  print("found $max at $maxIndex, within $first:$last");
  return (max, maxIndex);
}

main(List<String> args) {
  var banks = List<List<int>>.empty(growable: true);

  // how many batteries to turn on in each bank
  var batteryCount = int.parse(args[0]);

  var totalJoltage = 0;
  while(true) {
    var line = stdin.readLineSync();
    if(line == null) {
      break;
    }
    // add a new bank to the banks array
    var bank = List<int>.empty(growable: true);
    banks.add(bank);
    for(var i = 0;i < line.length;i++) {
      var joltage = int.parse(line[i]);
      bank.add(joltage);
    }
  }

  for(var bank in banks) {
    var bankJoltage = 0;
    var first = 0;
    var last = bank.length - batteryCount;
    for(var i = 0;i < batteryCount;i++) {
      // shift joltage
      bankJoltage *= 10;
      var (joltage, idx) = highestWithin(bank, first, last);
      // add joltage
      bankJoltage += joltage;
      // shift first and last.
      last++;
      first = idx + 1;
    }
    print("$bank: $bankJoltage");
    totalJoltage += bankJoltage;
  }

  print("total: $totalJoltage");
}
