module Room exposing (..)

import Rule exposing (..)
import User exposing (..)
import Json.Decode as JD
import Json.Encode as JE
import Html exposing (Html, text, span, i)
import Html.Attributes exposing (value, class)
import Html.Events exposing (onClick, onInput)
import Bulma.Components exposing (..)
import Bulma.Form exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Modifiers exposing (..)


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
        [ ( "uid", JE.string room.uid )
        , ( "name", JE.string room.name )
        , ( "ownerID", JE.string room.owner.uid )
        , ( "maxNum", JE.int room.maxNum )
        , ( "member", room.member |> List.map (.uid >> JE.string) |> JE.list )
        , ( "pass", JE.string room.pass )
        , ( "ruleSet", room.ruleSet |> List.map ruleSetEncoder |> JE.list )
        ]


passModal : Room -> { a | passwordError : Bool, input : String } -> msg -> (String -> msg) -> (String -> msg) -> Html msg
passModal room { passwordError, input } offMsg inputMsg joinMsg =
    modal True
        []
        [ modalBackground [ onClick offMsg ] []
        , modalCard []
            [ modalCardHead []
                [ modalCardTitle [] [ text "部屋に参加する" ]
                , delete [ onClick offMsg ] []
                ]
            , modalCardBody []
                [ field []
                    [ controlLabel [] [ text "パスワードを入力" ]
                    , controlPassword
                        { controlInputModifiers
                            | color =
                                if passwordError then
                                    Danger
                                else
                                    Default
                            , iconLeft = Just ( Small, [], i [ class "fas fa-key" ] [] )
                        }
                        []
                        [ value input
                        , onInput inputMsg
                        ]
                        []
                    , if passwordError then
                        controlHelp Danger [] [ text "パスワードが違います" ]
                      else
                        text ""
                    ]
                ]
            , modalCardFoot []
                [ fields Left
                    []
                    [ controlButton { buttonModifiers | color = Success }
                        []
                        [ onClick <| joinMsg room.uid ]
                        [ span [] [ text "Join" ] ]
                    , controlButton buttonModifiers
                        []
                        [ onClick offMsg ]
                        [ span [] [ text "Cancel" ] ]
                    ]
                ]
            ]
        ]
