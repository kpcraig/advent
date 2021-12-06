with Ada.Text_IO, Ada.Integer_Text_IO; use Ada.Text_IO;

procedure P1 is
	Input: File_Type;
    Previous : Integer := 0;
    Value : Integer := 0;
    Answer : Integer := 0;
begin
	Ada.Text_IO.Open(File=>Input, Mode=>In_File, Name => "input");
    -- just grab measurement one
    Previous := Integer'Value(Get_Line(Input));
    while not End_Of_File(Input) loop
        Value := Integer'Value(Get_Line(Input));
        if Value > Previous then
            Answer := Answer + 1;
        end if;
        Previous := Value;
    end loop;

    Ada.Integer_Text_IO.Put(Answer);
	Close(Input);
exception
	when End_Error =>
		if Is_Open(Input) then
			Close(Input);
		end if;
end P1;
