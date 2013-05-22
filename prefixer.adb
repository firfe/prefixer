--======================================================================================================
with Ada.Text_IO, Ada.Integer_Text_IO, ada.float_text_io, Ada.Command_Line;
use  Ada.Text_IO, Ada.Integer_Text_IO, ada.float_text_io, Ada.Command_Line;
--======================================================================================================
Procedure Prefixer is
Type Node_Type;
Type Node_Ptr is access Node_Type;
type Node_Type is 
record
      Data        : Integer;
      Left_Child  : Node_Ptr;
      Right_Child : Node_Ptr;
end record;
Value : integer;
Root : Node_Ptr;
Exception_Paranthesis, Exception_Missing_Number : Exception; 
Input: File_Type;
Given_String : String := Argument(1);
Expression_String : string := "                                                             ";
File_Size : Integer;
Count0 : integer := 0;

--======================================================================================================
Procedure Get_Info is -- This retrieves the file data and assigns it to Expression_String;
file : File_Type;
length : Natural;
line   : String(1..1024); 

begin
   Open(file, in_file, Given_String);
   while not End_Of_File(file) loop
      Get_Line(file, line, length);
   end loop;
   Close(file);
   For i in 1..length loop
	Expression_String(i) := line(i);
   end loop;
   File_Size := length;
end;
--=======================================================================================================
Function Check_Integer_Variable (Position : Integer) return boolean is -- check if it is a character or an integer
a : integer := Position;
	begin
		if character'pos(expression_string(a)) > 47 AND character'pos(expression_string(a)) < 58 then
			return true;
		elsif character'pos(expression_string(a)) > 64 AND character'pos(expression_string(a)) < 91 then
			return true;
		elsif character'pos(expression_string(a)) > 96 AND character'pos(expression_string(a)) < 123 then
			return true;
		else
			return false;
		end if;
	End Check_Integer_Variable;
--=========================================================================================================
Function Evaluate_Expression (Operand1, Operand2 : integer; Operator : character) return integer is -- Used to evaluate the expression
	Begin

			if operator = '+' then
				return operand1 + operand2;
			elsif Operator = '-' then
				return operand1 - operand2;
			elsif Operator = '/' then
				return operand1 / operand2;
			elsif Operator = '*' then
				return operand1 * operand2;
			elsif Operator = '^' then
				return operand1 ** operand2;
			end if;
	return 0;
	end Evaluate_Expression;
--=========================================================================================================
Function Evaluate (Node : Node_Ptr) return integer is -- Returns what the expression equals to (note: only works if there are no characters in the expression)
	Operand1, Operand2 : integer;
	Operator : character;
	Begin
		if Node.Left_Child = null and Node.Right_Child = null then
			return integer'val(Node.Data)-48;
		else
			operator := character'val(Node.Data);
			Operand1 := Evaluate(Node.Left_Child);
			Operand2 := Evaluate(Node.Right_Child);
			return Evaluate_Expression(Operand1, Operand2, Operator);
		end if;
	end Evaluate;
--=========================================================================================================
Function Check_Character (Expression_String : String) return boolean is -- Check if there is a single character in the expression
	Begin
		For i in 1..File_Size loop
			if character'pos(expression_string(i)) > 96 AND character'pos(expression_string(i)) < 123 then
				Return True;
			end if;
		end loop;
		return False;
	end Check_Character;
--=========================================================================================================
Function Check_No_Expression (Expression_String : String) return boolean is -- Checks if no expression is given
	Begin
		for i in 1..Expression_String'length loop
			if Expression_String(i) = '^' or Expression_String(i) = '*' or Expression_String(i) = '-' or Expression_String(i) = '/' or Expression_String(i) = '+' then
				Return False;
			end if;
		end loop;
		return true;
	end Check_No_Expression;
--==========================================================================================================
Function Check_Paranthesis (Expression_String : String) return boolean is -- Checks if there are no open paranthesis in the expression
	Count1 : integer := 0;
	Count2 : Integer := 0;
	Begin
		for i in 1..Expression_String'length loop
			if Expression_String(i) = '(' then
				count1 := count1 +1;
			elsif Expression_String(i) = ')' then
				count2 := count2 +1;
			end if;
		end loop;
		if count1 = count2 then
			return false;
		end if;
		return true;
	end Check_Paranthesis;
