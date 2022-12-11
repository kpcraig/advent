def main
  filename = (ARGV[0] or "input")
  prob_num = (ARGV[1].to_i or 1)

  monkey_match = /Monkey (\d+):/
  items_match = /Starting items: ((\d+, )*(\d+))/
  operation_match = /Operation: new = old ([*+]) (\d+|old)/
  test_match = /Test: divisible by (\d+)/
  true_match = /If true: throw to monkey (\d)/
  false_match = /If false: throw to monkey (\d)/

  monkeys = []
  lines = []

  val_lcm = 1

  File.open(filename).each_with_index do |line,line_num |
    line_trim = line.strip
    next if line_trim == ''
    lines.append(line_trim)
  end

  (0..lines.length() - 1).step(6).each { |i|
    monkey_num = i / 6

    # line + 1 is items
    matches = lines[i+1].match(items_match)
    items = matches[1].split(", ").filter_map{ |x| x.to_i}

    # line + 2 is operation
    matches = lines[i+2].match(operation_match)
    if matches[1] == '+' then
      if matches[2] == 'old' then
        operation = lambda {|val| val + val}
      else
        value = matches[2].to_i
        operation = lambda {|val| val + value}
      end
    else
      if matches[2] == 'old' then
        operation = lambda {|val| val * val}
      else
        value = matches[2].to_i
        operation = lambda {|val| val * value}
      end
    end

    # line + 3 is test expression
    matches = lines[i+3].match(test_match)
    divisor = matches[1].to_i
    val_lcm = val_lcm * divisor
    test = lambda {|val| return val % divisor == 0}

    # line +4 and line +5 are true/false operations
    matches = lines[i+4].match(true_match)
    true_monkey = matches[1].to_i
    matches = lines[i+5].match(false_match)
    false_monkey = matches[1].to_i

    monkeys[monkey_num] = Monkey.new(items, operation, test, true_monkey, false_monkey)
  }

  round_count = if prob_num == 1 then
                  20
                else
                  10000
                end

  # 20 rounds do |m|
  (1..round_count).each do |i|
    monkeys.each_with_index do |m, i|
      # puts "Monkey #{i}:"
      while m.size() > 0 do
        item = m.get
        # puts "  Monkey inspects an item with a worry level of #{item}"
        item = m.do_operation(item)
        # puts "    Worry level is now #{item}"
        # we calm down
        if prob_num == 1 then
          item = item / 3
        else
          item = item % val_lcm
        end
        # puts "    Monkey gets bored with item. Worry level is divided by 3 to #{item}"
        # check
        t = m.target(item)
        # puts "    Item with worry level #{item} is thrown to monkey #{t}"
        monkeys[t].push(item)
      end
    end
  end

  # monkeys.each_with_index { |m, i| puts "Monkey #{i} inspected items #{m.inspect_count} times." }
  first = 0
  second = 0
  monkeys.each_with_index do |m, i|
    if m.inspect_count > first
      second = first
      first = m.inspect_count
    elsif m.inspect_count > second
      second = m.inspect_count
    end
  end

  puts first*second

end


class Monkey
  def initialize(items, operation, test, true_monkey, false_monkey)
    @items = items
    @operation = operation
    @test = test
    @tm = true_monkey
    @fm = false_monkey
    @inspect = 0
  end

  def inspect_count
    return @inspect
  end

  def do_operation(item)
    return @operation.call(item)
  end

  # pop inspects an item, and removes it from the list of items.
  # call target to see who gets the item
  def get
    @inspect = @inspect + 1
    @items = @items.reverse
    item = @items.pop
    @items = @items.reverse

    return item
  end

  def push(item)
    @items = @items.append(item)
  end

  # who gets the item
  def target(worry)
    check = @test.call(worry)
    if check
      return @tm
    else
      return @fm
    end
  end

  def size
    return @items.length()
  end
end

main()