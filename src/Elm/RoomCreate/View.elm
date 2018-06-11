module RoomCreate.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import RoomCreate.Model exposing (..)


view : Model -> Html Msg
view model =
    div
        [ class "modal"
        , classList [ ( "is-active", model.isActive ) ]
        ]
        [ div
            [ class "modal-background"
            , onClick Exit
            ]
            []
        , div
            [ class "modal-card" ]
            [ header
            , forms model
            , footer model
            ]
        ]


header : Html Msg
header =
    Html.header
        [ class "modal-card-head" ]
        [ p [ class "modal-card-title" ] [ text "Create Room" ]
        , button
            [ class "delete"
            , onClick Exit
            ]
            []
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
        ]


footer : Model -> Html Msg
footer model =
    Html.footer
        [ class "modal-card-foot" ]
        [ button
            [ class "button is-link"
            , onClick Create
            ]
            [ text "Create" ]
        , button
            [ class "button is-text"
            , onClick Exit
            ]
            [ text "Cancel" ]
        ]
