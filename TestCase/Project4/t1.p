//&S-
//&T-
//&D-
/**
 * semtest5.p: test for program name
 */
test;

var aa : array 1 to 5 of integer; // 1D integer array , size=10
var ccc : array 1 to 10 of integer; // 1D integer array , size=10

var b : "123456";
var c : 77;
var d : 36.4546;

fun2( a : array 1 to 5 of integer ): integer; // valid function declaration -> func2 will be inserted to symbol table
begin
    var i : integer;
    i := 1;
    while i <= 5 do
        a[i] := i*i;
    end do
    
  for fff:=1 to 10 do
    begin
    return test;        // error, return an array
    return fun2;        // error, return an array
    return a;        // error, return an array
    return i;        // error, return an array
    return ccc;        // error, return an array
    return fff;
    return b;
    return c;
    return d;
    return d[0];
    return notExist;
    end
    end do
end
end fun2

fun( a : array 1 to 5 of integer ): real; // valid function declaration -> func2 will be inserted to symbol table
begin
    var i : real;
    i := 1;
    
    return d;        // error, return an array
end
end fun

begin
    fun2(aa);
end
end test
