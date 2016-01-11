/* ``matrices'',
 * separate type and function/variable name spaces
 */

let type vec = array of string
	type mat = array of vec

	var row := vec [10] of "foo"
	var mat := mat [10] of row
in
	let var r1 := mat[2]
	var r2 := mat[3]
	in
		r1[5] := "bar";
		print (r2[5])
	end
end