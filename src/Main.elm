module Main exposing (MyRecord (..), func)


type MyRecord = R { foo : Int, bar : String, qux : Bool} 


func : MyRecord -> MyRecord
func (R r) =  
    R { r | foo = r.foo + 1
          , bar = r.bar ++ "yup"
          , qux = not r.qux }
