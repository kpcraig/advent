# Mix.install([
#   {:arrays, "~> 2.1"}
# ])

# # require Arrays

[swidth, sloop] = System.argv
{width, _} = Integer.parse(swidth)
loop = sloop == "true"

# width = 135
# width = 10

defmodule Helpers do
def get_neighbors(ix, wd) do
  row = floor(ix/wd)
  nup = [ix - wd - 1, ix - wd, ix - wd + 1]
  nsame = [ix - 1, ix + 1]
  ndown = [ix + wd - 1, ix + wd, ix + wd + 1]

  nup = Enum.filter(nup, fn nb -> nb >= 0 and row - floor(nb/wd) == 1 end)
  nsame = Enum.filter(nsame, fn nb -> nb >= 0 and row == floor(nb/wd) end)
  ndown = Enum.filter(ndown, fn nb -> nb >= 0 and floor(nb/wd) - row == 1 end)

  nup ++ nsame ++ ndown
end

def count_neighbors(ls, _idx, ns) do

    Enum.filter(ls, fn elem -> Enum.member?(ns, elem[:index]) end)
      |> Enum.filter(fn elem -> elem[:value] > 0 end)
      |> Enum.count()
  # end
end

def clear_rolls(ls, count, loop) do
  ils = Enum.map(ls, fn e -> Map.replace(e, :ncount, count_neighbors(ls, e[:index], e[:neighbors])) end)
    |> Enum.map(fn e -> if e[:ncount] < 4 and e[:value] > 0 do Map.replace(e, :value, -1) else e end end)

  icount = Enum.filter(ils, fn e -> e[:value] == -1 end)
    |> Enum.count()


  cond do
    not loop ->
      icount
    icount == count ->
      count
    true ->
      clear_rolls(ils, icount, true)
  end
end

def pp(elem) do
  cond do
    # elem[:value] == 0 -> IO.write(".")
    # elem[:value] == -1 -> IO.write("x")
    # elem[:value] == 1 -> IO.write("@")
    true -> IO.write("!{#{elem[:value]}:#{elem[:ncount]}}")
  end
  # if elem[:value] == 0 do
  #   IO.write(".")
  # else
  #   if elem[:ncount] < 4 do
  #     IO.write(elem[:ncount])
  #   else
  #     IO.write(elem[:ncount])
  #   end
  # end
end
end

ls = IO.stream(:stdio, :line)
  #10 = \n, @ = 64
  # 1 if @, 0 otherwise, remove carriage returns
  |> Enum.flat_map(fn line -> Enum.map(Enum.filter(String.to_charlist(line), fn c -> c != 10 end), fn c -> if c == 64 do 1 else 0 end end) end)
  # expand to map with index and neighbor indicies
  |> Enum.with_index(fn element, index -> %{index: index, value: element, ncount: 0, neighbors: Helpers.get_neighbors(index, width)} end)

count = Helpers.clear_rolls(ls, 0, loop)
IO.puts(count)
