//&D+
//&S+
//&T-
mytest1err;

var d: integer;
 
fun1(apple: array 1 to 4 of array 1 to 7 of integer) : integer;
begin
	var c: boolean;
	return apple[1][2];
end 
end fun1

fun(k: real; a, b: integer; e: boolean) : integer;
begin
	var c: boolean;
	return d;
end 
end fun1error // ERROR !!!!!------------------------

// fun1err(k: real; a, b: integer; e: boolean) : array 1 to 2 of integer; // ERROR !!!!!-------------------------
// begin
// 	var c: boolean;
// 	return d;
// end 
// end fun1err


begin
    var a, b, c : integer;
    var k : real;
    var d, e, f : boolean;
    var g, h, i : string;
    var con : 675777;
    var apple: array 1 to 2 of array 2 to 5 of array 1 to 7 of integer;
    var bpple: array 1 to 2 of integer;
    var apple1err: array 3 to 2 of integer; // ERROR !!!!!------------------------
    var apple1error: array 1 to 1 of integer; // ERROR !!!!!------------------------
    // var apple1errorrrr: array -1 to 1 of integer; // ERROR !!!!!------------------------
    
    fun1(apple[1]);
    fun1(apple); // ERROR !!!!!------------------------
    fun1(apple[1][2]); // ERROR !!!!!------------------------

    con := 1; // ERROR !!!!!------------------------
    print a;
    print a+b;
    print apple; //ERROR
    read a;
    read apple; // ERROR !!!!!------------------------
    read apple[1][2][3];

    a := 1 + bpple[1.1]; // error
    a := bpple + bpple; //error
    a := bpple[1] + bpple[2] + 1;
    apple[1][2][3] := bpple[1];

    for i := 2 to 2 do
    begin
       	var a : integer;
    end
    end do

    for i := 3 to 2 do // ERROR !!!!!------------------------
    begin
       	var a : integer;
    end
    end do

    for i := 0 to 2 do
    begin
       	var a : integer;
       	i := 100; // ERROR !!!!!------------------------
    end
    end do

    for i := 2 to 2 do
	    for j := 2 to 2 do
	    begin
       		i := 100; // ERROR !!!!!------------------------
       		j := 100; // ERROR !!!!!------------------------
	    end
	    end do
    end do

    while a > b do
    begin
       	var a : integer;
    end
    end do

    while not(a > b) do
    begin
       	var a : integer;
    end
    end do
    
    while 1 do // ERROR !!!!!------------------------
    begin
       	var a : integer;
    end
    end do    

    while 1.1 do // ERROR !!!!!------------------------
    begin
       	var a : integer;
    end
    end do

    if a > b then
    begin
       	var a : integer;
    end
    end if

    if not(a > b) then
    begin
       	var a : integer;
    end
    end if
    
    if 1 then // ERROR !!!!!----------------------
    begin
       	var a : integer;
    end
    end if    

    if 1.1 then // ERROR !!!!!----------------------
    begin
       	var a : integer;
    end
    end if
    
    a := 1 + 1.1; //error
    k := 1 + 1.1;
    k := 1 + true; //error
    k := 1 - 1.1;
    k := 1 - true; //error
    k := 1 * 1.1;
    k := 1 * true; //error
    k := 1 / 1.1;
    k := 1 / true; //error
    k := 1 + "ass"; //error
    g := g + "ass"; 
    g := "ass" + "hole";
    g := g + g;
    g := g + 1; //error
    b := 100;
    c := 25;
    a := b+c*c mod 17;            // ok
    a := 6 mod 17;            // ok
    a := 1.5 mod 17;            // error, not int
    a := 15 mod 1.7;            // error, not int
    a := b >= c*4;                // error, LHS=integer RHS=boolean
    e := b >= c*4;                // ok
    e := b >= 11.1;                 // error, not the same type
    e := b >= true;               // error, not real or int
    print a <> 11 ;               // ok
    d := e and f;
    a := e and f; //error
    d := a and f; //error
    d := k and f; //error
    d := not f;
    a := not f; //error
    f := not a; //error
   
    a := 1 + 2;
    a := 1.2 - 2; //error
    a := 2 / 2.2*2; //error
    a := 1 + true + 1; //error
    a := 1 + true + 1 + true + 1 + true + 1; //error
    k := 1 + 2;
    k := 1.2 - 2; 
    k := 2 / 2.2*2; 
    k := 1 + true + 1; //error
   
    g := "hello ";
    h := "world\n";
    i := g;                       // ok
    i := g+h;                     // ok, string concatenation
    i := g+e;                     // error, not both string type
    i := g*h;                     // error, we cannot perform multiplication on string type

    fun(1.1, 1, 2, true);        //OK
    fun(1.1, 1.1, 2.2, true);    //error
    fun(1, 1.1, 2.2, true);      //error
    fun(1, 1, 2, true);          //OK type coercion
    fun(1, true, 2.2, true);     //error
	fun(1.1, 1, 2, true, 3);    //error
	fun(1.1, 1, 2);    //error
	fun(k, a, b, d);

end

end mytest1error
