defmodule Source do
	def loop(val, target) do
		receive do
			{:spark} -> send(target, {:spark, val})
			{:wire, name} -> loop(val, target)
		end
	end
end

defmodule Dyadic do
	def loop(op, val, sourceA, sourceB) do
		receive do
			{:sourcewire, source} -> loop(op, )
