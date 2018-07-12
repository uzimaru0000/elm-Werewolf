module RoomCreate.Model exposing (..)

import Rule exposing (..)
import Json.Encode as JE


type alias Errors =
    { nameMissing : Bool
    , passMissing : Bool
    , memberMissing : Bool
    }


type alias Model =
    { roomName : Maybe String
    , maxNum : Int
    , pass : Maybe String
    , ruleSet : List RuleSet
    , errors : Errors
    , isSuccess : Maybe Bool
    }


type Msg
    = InputName String
    | InputNum String
    | InputPass String
    | RuleActive Rule
    | InputRoleNum Rule String
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
    , errors = Errors False False False
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
            [ ( "roomName", model.roomName |> Maybe.withDefault "" |> JE.string )
            , ( "maxNum", JE.int model.maxNum )
            , ( "pass", helper JE.string model.pass )
            , ( "ruleSet", model.ruleSet |> List.map ruleSetEncoder |> JE.list )
            ]


ruleMinNum : Rule -> Int
ruleMinNum rule =
    case rule of
        Villager ->
            1

        Werewolf ->
            2

        Seer ->
            1

        Hunter ->
            1

        Madman ->
            1

        Psychic ->
            1


allGreen : Model -> Bool
allGreen model =
    [ model.errors.nameMissing
    , model.errors.passMissing
    , model.errors.memberMissing
    , case model.roomName of
        Just "" ->
            True

        Nothing ->
            True

        _ ->
            False
    , case model.pass of
        Just "" ->
            True

        Nothing ->
            True

        _ ->
            False
    ]
        |> List.any identity
