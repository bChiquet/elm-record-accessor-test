module Spec exposing (..)

import Test exposing (Test, describe, test)
import Expect
import Main exposing (MyRecord(R))
import LensTypes exposing (get)
import Lens exposing (r)


exampleRecord = R {foo = 3, bar = "Yop", qux = False}

suite : Test
suite =
  describe "working lenses" [
    describe "get" [
      test "simple get" <| \_ -> 
          Expect.equal 
            ( get r.foo exampleRecord)
            3
      ]
    ]
