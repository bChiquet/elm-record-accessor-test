module Spec exposing (suite)

import Test exposing (Test, describe, test)
import Expect
import Main exposing (MyRecord(R))
import LensTypes exposing (get, set, over)
import Lens exposing (r)


simpleRecord = {foo = 3, bar = "Yop", qux = False}
nestedRecord = {foo = simpleRecord}

suite : Test
suite =
  describe "working lenses"
    [ describe "get"
      [ test "simple get" <| \_ -> 
          Expect.equal 
            ( get r.foo simpleRecord)
            3
      , test "nested get" <| \_ ->
          Expect.equal
            (get (r.foo << r.bar) nestedRecord)
            "Yop"
      ]
    , describe "set"
      [ test "simple set" <| \_ ->
          let updatedExample = 
            (set r.qux True simpleRecord)
          in Expect.equal
            updatedExample.qux
            True
      , test "nested set" <| \_->
          let updatedExample = 
            (set (r.foo << r.foo) 5 nestedRecord)
          in Expect.equal
            updatedExample.foo.foo
            5
      ]
    , describe "over"
      [ test "simple over" <| \_ ->
          let updatedExample =
            (over r.bar (\w -> w ++ " lait") simpleRecord)
          in Expect.equal
            updatedExample.bar
            "Yop lait"
      , test "nested over" <| \_ ->
          let updatedExample =
            (over (r.foo << r.qux) (\w -> not w) nestedRecord)
          in Expect.equal
            updatedExample.foo.qux
            True
      ]
    ]
