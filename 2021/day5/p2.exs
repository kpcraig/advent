file = "input"

# {:ok, lineRex} = Regex.compile("(\d+),(\d+) -> (\d+),(\d+)")

{:ok, text} = File.read(file)
lines = String.split(text, "\n", trim: true)

Enum.flat_map(lines, fn line ->
  [_, a, b, c, d] = Regex.run(~r/(\d+),(\d+) -> (\d+),(\d+)/, line)
  Enum.map([a,b,c,d], fn e -> String.to_integer(e) end)
end)
|> Enum.chunk_every(2) # group in pairs
|> Enum.chunk_every(2) # group the pairs into pairs
|> Enum.flat_map(fn pair ->
  # expand pairs to their whole line
  [[x1, y1], [x2,y2]] = pair
  cond do
    # vertical
    x1 == x2 ->
      for y <- min(y1,y2)..max(y1,y2) do
        {x1,y}
      end
    # horizontal
    y1 == y2 ->
      for x <- min(x1,x2)..max(x1,x2) do
        {x,y1}
      end
    # because we put the smaller x first, it is always increasing
    # oh man does it not matter?
    true ->
      # for x <- x1..x2,y <- y1..y2 do
      #   [x,y]
      # end
      xs = for x <- x1..x2, do: x
      ys = for y <- y1..y2, do: y
      Enum.zip(xs,ys)
  end
end)
|> IO.inspect(label: "points")
|> Enum.frequencies()
|> IO.inspect(label: "counts")
|> Enum.count(fn k ->
  {_,c} = k
  c > 1
end)
|> IO.inspect(label: "multiple")
