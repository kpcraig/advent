file = "input"

# {:ok, lineRex} = Regex.compile("(\d+),(\d+) -> (\d+),(\d+)")

{:ok, text} = File.read(file)
lines = String.split(text, "\n", trim: true)

Enum.flat_map(lines, fn line ->
  [_, a, b, c, d] = Regex.run(~r/(\d+),(\d+) -> (\d+),(\d+)/, line)
  Enum.map([a,b,c,d], fn e -> String.to_integer(e) end)
  # [x1,y1,x2,y2]
end)
|> IO.inspect(label: "lol")
|> Enum.chunk_every(2) # group in pairs
|> IO.inspect(label: "lol")
|> Enum.chunk_every(2) # group the pairs into pairs
|> IO.inspect(label: "lol")
|> Enum.filter(fn pair ->
  [[x1, y1], [x2,y2]] = pair
  x1 == x2 or y1 == y2
end)
|> IO.inspect(label: "straight only")
|> Enum.flat_map(fn pair ->
  # expand pairs to their whole line
  [[x1, y1], [x2,y2]] = pair
  cond do
    x1 == x2 ->
      for y <- min(y1,y2)..max(y1,y2) do
        [x1,y]
      end
    y1 == y2 ->
      for x <- min(x1,x2)..max(x1,x2) do
        [x,y1]
      end
  end
end)
|> IO.inspect(label: "points")
|> Enum.frequencies()
|> IO.inspect(label: "counts")
|> Enum.count(fn k ->
  {_,c} = k
  c > 1
end)
# |> Enum.filter(fn point ->
#   %{key, value} = point
#   value == 2
# end)
|> IO.inspect(label: "multiple")
