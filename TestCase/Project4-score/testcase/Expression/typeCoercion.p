//&S-
//&T-
//&D-
typeCoercion;

fun(r: real) : real;
begin
    var a: real;
    var b: integer;
    a := (2 + (3 * (r - 1))) / 1;       // ok
    a := b;                             // ok
    return 3.1;
end
end fun

fun2(r: integer) : integer;
begin
    return -3;
end
end fun2

begin
    var c: integer;
    c := (1 + false);                   // error
    fun(fun2(0));                       // ok
end
end typeCoercion
