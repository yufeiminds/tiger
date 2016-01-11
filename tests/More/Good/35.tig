 /* scope of let variables */
 let
         var x:int := 5
         function foo(a:int):int = (a = x)  /* x here is 5 */
 in
         let
                 var x:=10
                 var y:=x        /*y should be 10*/
         in
                 if foo(y) then print("wrong")
                          else print("correct")
         end
 end