module RoomCreate.Model exposing (..)


type alias Model =
    { roomName : Maybe String
    , maxNum : Int
    , pass : Maybe String
    }


type Msg
    = InputName String
    | InputNum String
    | InputPass String
    | Create