module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import TestExtend exposing (..)
import Room exposing (..)
import Rule exposing (..)
import Json.Decode exposing (..)


all : Test
all =
    describe "allTest"
        [ "Decode1"
            => (Json.Decode.decodeString Rule.ruleSetDecoder ruleSetJson |> Debug.log "")
            === (Ok ruleSetData)
        , "Decode2"
            => (Json.Decode.decodeString Room.roomDecoder roomJson |> Debug.log "")
            === (Ok roomData)
        ]


roomJson : String
roomJson = """
{
    "uid":"-LFbH20UAdNazTo9-xF7",
    "name":"hoge",
    "ownerID":"C2UY7snSqKasY8ddAtGfumo9nma2",
    "member":["C2UY7snSqKasY8ddAtGfumo9nma2"],
    "maxNum":5,
    "pass":"test",
    "ruleSet":[
        ["Villager",1],
        ["Werewolf",2],
        ["Seer",1],
        ["Hunter",1],
        ["Madman",0],
        ["Psychic",0]
    ]
}"""


roomData : Room
roomData =
    { uid = "-LFbH20UAdNazTo9-xF7"
    , name = "hoge"
    , ownerID = "C2UY7snSqKasY8ddAtGfumo9nma2"
    , member = ["C2UY7snSqKasY8ddAtGfumo9nma2"]
    , maxNum = 5
    , pass = Just "test"
    , ruleSet =
        [ ( Villager, 1 )
        , ( Werewolf, 2 )
        , ( Seer, 1 )
        , ( Hunter, 1 )
        , ( Madman, 0 )
        , ( Psychic, 0 )
        ]
    }

ruleSetJson : String
ruleSetJson = """
["Villager", 0]
"""

ruleSetData : RuleSet
ruleSetData =
    (Villager, 0)