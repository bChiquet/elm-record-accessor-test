module Accessors exposing (Accessor(Accessor), get, set, over, onEach, try)

{-| Accessors provide the ability to access nested data structures. Accessors
can be obtained by composing accessor combinators (also called Lenses):
    
    myRecord = {foo = {bar = "Hello"
                      , qux = 3
                      }
               }

    get (foo << bar) myRecord 
    -- returns "Hello"

    set (foo << bar) "Hi!" myRecord
    -- returns {foo = {bar = "Hi!", qux = 3}}

    over (foo << qux) (+1) myRecord
    -- returns {foo = {bar = "Hello", qux = 4}}

In the example above, foo, bar, qux, but also (foo << bar) and (foo << qux) are
accessor combinators.

Accessors and accessor combinators have full type checking: using an accessor on
the wrong type of data results in a compilation error:

    get (foo << foo) myRecord 

    -- The 2nd argument to function `get` is causing a mismatch.
    -- 
    -- 108|    get (foo << foo) myRecord
    --                          ^^^^^^^^
    -- Function `get` is expecting the 2nd
    -- argument to be:
    -- 
    --     { foo : { f | foo : ... } }
    -- 
    -- But it is:
    -- 
    --     { foo : { bar : ..., qux : ... } }

Accessors and accessor combinators are purely functional. While you may get the
look and feel of mutable data structures, it's immutable all the way down.

#Access functions
@doc get, set, over

# Accessor combinators
@doc exampleFieldLens, onEach, try

# Accessor
@docs Accessor
-}


{-| An accessor is a record with a function that lets you get content inside a
data structure, and another function that lets you modify that content.

The super type parameter tracks the type of data structure that you will access.
The sub type parameter tracks the type of what you want to access within super.

The wrap type parameter tracks the type of data that get will return: for some
data structures such as records, wrap will always be equal to sub. However, for
other data structures such as Maybe or List, there is not a 1:1 relation between
the container and the contained. The wrap type parameter tracks which containers
cannot be discarded. 
A wrap type parameter will always look like (List sub) or Maybe (List sub) i.e.
it will always have sub as its only type parameter.
-}
type Accessor super sub wrap = 
    Accessor { get : super -> wrap
             , over : (sub -> sub) -> (super -> super) }


{-| id is a neutral record. It is used to end a braid of record combinators (see
the implementation for get, set and over).
-}
id : Accessor a a a
id =
  Accessor { get  = \a -> a
           , over = \change -> (\a -> change a)
           }


{-| The get function takes:
* An accessor combinator,
* A datastructure that can be accessed using that combinator
and returns the value accessed by that combinator.

    get (foo << bar) myRecord 
-}
get : (Accessor a a a -> Accessor b a c) -> b -> c
get lens s = 
  let (Accessor accessor) = (lens id) in
  accessor.get s


{-|The set function takes:
* An accessor combinator, 
* A value of the type that this combinator lets you access,
* A datastructure that can be accessed using that combinator
and it returns the data structure, with the accessible field changed to be
the set value.

    set (foo << bar) "Hi!" myRecord
-}
set : (Accessor a a a -> Accessor b a c) -> a -> b -> b
set lens i s = 
  let (Accessor accessor) = (lens id) in
  accessor.over (\_ -> i) s


{-|The over function takes:
* An accessor combinator, 
* A function (type -> type), type being that which this combinator lets you access,
* A datastructure that can be accessed using that combinator
and it returns the data structure, with the accessible field changed by applying
the function to the existing value.

    over (foo << qux) (+1) myRecord
-}
over : (Accessor a a a -> Accessor b a c) -> (a -> a) -> b -> b
over lens f s = 
  let (Accessor accessor) = (lens id) in
  accessor.over f s


{-| This Accessor combinator is provided as an example, to show you how to
implement accessor combinators on your record fields. 

Like every accessor, this accessor takes a sub accessor, and returns an accessor
for the structure that wraps it.
-}
exampleFieldLens : Accessor inter sub wrap
                -> Accessor {rec | field : inter} sub wrap
exampleFieldLens (Accessor sub) = 
  Accessor { get  = \super -> sub.get super.field
           , over = \change -> 
             (\super -> 
               {super | field = sub.over change super.field }
             )
           }


{-| This accessor combinator lets you access values inside lists.

    listRecord = {foo = [{ bar = 2}
                        , {bar = 3}
                        , {bar = 4}
                        ]
                 }

    get (foo << onEach << bar) listRecord
    -- returns [2, 3, 4] 

    over (foo << onEach << bar) (+1) listRecord
    -- returns {foo = [{ bar = 3}, {bar = 4}, {bar = 5}] }
-}
onEach : Accessor a b c -> Accessor (List a) b (List c)
onEach (Accessor sub) = 
  Accessor { get = \list -> List.map sub.get list
           , over = \f -> (\list -> List.map (sub.over f) list) }


{-| This accessor combinator lets you access values inside Maybe.

    maybeRecord = { foo = Just { bar = 2}
                  , qux = Nothing
                  }

    get (foo << try << bar) listRecord
    -- returns Just 2

    get (qux << try << bar) listRecord
    -- returns Nothing

    over (foo << try << bar) (+1) listRecord
    -- returns { foo = Just { bar = 3} , qux = Nothing }

    over (qux << try << bar) (+1) listRecord
    -- returns { foo = Just { bar = 2} , qux = Nothing }
-}
try : Accessor a b c -> Accessor (Maybe a) b (Maybe c)
try (Accessor sub) =
  Accessor { get = \maybe -> case maybe of 
                      Just something -> Just (sub.get something)
                      Nothing -> Nothing
           , over = \f -> (\maybe -> case maybe of 
                      Just something -> Just (sub.over f something)
                      Nothing -> Nothing) }
