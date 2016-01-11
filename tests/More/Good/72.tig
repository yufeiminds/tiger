/* records,
 * record constants,
 * record access,
 * nil,
 * records (like arrays) have reference semantics
 */

let
	type strings = { hd: string, tl: strings }

	var xs := strings { hd = "foo", tl = nil }
	var ys := xs
in
	print (ys.hd);
	xs.hd := "bar";
	print (ys.hd);
	print ("\n")
end