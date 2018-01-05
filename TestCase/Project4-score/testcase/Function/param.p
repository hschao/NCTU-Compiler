//&S-
//&T-
//&D-
param;

var a: real;
var b: integer;
var c: boolean;
var d: string;
var va: array 1 to 9000 of real;
var vb: array 1 to 9000 of integer;
var vc: array 1 to 9000 of boolean;
var vd: array 1 to 9000 of string;

func(a: integer; b: real; c: string; d: boolean);
begin

end
end func

fun() : integer;
begin
    var a, b: integer;
    func(a, b, d, c);               // ok!!
    return 0;
end
end fun

g() : boolean; 
begin
    var c, d: string;
    func(fun(), a, c, d);           // error
    return false;
end
end g

hoy(strs: array 1 to 10 of string) : string;     
begin
    func(vb, a, d, c);              // error
    return "HOY!!";
end
end hoy

pow(base: real; index: real): real;
begin
    func(b, index, vd[9487]);       // error
    return 1.0;
end
end pow

ginntama();
begin
    hoy(vd);                        // error
end
end ginntama


begin
    ginntama(0);                    // error
end
end param
