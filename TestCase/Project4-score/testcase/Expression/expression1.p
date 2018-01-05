//&S-
//&T-
//&D-
expression1;

hoy(verbose: boolean; strs, strss: array 99 to 100 of string) : string;
begin
    var strsss: string;
    strsss := "QQ" + strss[99];         // ok
    strsss := strsss * strsss;          // error
    return "HOY!!";
end
end hoy

fun() : integer;
begin
    var v: array 1 to 2 of array 4 to 5 of real;
    var a: real;
    v[1][4] := v[1][5] / v[1];          // error
    a := ((-a) + 0.1) * (4.14 - 1.0);   // ok
    return -3;
end
end fun

resetArr(arr: array 1 to 1000 of integer);
begin
    var i: 1;
    arr[0] := ((i mod 2) * (arr[0])) / (3 mod i);   // ok
    arr[1] := false mod ((777 / 345));              // error
end
end resetArr

begin
end
end expression1
