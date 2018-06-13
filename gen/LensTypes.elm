module LensTypes exposing (Accessor(Accessor), get)

type Accessor super sub = 
  Accessor { get : sub
           , over : (sub -> sub) -> super }

-- We can't use this signature because Elm has no rank N types.
-- But don't worry! It only means that we will have longer signatures...
-- The shorter signatures will be provided in comments.

--type alias Lens super sub = (sub   -> Accessor sub   a)
--                         -> (super -> Accessor super a)

--fieldLens : Lens {b | field : a} a
fieldLens sub = \super -> 
  let subAccessor = sub super.field in
  Accessor { get  = subAccessor.get
           , over = \f -> { super | field = subAccessor.over f }
           }

----onEach : Lens (List a) a
--onEach sub = \list ->
--  let subAccessor = List.map sub list in
--  Accessor { get  = List.map .get subAccessor
--           , over = \f -> List.map (.over f) subAccessor
--           }


{- 

-- TYPE MISMATCH ----------------------------------------- ././gen/LensTypes.elm

The argument to function `lens` is causing a mismatch.

38|                   lens id)
                           ^^
                           Function `lens` is expecting the argument to be:

                               a -> Accessor b a

                               But it is:

                                   a -> Accessor a a

                                   Hint: Your type annotation uses `b` and `a`
                                   as separate type variables. Each one
                                   can be any type of value, but because they
                                   have separate names, there is no
                                   guarantee that they are equal to each other.
                                   Your code seems to be saying they
                                   ARE the same though! Maybe they should be the
                                   same in your type annotation?
                                   Maybe your code uses them in a weird way?
                                   More at:
                                   <https://github.com/elm-lang/elm-compiler/blob/0.18.0/hints/type-annotations.md>

                                   Detected errors in 1 module.                                        

-}
--Apparently this error happens because of declaring declaring id. 

--id : z -> Accessor z z
id = \z ->
  Accessor { get  = z
           , over = \f -> f z
           }

--get : Lens s a -> s -> a
--get : ((a -> Accessor a i) -> (b -> Accessor b i)) -> b -> i
get lens s = 
  let (Accessor accessor) = (lens id) s in
  accessor.get

--set : Lens s a -> a -> s -> s
set lens a s = 
  let (Accessor accessor) = (lens id) s in
  accessor.over (\_ -> a)

--over : Lens s a -> (a -> a) -> s -> s
over lens f s =
  let (Accessor accessor) = (lens id) s in
  accessor.over f

