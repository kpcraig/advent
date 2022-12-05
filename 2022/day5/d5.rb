# This one is kind of cheaty - you invoke it with 3 args, height of tallest stack, width of stacks, and 1 or 2 depending on part
def main
    stacklines = ARGV[1].to_i # do we think this is cheating
    stackwidth = ARGV[2].to_i # what about this
    problem = ARGV[3].to_i
    stacks = Array.new(stackwidth)
    # for i in (0..stackwidth-1) do
    #     stacks[i] = Array.new(0)
    # end
    File.open(ARGV[0]).each_with_index do |line,line_num|
        # 2, 6, 10, every 4
        if line_num < stacklines
            sz = line.length
            for i in (2..sz).step(4) do
                idx = (i - 2) / 4
                # puts "appending #{line[i-1]} to #{idx}"
                letter = line[i-1]
                if letter != ' '
                    (stacks[idx] ||= []) << letter
                end
            end
        elsif line_num == stacklines
            # do this once
            for i in (0..stackwidth-1) do
                stacks[i] = stacks[i].reverse
            end
        elsif line_num < stacklines + 2
            # no op
        else
            # reading movements
            # puts line
            matches = line.match(/move (\d+) from (\d+) to (\d+)/)
            count = matches[1].to_i
            start = matches[2].to_i
            target = matches[3].to_i
            if problem == 1
                blocks = stacks[start-1].pop(count).reverse
            else
                blocks = stacks[start-1].pop(count)
            end
            puts "moving #{blocks} from #{start} to #{target}"
            stacks[target-1].concat(blocks)
        end
    end

    for i in (0..stackwidth-1) do
        puts stacks[i].last
    end
end

main()