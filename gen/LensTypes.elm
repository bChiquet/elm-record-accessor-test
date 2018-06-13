module LensTypes exposing (Accessor(Accessor), get, set, over)

type Accessor super sub = 
  Accessor { get : super -> sub 
           , over : (sub -> sub) -> (super -> super) }

--fieldLens : Accessor a i -> Accessor {b | field : a} i
--fieldLens (Accessor sub) = 
--  Accessor { get  = \b -> sub.get b.field
--           , over = \change -> (\b -> {b | field = sub.over change b.field })
--           }

--onEach : Accessor a i -> Accessor (List a) i
--onEach (Accessor sub) =
--  Accessor { get  = \b -> List.map sub.get b
--           , over = \change -> (\b -> List.map (sub.over change) b)
--           }


--id : Accessor z z
id =
  Accessor { get  = \a -> a
           , over = \change -> (\a -> change a)
           }

--get : ( Accessor a i -> Accessor b i) -> b -> i
get lens s = 
  let (Accessor accessor) = (lens id) in
  accessor.get s

--set : ( Accessor a i -> Accessor b i) -> i -> b -> b
set lens i s = 
  let (Accessor accessor) = (lens id) in
  accessor.over (\_ -> i) s

--over : ( Accessor a i -> Accessor b i) -> (i -> i) -> b -> b
over lens f s = 
  let (Accessor accessor) = (lens id) in
  accessor.over f s
