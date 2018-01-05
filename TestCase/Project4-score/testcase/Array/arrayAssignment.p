//&S-
//&T-
//&D-
arrayAssignment;
var v: array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of boolean;

hoy(verbose: boolean; strs, strss: array 99 to 100 of string) : string;
begin
    strs := strss;                  // error
    return "HOY!!";
end
end hoy

fun() : integer;
begin
    var v: array 10 to 11 of array 4 to 5 of real;
    v[10] := v[11];                 // error
    return -3;
end
end fun

resetArr(arr: array 1 to 1000 of array 1 to 1000 of array 1 to 1000 of integer);
begin
    arr[1][1] := arr[0][0];         // error
end
end resetArr

begin
    v[1][1][1][1] := v[1][2][1][1]; // error
end
end arrayAssignment
