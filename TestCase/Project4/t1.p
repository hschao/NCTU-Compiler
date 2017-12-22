//&S-
//&T-
//&D-
/**
 * semtest5.p: test for program name
 */
test;

var aa : array 1 to 5 of integer; // 1D integer array , size=10
var a : array 1 to 10 of integer; // 1D integer array , size=10
var b : "123456";
var c : 77;
var d : 36.4546;
fun( a : integer ): integer; // valid function declaration -> func2 will be inserted to symbol table
begin

    var tt : integer;
    var rr : real;
    var ar : array 1 to 2 of integer;
  for i:=1 to 10 do
    begin
        test := test;
        test := fun;
        test := a;
        test := tt;
        test := ar;
        test := b;
        test := i;
        test := notExist;
        fun := test;
        fun := fun;
        fun := a;
        fun := tt;
        fun := ar;
        fun := b;
        fun := i;
        fun := notExist;
        a := test;
        a := fun;
        a := a;
        a := tt;
        a := ar;
        a := b;
        a := i;
        a := notExist;
        tt := test;
        tt := fun;
        tt := a;
        tt := tt;
        tt := ar;
        tt := b;
        tt := i;
        tt := notExist;
        ar := test;
        ar := fun;
        ar := a;
        ar := tt;
        ar := ar;
        ar := b;
        ar := i;
        ar := notExist;
        b := test;
        b := fun;
        b := a;
        b := tt;
        b := ar;
        b := b;
        b := i;
        b := notExist;
        i := test;
        i := fun;
        i := a;
        i := tt;
        i := ar;
        i := b;
        i := i;
        i := notExist;
        notExist := test;
        notExist := fun;
        notExist := a;
        notExist := tt;
        notExist := ar;
        notExist := b;
        notExist := i;
        notExist := notExist;
        rr := test;
        rr := fun;
        rr := a;
        rr := tt;
        rr := ar;
        rr := b;
        rr := i;
        rr := notExist;
        rr := test[0];
        rr := fun[0];
        rr := a[0];
        rr := tt[0];
        rr := ar[0];
        rr := b[0];
        rr := i[0];
        rr := notExist[0];
    end
    end do
end
end fun

begin
end
end test
