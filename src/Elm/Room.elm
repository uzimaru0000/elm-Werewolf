module Room exposing (..)

import Rule exposing (..)
import Json.Decode as JD
import Json.Encode as JE

type alias Room =
    { uid : String
    , name : String
    , ownerID : String
    , member : List String
    , maxNum : Int
    , pass : Maybe String
    , ruleSet : List RuleSet
    }


roomDecoder : JD.Decoder Room
roomDecoder =
    JD.map7 Room
        (JD.field "uid" JD.string)
        (JD.field "name" JD.string)
        (JD.field "ownerID" JD.string)
        (JD.field "member" <| JD.list JD.string)
        (JD.field "maxNum" JD.int)
        (JD.field "pass" <| JD.nullable JD.string)
        (JD.field "ruleSet" <| JD.list ruleSetDecoder)
