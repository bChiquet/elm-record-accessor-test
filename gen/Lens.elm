module Lens exposing (r)

import LensTypes exposing (Accessor(..))


r = {
    bar = \sub -> \super ->
      let subAccessor = sub super.bar in
      Accessor { get  = subAccessor.get
               , over = \f -> { super | bar = subAccessor.over f }
               }
    ,
    com = \sub -> \super ->
      let subAccessor = sub super.com in
      Accessor { get  = subAccessor.get
               , over = \f -> { super | com = subAccessor.over f }
               }
    ,
    elm = \sub -> \super ->
      let subAccessor = sub super.elm in
      Accessor { get  = subAccessor.get
               , over = \f -> { super | elm = subAccessor.over f }
               }
    ,
    field = \sub -> \super ->
      let subAccessor = sub super.field in
      Accessor { get  = subAccessor.get
               , over = \f -> { super | field = subAccessor.over f }
               }
    ,
    foo = \sub -> \super ->
      let subAccessor = sub super.foo in
      Accessor { get  = subAccessor.get
               , over = \f -> { super | foo = subAccessor.over f }
               }
    ,
    get = \sub -> \super ->
      let subAccessor = sub super.get in
      Accessor { get  = subAccessor.get
               , over = \f -> { super | get = subAccessor.over f }
               }
    ,
    map = \sub -> \super ->
      let subAccessor = sub super.map in
      Accessor { get  = subAccessor.get
               , over = \f -> { super | map = subAccessor.over f }
               }
    ,
    md = \sub -> \super ->
      let subAccessor = sub super.md in
      Accessor { get  = subAccessor.get
               , over = \f -> { super | md = subAccessor.over f }
               }
    ,
    over = \sub -> \super ->
      let subAccessor = sub super.over in
      Accessor { get  = subAccessor.get
               , over = \f -> { super | over = subAccessor.over f }
               }
    ,
    qux = \sub -> \super ->
      let subAccessor = sub super.qux in
      Accessor { get  = subAccessor.get
               , over = \f -> { super | qux = subAccessor.over f }
               }
    }
