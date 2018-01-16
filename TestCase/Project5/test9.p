test9;
var i: integer;
var k,j : real;
var s: boolean;

notFunAtAll(a:real;b:integer;c:boolean;d:real):real;
begin
if c then
return a+b+d;
else
return -50.0;
end if
end
end notFunAtAll

ppp();
begin
print "not fun at all\n";
end
end ppp

cmp(a,b:real):boolean;
begin
    var ans:boolean;
    ans:= a>=b;
    return ans;
end
end cmp


begin
        var r:"haha";
        var m:integer;
        var bo:boolean;
       var t:true;
       var two:2;
        var kkk:5.0;
        var abc:real;
        m:=-1;
        print m;
       print "\n";
       k:=-3.0;
        print k;
        print "\n";
        j:=-k;
        print j;
        print "\n";
        bo:=not false;
        print bo;
        print "\n";
        bo:=true and false;
        print bo;
        print "\n";
        bo:= true or false;
        print bo;
        print "\n";
        bo:=t;
        print bo;
        print "\n";
        m:=two;
        abc:=kkk;
        print r;
        print "\n";
        if m <= two then
            print "m<=two\n";
            if m=two then
            print "m==two\n";
            end if
        end if 
        
        m:=0;

        while m<10 do
        begin
            print m;
            print "\n";
            m:=m+1;
            i:=0;
            while i<5 do
            begin
                print "a";
                i:=i+1;
            end 
            end do
            print"\n";
        end
        end do
        
        for x:=1 to 10 do
        begin 
            i:=0;
            while i <> 3 do
            begin
                if x = 2 then
                    print "h";
                else
                print "n";
                end if
                i:=i+1;
            end 
            end do
            print "\n";
        end
        end do
       print m;
       print "\n";
        print -(notFunAtAll(1*2,3,m>=10,-m));
        print "\n";
        ppp();
        print notFunAtAll(1,3,false,m);
        print "\n";
        bo:=cmp(5,5.0);
        print bo;
        print "\n";
end
end test9
