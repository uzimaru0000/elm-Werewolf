module Room exposing (..)

import Rule exposing (..)
import User exposing (..)
import Json.Decode as JD

type alias Room =
    { uid : String
    , name : String
    , owner : User
    , member : List String
    , maxNum : Int
    , pass : String
    , ruleSet : List RuleSet
    }


roomDecoder : JD.Decoder Room
roomDecoder =
    JD.map7 Room
        (JD.field "uid" JD.string)
        (JD.field "name" JD.string)
        (JD.field "owner" userDecoder)
        (JD.field "member" <| JD.list JD.string)
        (JD.field "maxNum" JD.int)
        (JD.field "pass" JD.string)
        (JD.field "ruleSet" <| JD.list ruleSetDecoder)
