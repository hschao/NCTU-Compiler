//&S-
//&T-
//&D-
assignment;

hoy(verbose: boolean; strs: array 99 to 100 of string) : string;
begin
    var i : 10;
    var b : boolean;
    verbose := strs[99];                // error
    b := (i > 10);                      // ok
    return "HOY!!";
end
end hoy

fun(r: real) : integer;
begin
    var v: array 10 to 11 of array 4 to 5 of real;
    var p: 1.7;
    p := 2.4;                           // error
    r := v[4][5];                       // ok
    return -3;
end
end fun

begin
    var strs: array 99 to 100 of string;
    var strss: string;
    strss := hoy(true, strs) + "!!!";   // ok
end
end assignment
