module RoomCreate.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import RoomCreate.Model exposing (..)
import Rule exposing (..)


view : Model -> Html Msg
view model =
    div
        [ class "container" ]
        [ forms model
        ]


forms : Model -> Html Msg
forms model =
    div
        [ class "modal-card-body" ]
        [ div
            [ class "field" ]
            [ label [ class "label" ] [ text "RoomName *" ]
            , div
                [ class "control has-icons-left" ]
                [ input
                    [ class "input"
                    , classList
                        [ ( "is-danger", model.isInputError )
                        ]
                    , type_ "text"
                    , model.roomName |> Maybe.withDefault "" |> value
                    , onInput InputName
                    ]
                    []
                , span
                    [ class "icon is-small is-left" ]
                    [ i [ class "fas fa-home" ] []
                    ]
                , if model.isInputError then
                    p [ class "help is-danger" ] [ text "RoomName must not be empty." ]
                  else
                    text ""
                ]
            ]
        , div
            [ class "field" ]
            [ label [ class "label" ] [ text "PassWord" ]
            , div
                [ class "control has-icons-left" ]
                [ input
                    [ class "input"
                    , type_ "password"
                    , value <| Maybe.withDefault "" <| model.pass
                    , onInput InputPass
                    ]
                    []
                , span
                    [ class "icon is-small is-left" ]
                    [ i [ class "fas fa-key" ] []
                    ]
                ]
            ]
        , div
            [ class "field" ]
            [ label [ class "label" ] [ text "MaxMember" ]
            , div
                [ class "control has-icons-left" ]
                [ input
                    [ class "input"
                    , type_ "number"
                    , Html.Attributes.min "5"
                    , value <| toString model.maxNum
                    , onInput InputNum
                    ]
                    []
                , span
                    [ class "icon is-small is-left" ]
                    [ i [ class "fas fa-users" ] []
                    ]
                ]
            ]
        , div
            [ class "field" ]
            [ label [ class "label" ] [ text "Role" ]
            , model.ruleSet
                |> List.map ruleForm
                |> div [ class "control" ]
            ]
        , div
            [ class "field is-grouped is-grouped-right" ]
            [ div [ class "control" ]
                [ button
                    [ class "button is-link"
                    , classList
                        [ ( "is-loading"
                          , model.isSuccess
                                |> Maybe.map not
                                |> Maybe.withDefault False
                          )
                        ]
                    , onClick Create
                    ]
                    [ text "Create" ]
                ]
            ]
        ]


ruleForm : RuleSet -> Html Msg
ruleForm ( rule, n ) =
    let
        flag =
            n > 0
    in
        div [ class "field has-addons" ]
            [ div [ class "control" ]
                [ button
                    [ class "button is-light"
                    , classList
                        [ ( "is-light", not flag )
                        , ( "is-info", flag )
                        ]
                    , style [ ( "width", "128px" ) ]
                    , onClick <| RuleActive rule
                    ]
                    [ span [ class "icon is-medium" ] [ i [ class <| ruleIcon rule ] [] ]
                    , span [] [ text <| toString rule ]
                    ]
                ]
            , if flag then
                div [ class "control" ]
                    [ input
                        [ class "input"
                        , type_ "number"
                        , value <| toString n
                        , onInput <| InputRoleNum rule
                        ]
                        []
                    ]
              else
                text ""
            ]
