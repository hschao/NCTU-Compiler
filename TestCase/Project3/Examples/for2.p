//&T-
error;
begin   
    var a:string;  
    for i:=1 to 10 do
        begin
            var j : integer;
            for i:=2 to 3 do      // error same iterator
                begin
                    var i : integer;       // error redeclare
                end
            end do
        end
    end do
end
end error