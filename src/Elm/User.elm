module User exposing (..)

import Json.Decode as JD

type alias User =
    { uid : String
    , name : String
    , iconUrl : Maybe String
    }


userDecoder : JD.Decoder User
userDecoder =
    JD.map3 User
        (JD.field "uid" JD.string)
        (JD.field "name" JD.string)
        (JD.field "iconUrl" <| JD.nullable JD.string)