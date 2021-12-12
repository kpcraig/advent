with Ada.Containers.Vectors;
with Ada.Text_IO, Ada.Integer_Text_IO; use Ada.Text_IO;

procedure P2 is
    package Integer_Vectors is new Ada.Containers.Vectors
        (Index_Type => Natural,
         Element_Type => Integer);

    use Integer_Vectors;

	Input: File_Type;
    RollingSet : Vector;
    Previous : Integer := 0;
    Current : Integer := 0;
    Value : Integer := 0;
    Answer : Integer := 0;
begin
	Ada.Text_IO.Open(File=>Input, Mode=>In_File, Name => "input");
    -- Grab the first three numbers
    Value := Integer'Value(Get_Line(Input));
    RollingSet.Append(Value);
    
    Value := Integer'Value(Get_Line(Input));
    RollingSet.Append(Value);
    
    Value := Integer'Value(Get_Line(Input));
    RollingSet.Append(Value);

    Previous := RollingSet (0) + RollingSet (1) + RollingSet (2);
    Current := Previous;
    Ada.Integer_Text_IO.Put(Previous);

    while not End_Of_File(Input) loop
        Value := Integer'Value(Get_Line(Input));
        Current := Current - RollingSet (0) + Value;
        -- Ada.Integer_Text_IO.Put(Current);
        RollingSet.Delete (0);
        RollingSet.Append(Value);
        
        if Current > Previous then
            Answer := Answer + 1;
        end if;
        Previous := Current;
    end loop;

    Ada.Integer_Text_IO.Put(Answer);
	Close(Input);
exception
	when End_Error =>
		if Is_Open(Input) then
			Close(Input);
		end if;
end P2;
