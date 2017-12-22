//&S-
//&T-
//&D-
/**
 * semtest5.p: test for program name
 */
test;

var aa : array 1 to 5 of integer; // 1D integer array , size=10
var a : array 1 to 10 of integer; // 1D integer array , size=10


fun2( a : array 1 to 5 of integer ): array 1 to 5 of integer; // valid function declaration -> func2 will be inserted to symbol table
begin
    var i : integer;
    i := 1;
    while i <= 5 do
        a[i] := i*i;
    end do
    
    return i;        // error, return an array
end
end fun2

fun( a : array 1 to 5 of integer ): integer; // valid function declaration -> func2 will be inserted to symbol table
begin
    var i : real;
    i := 1;
    
    return aa;        // error, return an array
end
end fun

begin
    fun2(aa);
end
end test
