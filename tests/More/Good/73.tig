/* build a string from a linked list of digits,
 * nested functions
 */

let type ints = { hd: int, tl: ints }

	function digits (ds : ints) : string =
	let
		function digit (d : int) : string =
			chr (d + ord ("0"))
		in
			if ds = nil then ""
						else concat (digit (ds.hd), digits (ds.tl))
		end
	var i := ints { hd = 4, tl = ints { hd = 2, tl = nil } }
in
	print (digits (i));
	print ("\n")
end