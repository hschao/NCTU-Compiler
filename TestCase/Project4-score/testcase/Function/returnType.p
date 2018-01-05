//&S-
//&T-
//&D-
returnType;

func(a: integer; b: real; c: string; d: boolean);
begin
    return 7;       // error
end
end func

fun() : integer;
begin
    return -3.1;    // error
end
end fun

g() : boolean;
begin
    return 0;       // error
end
end g

hoy(strs: array 1 to 10 of string) : string;     
begin
    return strs;    // error
end
end hoy

pow(base: real; index: real): real;
begin
    return 1;       // error (no type coercion)
end
end pow

begin
end
end returnType
