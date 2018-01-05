//&S-
//&T-
//&D-
arrayRef;
var v: array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of boolean;

hoy(verbose: boolean; strs, strss: array 99 to 100 of string) : string;
begin
    verbose := v[1][1][1][1][1][true][1];   // error
    return strs[99.0];                      // error
end
end hoy

fun() : integer;
begin
    var v: array 4 to 5 of real;
    v["4"] := v[5] - 1.0;                   // error
    return -3;
end
end fun

resetArr(arr: array 1 to 1000 of integer);
begin
    var i: integer;
    arr[i] := 0;                            // ok
end
end resetArr

begin
    var v: array 1 to 2 of array 1 to 1000 of integer;
    resetArr(v[1]);                         // ok
end
end arrayRef
