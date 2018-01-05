//&S-
//&T-
//&D-
printRead;

var vc: array 1 to 9000 of boolean;

hoy(verbose: boolean; strs: array 99 to 100 of string) : string;
begin
    read strs;              // error
    print strs;             // error
    read verbose;           // ok
    print verbose;          // ok
    return "HOY!!";
end
end hoy

fun() : integer;
begin
    var v: array 4 to 5 of array 4 to 5 of real;
    read v[4];              // error
    print v[4];             // error
    read v[2][4];           // ok
    print v[2][4];          // ok
    return -3;
end
end fun

begin
    read vc;                // error
    print vc;               // error
end
end printRead
