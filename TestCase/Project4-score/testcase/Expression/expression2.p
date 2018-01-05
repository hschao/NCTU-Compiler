//&S-
//&T-
//&D-
expression2;
var v: array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of boolean;

hoy(verbose: boolean; strs, strss: array 99 to 100 of string) : string;
begin
    var b : boolean;
    strs[99] := strss[99] or verbose;   // error
    b := not((not verbose));            // ok
    b := (b = verbose);                 // error
    return "HOY!!";
end
end hoy

fun() : integer;
begin
    var v: array 1 to 2 of array 4 to 5 of real;
    var a: real;
    a := (a >= 1.0) / v[1][5];          // error
    a := (0.1 * (a <= 0.0));            // error
    return -3;
end
end fun

begin
    v[1][1][1][1][1][1][1] := (-v[1][1][1][1][1][1][1]) and v[1][1][1][1][1][1][1]; // error
end
end expression2
