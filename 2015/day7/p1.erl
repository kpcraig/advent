-module(p1).
-export([main/0]).

main() ->
  {ok, IoDevice} = file:open("input", [read]),
	Circuits = dict:new(),
  read_text(Circuits, IoDevice),
  file:close(IoDevice).

read_text(Circuits, IoDevice) ->
  case file:read_line(IoDevice) of
    {ok, Line} -> read_text(handle(Circuits, string:tokens(Line," \n")), IoDevice);
    eof        -> dict:map( fun(K,V) -> io:format("~p -> ~p~n", [K,V]) end, Circuits)
  end.

handle(Circuits, Parts) ->
  case length(Parts) of
		3 -> assign(Circuits, Parts);
		4 -> negate(Circuits, Parts);
		5 -> biadic(Circuits, Parts)
	end.

assign(Circuits, [Val, "->", Targ]) ->
	V = get_value(Val, Circuits),
	io:format("Assigning ~w to ~w~n", [V, Targ]),
	dict:store(Targ, V, Circuits).
	% io:format("~s~n", [Targ]).

negate(Circuits, ["NOT", Val, "->", Targ]) ->
	V = get_value(Val, Circuits),
	io:format("Inverting ~w into ~w~n", [V, Targ]),
	dict:store(Targ, bnot V, Circuits).
	% io:format("~s~n", [Targ]).

biadic(Circuits, [V1, Op, V2, "->", Targ]) ->
	A = get_value(V1, Circuits),
	B = get_value(V2, Circuits),
	io:format("~w ~s ~w into ~w~n", [A, Op, B, Targ]),
	case Op of
		"AND" -> dict:store(Targ, A band B, Circuits);
		"OR" -> dict:store(Targ, A bor B, Circuits);
		"LSHIFT" -> dict:store(Targ, A bsl B, Circuits);
		"RSHIFT" -> dict:store(Targ, A bsr B, Circuits)
	end.

get_value(Symbol, Circuits) ->
	% io:format("Fetching ~s~n", [Symbol]),
	A = string:to_integer(Symbol),
	case A of
		{error, no_integer} ->
			case dict:find(Symbol, Circuits) of
				error -> 0;
				_ -> dict:fetch(Symbol, Circuits)
			end;
		{N,_} -> N
	end.
