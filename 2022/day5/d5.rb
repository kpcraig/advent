# This one is kind of cheaty - you invoke it with 3 args, height of tallest stack, width of stacks, and 1 or 2 depending on part
def main
    problem = ARGV[1].to_i
    stacks_desc = Array.new
    stacks = Array.new
    state = :begin
    File.open(ARGV[0]).each_with_index do |line,line_num |
        if state == :begin
            sz = line.length
            if not line.include?('[')
                # this is the footer line
                stack_width = ((sz - 2) / 4) + 1
                stacks = Array.new(stack_width)
                state = :build
                next
            end
            stacks_desc << line

        elsif state == :build
            stacks_desc.each { |line|
                sz = line.length
                # 2, 6, 10, every 4
                (2..sz).step(4).each { |i|
                    idx = (i - 2) / 4
                    letter = line[i-1]
                    if letter != ' '
                        (stacks[idx] ||= []) << letter
                    end
                }
            }
            stacks.each_with_index { |stack, i|
                stacks[i] = stack.reverse
            }
            state = :move
        else # state == :move
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
            stacks[target-1].concat(blocks)
        end
    end

    result = ""

    stacks.each { |stack|
        result.concat(stack.last)
    }

    puts result
end

main()