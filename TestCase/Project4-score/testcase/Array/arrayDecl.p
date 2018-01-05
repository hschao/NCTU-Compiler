//&S-
//&T-
//&D-
arrayDecl;
var v: array 1 to 2 of array 1 to 2 of array 1 to 2 of array 1 to 2 of array 2 to 1 of array 1 to 2 of array 1 to 2 of boolean;  // error

hoy(verbose: boolean; strs, strss: array 99 to 99 of string) : string;  // error
begin
    return "HOY!!";
end
end hoy

fun() : integer;
begin
    var v: array 5 to 4 of real;  // error
    return -3;
end
end fun

begin
    var v: array 1 to 2 of array 9000 to 9000 of integer;  // error
end
end arrayDecl
