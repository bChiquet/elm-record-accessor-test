module LensTypes exposing (Accessor(Accessor), get, set, over, onEach, try)


--Result is introduced to account for wrappers e.g. List or Maybe 

type Accessor super sub wrap = 
    Accessor { get : super -> wrap
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

--onEach : Accessor a i -> Accessor (List a) i
onEach (Accessor sub) = 
  Accessor { get = \list -> List.map sub.get list
           , over = \f -> (\list -> List.map (sub.over f) list) }


try (Accessor sub) =
  Accessor { get = \maybe -> case maybe of 
                      Just something -> Just (sub.get something)
                      Nothing -> Nothing
           , over = \f -> (\maybe -> case maybe of 
                      Just something -> Just (sub.over f something)
                      Nothing -> Nothing) }

