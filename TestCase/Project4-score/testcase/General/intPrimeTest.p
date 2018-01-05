//&S-
//&T-
//&D-
intPrimeTest;

pow(b, p, m: integer) : boolean;
begin
    var ret : 1;

    b := b mod m;
    while p do
        if (p mod 2) = 1 then
            // overflow => bang!
            ret := (ret * b) mod m;
        end if
        
        b := (b * b) mod m;
        p := p / 2;
    end do

    return ret;
end
end pow

test(a, n: integer) : boolean;
begin
    var d, x: integer;

    d := (-1) + n;
    while ((d mod 2) = 0) do
        d := d / 2;
    end do

    x := pow(a, d, n);
    while (d < (n - 1)) and (x <> 1) and (x <> (n - 1)) do
        x := (x * x) mod n;
        d := 2 * d;
    end do

    return ((n - 1) = x) or ((d mod 2) = 0);
end
end test

isprime(n: integer) : boolean;
begin
    if (n = 2) or (n = 7) or (n = 61) then
        return true;
    end if

    if (n = 1) or ((n mod 2) = 0) then
        return false;
    end if

    return test(2,n) and test(7,n) and test(61,n);
end
end isprime

begin
    var t: integer; // t: testcase number
    var x: integer; // x: input

    read t;
    while t > 0 do
        read x;
        print isprime(x);
        t := t - 1;
    end do
end
end intPrimeTest