--==========================================================================================================
  function Create_Node(Data : integer; Left_Child, Right_Child : Node_Ptr) return Node_Ptr is -- Creates a node
   begin
      return new Node_Type'(Data, Left_Child, Right_Child);
   end Create_Node;
--==========================================================================================================
Function Construct_ExpressionTree (Expression_String : String; First, Last : Natural) return Node_Ptr is -- Constructs the Tree
	count1 : integer := 0;
	count2 : integer := 0;
	count3 : integer := First;
	Position_Root : integer;
	temp:node_ptr:=null;
	Begin
		For i in First..Last loop -- First loop used to create a node for a operation without paranthesis
			if expression_string(i) = '(' then
				count1 := count1+1;
			elsif expression_string(i) = ')' then
				count2 := count2+1;
			end if; 

			if Count1-Count2 = 0 then
				if Expression_String(i) = '+' OR Expression_String(i) = '-' then
					Position_Root := i;
					Return Create_Node(character'pos(Expression_String(Position_Root)), Construct_ExpressionTree(Expression_String,First,Position_Root-2), Construct_ExpressionTree(Expression_String,Position_Root+2,Last));
				end if;
			end if;
		end loop;

		For i in First..Last loop -- First loop used to create a node for a operation without paranthesis
			if expression_string(i) = '(' then
				count1 := count1+1;
			elsif expression_string(i) = ')' then
				count2 := count2+1;
			end if; 

			if Count1-Count2 = 0 then
				if Expression_String(i) = '*' OR Expression_String(i) = '/' OR Expression_String(i) = '^' then
					Position_Root := i;
					Return Create_Node(character'pos(Expression_String(Position_Root)), Construct_ExpressionTree(Expression_String,First,Position_Root-2), Construct_ExpressionTree(Expression_String,Position_Root+2,Last));
				end if;
			end if;
		end loop;
	
		For i in First..Last loop -- Second loop used to create a node for a operation with paranthesis (only used if there are no operations not surronded by paranthesis)
			if expression_string(i) = '(' then
				count1 := count1+1;
			elsif expression_string(i) = ')' then
				count2 := count2+1;
			end if; 

			if Count1-Count2 /= 0 then
				if Expression_String(i) = '+' OR Expression_String(i) = '-' then
					Position_Root := i;
					Return Create_Node(character'pos(Expression_String(Position_Root)), Construct_ExpressionTree(Expression_String,First,Position_Root-2), Construct_ExpressionTree(Expression_String,Position_Root+2,Last));
				end if;
			end if;
		end loop;

		For i in First..Last loop -- Second loop used to create a node for a operation with paranthesis (only used if there are no operations not surronded by paranthesis)
			if expression_string(i) = '(' then
				count1 := count1+1;
			elsif expression_string(i) = ')' then
				count2 := count2+1;
			end if; 

			if Count1-Count2 /= 0 then
				if Expression_String(i) = '*' OR Expression_String(i) = '/' OR Expression_String(i) = '^' then
					Position_Root := i;
					Return Create_Node(character'pos(Expression_String(Position_Root)), Construct_ExpressionTree(Expression_String,First,Position_Root-2), Construct_ExpressionTree(Expression_String,Position_Root+2,Last));
				end if;
			end if;
		end loop;

		For a in First..Last loop
			if Check_Integer_Variable(a) = True then			
				Return Create_Node(character'pos(Expression_String(a)), null, null);
			end if;
		end loop;

		raise Exception_Missing_Number;
	end Construct_ExpressionTree;
--==========================================================================================================
Procedure Find_Root (Expression_String : String; First, Last : Natural) is -- Finds the root and sets it at the top of the tree
	count1 : integer := 0;
	count2 : integer := 0;
	Position_Root : integer; 
	done : boolean := false;
	Begin

		For i in First..Last loop -- First loop used check if the root is a + or a -
			if expression_string(i) = '(' then
				count1 := count1+1;
	       		elsif expression_string(i) = ')' then
				count2 := count2+1;
			end if;
			if Count1-Count2 = 0 then
				if Expression_String(i) = '+' OR Expression_String(i) = '-' then
					Position_Root := i;
					done := true;
					Root := Create_Node(character'pos(Expression_String(Position_Root)), Construct_ExpressionTree(Expression_String,First,Position_Root-2), Construct_ExpressionTree(Expression_String,Position_Root+2,Last));
				end if;
			end if;
		end loop;

		if done = false then -- Second loop to check if the root is a * or / if a + or - is not found
			For i in First..Last loop
				if expression_string(i) = '(' then
					count1 := count1+1;
	        		elsif expression_string(i) = ')' then
					count2 := count2+1;
				end if;
				if Count1-Count2 = 0 then
					if Expression_String(i) = '*' OR Expression_String(i) = '/' OR Expression_string(i) = '^' then
						Position_Root := i;
						Root := Create_Node(character'pos(Expression_String(Position_Root)), Construct_ExpressionTree(Expression_String,First,Position_Root-2), Construct_ExpressionTree(Expression_String,Position_Root+2,Last));
					end if;
				end if;
			end loop;
		end if;
end Find_Root;
--=========================================================================================================
 Procedure Prefix_Right_Notation (Node : Node_Ptr);
 Procedure Prefix_Left_Notation (Node : Node_Ptr);
--=========================================================================================================
 Procedure Prefix_Root_Notation (Node : Node_Ptr) is -- This starts off reading the expression tree from the root node
	Begin
		if Node.Left_Child /= null AND Node.Right_Child /= null then
			Put("(");
		end if;
		Put(character'val(Node.Data));
		Put(' ');
		if Node.Left_Child /= null then
			Prefix_Left_Notation(Node.Left_Child);
		end if;
		for i in 1..count0-1 loop
			put(")");
		end loop;
		count0 := 0;
		if Node.Right_Child /= null then
			Prefix_Right_Notation(Node.Right_Child);
		end if;	
		for i in 1..count0-1 loop
			put(")");
		end loop;
	end Prefix_Root_Notation;
--=========================================================================================================
   Procedure Prefix_Left_Notation (Node : Node_Ptr) is -- this is used when traversing down the left child
	Begin

		if Node.Left_Child /= null AND Node.Right_Child /= null then
			Put("(");
		end if;
		Put(character'val(Node.Data));
		Put(' ');
		if Node.Left_Child /= null then
			Prefix_Left_Notation(Node.Left_Child);
		end if;
		if Node.Right_Child /= null then
			Prefix_Right_Notation(Node.Right_Child);
		end if;	
	end Prefix_Left_Notation;
--=========================================================================================================
   Procedure Prefix_Right_Notation (Node : Node_Ptr) is -- this is used when traversing down the right child
	Begin
		if Node.Left_Child /= null AND Node.Right_Child /= null then
		Put("(");
		end if;
		Put(character'val(Node.Data));
		Put(' ');
		if Node.Right_Child = null AND Node.Left_Child = null then
		Put(")");
		end if;
		if Node.Left_Child /= null then
			Prefix_Left_Notation(Node.Left_Child);
		end if;
		if Node.Right_Child /= null then
			Prefix_Right_Notation(Node.Right_Child);
		end if;	
	end Prefix_Right_Notation;
--=========================================================================================================
Begin	
	Get_Info;
	If Check_Paranthesis(Expression_String) = false then
	   if Check_No_Expression(Expression_String) = False then 
		Find_Root(Expression_String, 1, Expression_String'length);
		Put("Given Notation: ");
		Put(Expression_String);
		New_line;
		Put("Prefix Notation: ");
		Prefix_Root_Notation(root);
		New_line;
		if Check_Character(Expression_String) = False then
			Put("Value:");
			Value := Evaluate(root);
			Put(Value,1);
		end if;
	   else
		for i in 1..Expression_string'length loop
			Put(expression_string(i));
		end loop;
	   end if;
	else
		raise Exception_Paranthesis;
	end if;
exception
	when constraint_error =>
		put_line ("Something wrong happened, please check if input is valid");
	when Exception_Paranthesis =>
		put_line ("The number of ( paranthesis and ) paranthesis must be the same");
	when Exception_Missing_Number =>
		put_line ("There is a missing number in your operation");
end Prefixer;
