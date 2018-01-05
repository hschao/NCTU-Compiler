//&S-
//&T-
//&D-
forloop;

begin
    var c: array 1 to 9 of integer;

    for i := 9 to 1 do                  // error
        print "=";
    end do

    for i := 1 to 9 do                  // ok
        begin
            begin
                begin
                    for i := 1 to 9 do  // error
                    end do
                end
            end
        end
    end do

    for i := 1 to 9 do                  // ok
        c[i] := i;                      // ok
        i := i + 1;                     // error
    end do
end
end forloop
