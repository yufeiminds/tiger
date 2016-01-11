/* record of arrays of arrays access */

let
	type array1 = array of int
	type array2 = array of array1
	type rec = {x:array2}

	var x:rec := rec {x= array2 [4] of array1 [10] of 6}

in
	printi(x.x[2][4]); /* ought to be 6 */
	x.x[2][4] := 99;
	x.x[2][4]	   /* ought to be 99 */
end
