module Lens exposing (r)

import LensTypes exposing (Accessor(..))


r = {
    bar = \(Accessor sub) ->
      Accessor { get  = \b -> sub.get b.bar
               , over = \f -> \b -> { b | bar = sub.over f b.bar }
               }
    ,
    foo = \(Accessor sub) ->
      Accessor { get  = \b -> sub.get b.foo
               , over = \f -> \b -> { b | foo = sub.over f b.foo}
               }
    ,
    qux = \(Accessor sub) ->
      Accessor { get  = \b -> sub.get b.qux
               , over = \f -> \b -> { b | qux = sub.over f b.qux}
               }
    }
