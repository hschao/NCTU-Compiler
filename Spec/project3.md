# Project3 Specification
Check course website for homework description.
http://people.cs.nctu.edu.tw/~ypyou/courses/Compiler-f17/
 
## 上傳(Upload)
Create a directory, named 「YourID」 and store all files of the assignment under the directory. 
Zip the directory as a single archive named as 「YourID.zip」, then upload the file.
 
You should submit the following items: 
• Report: a text file describing the abilities of your parser, the platform to run your parser, and how to run your parser 
                (plz submit pure text file like markdown, txt, or any format we can open in text editor for the sake of convenience)
• Your yacc, lex, and c source files for your parser
• Makefile: ( simply a "make" command to create the paser, and the name of execute file should be "parser")
(*Don't submit files outside the above.don't submit git files, CMakeLists.txt, execute files and test files *)
 
## ﻿Penalty 
The penalty for late homework is 15 per day (weekends count as 1 day). 
Late homework will not be accepted after sample codes have been posted. 
In addition, if I detect what I consider to be intentional plagiarism in any assignment, the assignment will receive reduced or, usually, zero credit
 
## After Upload
Some of project2 files are still not fit to our format, please correct it this time.
If your submission can't be uncompressed, compiled or the program works strangely, we no longer give you any points.
As a result, you must check your file can work on the CSCC linux platform. 
You can check if following command can work for your assignment uploaded
 
```bash
unzip <YourID>.zip
cd <YourID>
make
./parser \<input file\>
```

-------------------------------------------------------------------------------

1. In this project, we only test symbol table dump and a sematic error: <Redeclaration>.

    The only error msg: "<Error> found in Line n: symbol x is redeclared"
                                  or "<Error> found in Line n: symbol 'x' is redeclared"

2. About array type management, the indexs are always positive integers and the former is smaller than the latter.

     e.g. [array -10 to 10] and [array 10 to -10] will not be tested.

3. Error msg and symbol table format should be identical, you can find them in spec or at the bottom here.

4. Output order of symtab is not mandatory but expexted being the same.


## Project3 symbol table - Examples release

- Examples : example test code

- Answers : Relevant answer output of Examples


Welcome to course forum to discuss or ask about assignment. http://sslab.cs.nctu.edu.tw/forum/


## EDIT

### There is the the code for error message:
```
printf( "<Error> found in Line %d: symbol '%s' is redeclared\n", linenum, symbol );
```
### There is the code for print symtab:
```
void dumpsymbol()
{
    int i;
    for(i=0;i< 110;i++) {
        printf("=");
    }
    printf("\n");
    printf("%-33s%-11s%-11s%-17s%-11s\n","Name","Kind","Level","Type","Attribute");
    for(i=0;i< 110;i++) {
        printf("-");
    }
    printf("\n");
    printf("%-33s", "func");
    printf("%-11s", "function");
    printf("%d%-10s", 0,"(global)");
    printf("%-17s", "boolean");
    printf("%-11s", "integer, real [2][3]");
    printf("\n");
    for(i=0;i< 110;i++) {
        printf("-");
    }
    printf("\n");
}
```