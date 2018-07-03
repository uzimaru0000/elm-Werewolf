module User exposing (..)


type alias User =
    { uid : String
    , name : String
    , iconUrl : Maybe String
    }
