module RoomCreate.Model exposing (..)


type alias Model =
    { roomName : Maybe String
    , maxNum : Int
    , pass : Maybe String
    , isActive : Bool
    , isInputError : Bool
    }


type Msg
    = InputName String
    | InputNum String
    | InputPass String
    | Exit
    | Create


init : Model
init =
    { roomName = Nothing
    , maxNum = 5
    , pass = Nothing
    , isActive = True
    , isInputError = False
    }