//&S-
//&T-
//&D-
whileloop;
var v: array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of boolean;

hoy(verbose: boolean; strs, strss: array 99 to 100 of string) : string;
begin
    while not verbose do                    // ok
        return "HOY!!";
    end do

    while strss[99] do                      // error
        print strss[99];
        return "HEY!!";
    end do
end
end hoy

fun() : integer;
begin
    var v: array 10 to 11 of array 4 to 5 of real;
    while v[10][4] > 1.0 do                 // ok
    end do

    while -v[10][5] + v[10][4] do           // error
        v[10][5] := 1.0;
    end do
    return -3;
end
end fun

resetArr(arr: array 1 to 1000 of integer);
begin
    var i: integer;
    i := 0;
    while (arr[i] <> 0) and (i < 1000) do   // ok
        arr[i] := 0;
        i := i + 1;
    end do
end
end resetArr

begin
    var i : 2;
    while false do
        while i mod 2 do                    // error
            // i := i - 1;
        end do
        while (false) or v[1][1][1][1][1][1][1] do  // ok
            // i := 100;
        end do
    end do
end
end whileloop
