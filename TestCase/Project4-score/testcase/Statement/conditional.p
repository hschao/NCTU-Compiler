//&S-
//&T-
//&D-
conditional;
var v: array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of boolean;

hoy(verbose: boolean; strs, strss: array 99 to 100 of string) : string;
begin
    if not verbose then                 // ok
        return "HOY!!";
    end if

    if true then                        // ok
        if strss[99] then               // error
            print strss[99];
        end if
    end if

    return "HEY!!";
end
end hoy

fun() : integer;
begin
    var v: array 10 to 11 of array 4 to 5 of real;
    if v[10][4] <> 1.0 then             // ok
    else
        if -v then                      // error
            // v[10][5] := 1.0;
        else
            // v[10][5] := 0.0;
        end if
    end if
    return -3;
end
end fun

begin
    var i : boolean;
    while true do
        if i mod 2 then                 // error
            // i := i - 1;
        end if
        if (false or v[1][1][1][1][1][1][1]) and v[1] then  // error
            // i := 100;
        end if
    end do
end
end conditional
