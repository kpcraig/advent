-- with Ada.Sequential_IO, Ada.Text_IO, Ada.Integer_Text_IO;
with Ada.Text_IO, Ada.Strings.Fixed, Ada.Integer_Text_IO;

procedure P1 is
	Count : Integer := 0;
	Click : Integer := 0;
	Index : Integer := 50;
	Index_Next : Integer := 0;
begin
	-- Open(File=>Input, Mode=>In_File, Name => "sample");
	loop
		declare
			Buffer : String := Ada.Text_IO.Get_Line(Ada.Text_IO.Standard_Input);
			Move : Integer := Integer'Value(Ada.Strings.Fixed.Tail(Buffer, Buffer'Length - 1));
			Cast : Integer := 0;
		begin
			if Buffer'Length < 2 then
				Ada.Text_IO.Put("Count: ");
				Ada.Integer_Text_IO.Put(Count);
				Ada.Text_IO.New_Line(1);
				return;
			end if;
			-- Ada.Text_IO.Put_Line(Buffer);
			if Buffer(Buffer'first) = 'L' then
				Ada.Text_IO.Put("Left");
				Move := Move * (-1);
			else
				Ada.Text_IO.Put("Right");
			end if;

			Ada.Integer_Text_IO.Put(Move);
			Ada.Text_IO.Put(":");
			
			Index_Next := Index + Move;
			-- One or more full spins
			Cast := abs (Index_Next / 100);
			Click := Click + Cast;
			-- if the signs changed, then add a click
			if Index * Index_Next < 0 then
				Click := Click + 1;
			end if;

			Index := Index_Next mod 100;
			if Index = 0 then
				Count := Count + 1;
				Click := Click + 1;
			end if;
			if Index_Next mod 100 = 0 and Index_Next /= 0 then
				Click := Click - 1;
			end if;
			Ada.Integer_Text_IO.Put(Index_Next);
			Ada.Integer_Text_IO.Put(Index);
			Ada.Integer_Text_IO.Put(Count);
			Ada.Integer_text_IO.Put(Click);
			Ada.Text_IO.New_Line(1);
		end;
	end loop;
exception
	when others =>
		Ada.Integer_Text_IO.Put(Count);
		Ada.Integer_Text_IO.Put(Click);
end P1;
