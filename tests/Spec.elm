module Spec exposing (suite)

import Test exposing (Test, describe, test)
import Expect
import Main exposing (MyRecord(R))
import LensTypes exposing (get, set, over)
import Lens exposing (r)


exampleRecord = {foo = 3, bar = "Yop", qux = False}

suite : Test
suite =
  describe "working lenses"
    [ describe "get"
      [ test "simple get" <| \_ -> 
          Expect.equal 
            ( get r.foo exampleRecord)
            3
      ]

    , describe "set"
      [ test "simple set" <| \_ ->
          let updatedExample = 
            (set r.qux True exampleRecord)
          in Expect.equal
            updatedExample.qux
            True
      ]
    , describe "over"
      [ test "simple over" <| \_ ->
          let updatedExample =
            (over r.bar (\w -> w ++ " lait") exampleRecord)
          in Expect.equal
            updatedExample.bar
            "Yop lait"
      ]
    ]
