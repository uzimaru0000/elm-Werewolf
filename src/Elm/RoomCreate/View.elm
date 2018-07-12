module RoomCreate.View exposing (..)

import Html exposing (Html, text, i, span)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import RoomCreate.Model exposing (..)
import Rule exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Form exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Modifiers exposing (..)


view : Model -> Html Msg
view model =
    section NotSpaced
        []
        [ container
            []
            [ field
                []
                [ controlLabel [] [ text "RoomName *" ]
                , controlText
                    { controlInputModifiers
                        | color =
                            if model.errors.nameMissing then
                                Danger
                            else
                                Default
                        , iconLeft = Just ( Small, [], i [ class "fas fa-home" ] [] )
                    }
                    []
                    [ value <| Maybe.withDefault "" model.roomName
                    , onInput InputName
                    ]
                    []
                , if model.errors.nameMissing then
                    controlHelp Danger
                        []
                        [ text "部屋名を入力してください。" ]
                  else
                    text ""
                ]
            , field
                []
                [ controlLabel [] [ text "PassWord *" ]
                , controlPassword
                    { controlInputModifiers
                        | color =
                            if model.errors.passMissing then
                                Danger
                            else
                                Default
                        , iconLeft = Just ( Small, [], i [ class "fas fa-key" ] [] )
                    }
                    []
                    [ value <| Maybe.withDefault "" model.pass
                    , onInput InputPass
                    ]
                    []
                , if model.errors.passMissing then
                    controlHelp Danger
                        []
                        [ text "パスワードを入力してください。" ]
                  else
                    text ""
                ]
            , field
                []
                [ controlLabel [] [ text "MaxMember" ]
                , controlInput
                    { controlInputModifiers
                        | iconLeft = Just ( Small, [], i [ class "fas fa-users" ] [] )
                    }
                    []
                    [ value <| toString model.maxNum
                    , onInput InputNum
                    , type_ "number"
                    , Html.Attributes.min "5"
                    ]
                    []
                ]
            , field
                []
                [ controlLabel [] [ text "Role" ]
                , model.ruleSet
                    |> List.map ruleForm
                    |> control controlModifiers []
                , if model.errors.memberMissing then
                    controlHelp Danger
                        []
                        [ text <| String.join " " [ "人数を", toString model.maxNum, "人にしてください。" ] ]
                  else
                    text ""
                ]
            , field
                []
                [ controlButton
                    { buttonModifiers
                        | color = Link
                        , static = allGreen model
                        , size = Medium
                        , state =
                            model.isSuccess
                                |> Maybe.map (\_ -> identity Loading)
                                |> Maybe.withDefault Blur
                    }
                    []
                    [ onClick Create
                    , fullWidth
                    ]
                    [ span [] [ text "Create" ] ]
                ]
            ]
        ]


ruleForm : RuleSet -> Html Msg
ruleForm ( rule, n ) =
    connectedFields Left
        []
        [ controlButton
            { buttonModifiers
                | color =
                    if n >= ruleMinNum rule then
                        Info
                    else
                        Light
                , iconLeft = Just ( Medium, [], i [ class <| ruleIcon rule ] [] )
            }
            []
            [ style [ ( "width", "128px" ) ]
            , onClick <| RuleActive rule
            ]
            [ span [] [ text <| toString rule ] ]
        , if n >= ruleMinNum rule then
            controlInput controlInputModifiers
                []
                [ type_ "number"
                , value <| toString n
                , onInput <| InputRoleNum rule
                ]
                []
          else
            text ""
        ]
