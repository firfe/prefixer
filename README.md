This program works by first retrieving the information from an expression from a text file, for example "3 * x + 4 - (9 + y) / 4 ". After it retrieves this information the expression as a string to Expression_String, then this string is read and put into a tree based on the rules of Order of Operations. Then the information is retrieved from the tree in the order of prefix notation. If there are no characters in the expression it will also display the value of the expression.
Limitations of this program is that every single integer/character must have a empty space in front of or behind it.

To access the ADA files I use gedit.
So first go to the terminal and access the folder in which prefixer.adb is located afterwards use:
gnatmake prefixer (this compiles the program)

After it has successfully compiled put:
./prefixer (FILE_NAME)

This will then cause the program to run with the expression within (FILE_NAME).

Thank You!
-Ronald Choi
