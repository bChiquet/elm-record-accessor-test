module Accessors exposing (Accessor(Accessor), get, set, over, onEach, try)


type Accessor super sub wrap = 
    Accessor { get : super -> wrap
             , over : (sub -> sub) -> (super -> super) }


exampleFieldLens : Accessor a b c -> Accessor {rec | field : a} b c
exampleFieldLens (Accessor sub) = 
  Accessor { get  = \super -> sub.get super.field
           , over = \change -> 
             (\super -> 
               {super | field = sub.over change super.field }
             )
           }

id : Accessor a a a
id =
  Accessor { get  = \a -> a
           , over = \change -> (\a -> change a)
           }

get : (Accessor a a a -> Accessor b a c) -> b -> c
get lens s = 
  let (Accessor accessor) = (lens id) in
  accessor.get s

set : (Accessor a a a -> Accessor b a c) -> a -> b -> b
set lens i s = 
  let (Accessor accessor) = (lens id) in
  accessor.over (\_ -> i) s

over : (Accessor a a a -> Accessor b a c) -> (a -> a) -> b -> b
over lens f s = 
  let (Accessor accessor) = (lens id) in
  accessor.over f s

onEach : Accessor a b c -> Accessor (List a) b (List c)
onEach (Accessor sub) = 
  Accessor { get = \list -> List.map sub.get list
           , over = \f -> (\list -> List.map (sub.over f) list) }


try : Accessor a b c -> Accessor (Maybe a) b (Maybe c)
try (Accessor sub) =
  Accessor { get = \maybe -> case maybe of 
                      Just something -> Just (sub.get something)
                      Nothing -> Nothing
           , over = \f -> (\maybe -> case maybe of 
                      Just something -> Just (sub.over f something)
                      Nothing -> Nothing) }

