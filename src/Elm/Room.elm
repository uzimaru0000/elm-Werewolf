module Room exposing (..)

import Rule exposing (..)
import User exposing (..)
import Json.Decode as JD
import Json.Encode as JE

type alias Room =
    { uid : String
    , name : String
    , owner : User
    , member : List User
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
        (JD.field "member" <| JD.list userDecoder)
        (JD.field "maxNum" JD.int)
        (JD.field "pass" JD.string)
        (JD.field "ruleSet" <| JD.list ruleSetDecoder)


roomEncoder : Room -> JE.Value
roomEncoder room =
    JE.object
        [ ("uid", JE.string room.uid)
        , ("name", JE.string room.name)
        , ("ownerID", JE.string room.owner.uid)
        , ("maxNum", JE.int room.maxNum)
        , ("member", room.member |> List.map (.uid >> JE.string) |> JE.list)
        , ("pass", JE.string room.pass)
        , ("ruleSet", room.ruleSet |> List.map ruleSetEncoder |> JE.list)
        ]