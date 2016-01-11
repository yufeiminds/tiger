/* semantics of nested break */

let function f () =
	let function g (i : int) : int =
		if i = 3 then break
	in
		for i := 0 to 9 do
		(g (i); print (chr (i + ord ("0"))))
	end
in
	f ()
end
