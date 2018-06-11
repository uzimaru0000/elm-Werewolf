module Room exposing (..)


type alias Room =
    { uid : String
    , name : String
    , ownerID : String
    , member : List String
    , maxNum : Int
    , pass : Maybe String
    -- , rule : List Rule
    }