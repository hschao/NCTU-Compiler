// test8.p
test8;
var a, b: integer;
var d: boolean;
foo( a: integer ): integer;
begin
    var i, result: integer;
    result := 0;
    i := 1;
    while i <= a do
        result := result+i;
        i := i+1;
    end do
    return result;
end
end foo
begin
    var c: integer;
    read a;
    c := foo( a );
    print c;
    print "\n";
    if c >= 100 then
        print "c >= 100 \n";
    else
        print "c < 100 \n";
    end if
end
end test1