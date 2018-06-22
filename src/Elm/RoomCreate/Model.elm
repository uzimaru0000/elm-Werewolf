module RoomCreate.Model exposing (..)

import Rule exposing (..)
import Set exposing (..)
import Json.Encode as JE


type alias Model =
    { roomName : Maybe String
    , maxNum : Int
    , pass : Maybe String
    , ruleSet : List RuleSet
    , isActive : Bool
    , isInputError : Bool
    , isSuccess : Maybe Bool
    }


type Msg
    = InputName String
    | InputNum String
    | InputPass String
    | RuleActive Rule
    | InputRoleNum Rule String
    | Activate
    | Exit
    | Create
    | Success ()


init : Model
init =
    { roomName = Nothing
    , maxNum = 5
    , pass = Nothing
    , ruleSet =
        [ ( Villager, 1 )
        , ( Werewolf, 2 )
        , ( Seer, 1 )
        , ( Hunter, 1 )
        , ( Madman, 0 )
        , ( Psychic, 0 )
        ]
    , isActive = False
    , isInputError = False
    , isSuccess = Nothing
    }


modelToValue : Model -> JE.Value
modelToValue model =
    let
        helper encoder a =
            case a of
                Just x ->
                    encoder x

                Nothing ->
                    JE.null
    in
        JE.object
            [ ( "modelName", model.roomName |> Maybe.withDefault "" |> JE.string  )
            , ( "maxNum", JE.int model.maxNum )
            , ( "pass", helper JE.string model.pass )
            , ( "ruleSet", model.ruleSet |> List.map ruleSetEncoder |> JE.list )
            ]
