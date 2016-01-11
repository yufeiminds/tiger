/* records assigned by reference */
let
        type rec = {first:int, second:int}
        var x := rec {first=0, second=5}
        var y := rec {first=1, second = 1024}
in
	printi(x.second);	/* 5 */
        x := y;
	printi(x.second);	/* 1024 */
	x.second := 1;
	printi(y.second)	/* 1 */
end


