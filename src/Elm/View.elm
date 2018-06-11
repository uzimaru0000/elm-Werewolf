module View exposing (..)

import Model exposing (..)
import User exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    div
        []
        [ header model
        ]


header : Model -> Html Msg
header model =
    Html.header
        [ class "navbar is-dark is-fixed-top"
        , style [ ("padding", "8px") ]
        ]
        [ div [ class "navbar-brand" ]
            [ div [ class "navbar-item" ] [ text "WereWolf Online" ] ]
        , div [ class "navbar-menu" ]
            [ navbarEnd model.user
            ]
        ]


navbarEnd : Maybe User -> Html Msg
navbarEnd maybeUser =
    div [ class "navbar-end" ]
        [ case maybeUser of
            Just user ->
                div [ id "user-info"
                    , class "navbar-item has-dropdown is-hoverable"
                    ]
                    [ div
                        [ class "navbar-link" ]
                        [ img [ user.iconUrl |> Maybe.withDefault "" |> src
                              , style [ ("border-radius", "50%") ]
                              ] []
                        , span [ style [ ("padding-left", "8px") ] ] [ text user.name ]
                        ]
                    , div
                        [ class "navbar-dropdown" ]
                        [ div
                            [ class "navbar-item"
                            , style [ ("color", "red") ]
                            , onClick Logout
                            ]
                            [ text "logout" ]
                        ]
                    ]

            Nothing ->
                div [ class "navbar-item" ]
                    [ div
                        [ onClick Login
                        , class "button is-info"
                        ]
                        [ text "login" ]
                    ]
        ]
