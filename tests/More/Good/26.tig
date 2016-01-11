/* pass-by-reference for records */
let
	type rec = {x:int, y:string}
	var a := rec {x=0, y="zero"}

	function mutate(x:rec) = ( x.x := 4;
			           x.y := "four")
in
	print(a.y);	/* "zero" */
	mutate(a);
	print(a.y)	/* "four */
end


