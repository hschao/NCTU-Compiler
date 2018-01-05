//&S-
//&T-
//&D-
segmentTree;

var id: integer;
var data: array 1 to 100000 of integer;
var tree: array 1 to 400000 of integer;
var lazy: array 1 to 400000 of integer;

up(r: integer);
begin
    tree[r] := tree[(2*r)] + tree[(2*r)+1];
end
end up

down(lf, mid, rt, cur: integer);
begin
    var lo, ro: integer;

    lo := cur * 2.0;
    ro := lo + 1;

    lazy[lo] := lazy[lo] + lazy[cur];
    lazy[ro] := lazy[ro] + lazy[cur];
    tree[lo] := tree[lo] + (mid-lf+1) * lazy[cur];
    tree[ro] := tree[ro] + (rt-mid) * lazy[cur];
    lazy[cur] := 0;
end
end down

buildTree(lf, rt, cur: integer);
begin
    lazy[cur] := 0;
    if lf = rt then
        // read tree[cur];

        tree[cur] := data[id];
        id := id + 1;
    else
        begin
            var mid: integer;            
            mid := (lf + rt) / 2;

            buildTree(lf, mid, 2*cur);
            buildTree(mid+1, rt, 2*cur+1);
            up(cur);
        end
    end if
end
end buildTree

query(x, y, lf, rt, cur: integer): integer;
begin
    if (x <= lf) and (rt <= y) then
        return tree[cur];
    else
        begin
            var mid, ret: integer;
            mid := (lf + rt) / 2;
            ret := 0;

            if lazy[cur] then
                down(lf, mid, rt, cur);
            end if
            if x <= mid then
                ret := ret + query(x, y, lf, mid, cur*2);
            end if
            if mid < y then
                ret := ret + query(x, y, mid+1, rt, cur*2+1);
            end if

            return ret;
        end
    end if
end
end query

update(x, y, incr, lf, rt, cur: integer);
begin
    if (x <= lf) and (rt <= y) then
        lazy[cur] := lazy[cur] + incr;
        tree[cur] := tree[cur] + ((rt-lf+1) * incr);
    else
        begin
            var mid: integer;
            mid := (lf + rt) / 2;

            if lazy[cur] > 0 then
                down(lf, mid, rt, cur);
            end if
            if x <= mid then
                update(x, y, incr, lf, mid, cur*2);
            end if
            if mid < y then
                update(x, y, incr, mid+1, rt, cur*2+1);
            end if
            up(cur);
        end
    end if
end
end query

begin
    var n, op: integer;
    
    read n;
    if (n < 1) or (n > 100000) then
        print "Invalid input: " + n;
        return 1;
    end if

    for i := 1 to 100000 do
        if i <= n then
            read data[i];
        else
            // break; // No 'break' in P language QQ 
        end if
    end do
    id := 1;
    buildTree(1, n, 1);

    // TODO: read inputs correspond to query or update
end
end segmentTree
