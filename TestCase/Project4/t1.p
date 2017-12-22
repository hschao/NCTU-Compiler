//&S-
//&T-
//&D+
/**
 * semtest5.p: test for program name
 */
test;

var aa,bd,ddd : array 7 to 5 of array 1 to 5 of array 1 to 5 of integer; // 1D integer array , size=10
var aa : real;
var c : 123;

fun2( a : array 1 to 5 of integer ): array 8 to 5 of integer; // valid function declaration -> func2 will be inserted to symbol table
begin
    var i : array 8 to 17 of integer;
    i[test] := i[5];
    i[fun2] := i[5.0];
    i[i] := i["111"];
    i[a[0]] := i["111"];
    i[7] := i[c];
    i := 1;
    while i <= 5.0 do
        a[i] := i*i;
    end do
    
    return i;        // error, return an array
end
end funk

begin
    fun2(aa);
    return aa;
    fun(a);
    test();
end
end test
