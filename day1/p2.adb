with Ada.Sequential_IO, Ada.Text_IO, Ada.Integer_Text_IO;

procedure P2 is
	package Char_IO is new Ada.Sequential_IO(Character);
	use Char_IO;
	Input: File_Type;
	Buffer : Character;
	Count : Integer := 0;
	Index : Natural := 0;
begin
	Open(File=>Input, Mode=>In_File, Name => "input");
	loop
		Read(File=>Input, Item =>Buffer);
		case Buffer is
			when '(' =>
				Count := Count + 1;
			when ')' =>
				Count := Count - 1;
			when others =>
				Count := Count;
			end case;
		Index := Index + 1;
		if Count = -1 then
			Ada.Integer_Text_IO.Put(Index);
			Ada.Text_IO.Put(":");
			Ada.Integer_Text_IO.Put(Count);
			Ada.Text_IO.New_Line(1);
		end if;
	end loop;
	Close(Input);
exception
	when End_Error =>
		if Is_Open(Input) then
			Close(Input);
		end if;
end P2;
