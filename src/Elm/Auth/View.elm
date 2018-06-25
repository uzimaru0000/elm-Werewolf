module Auth.View exposing (..)

import Auth.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    nav
        [ class "navbar is-fixed-top"
        ]
        [ div [ class "navbar-brand" ]
            [ div [ class "navbar-item" ] [ text "WereWolf Online" ]
            , div
                [ class "navbar-burger"
                , classList [ ( "is-active", model.menuClick ) ]
                , onClick MenuClick
                ]
                [ span [] []
                , span [] []
                , span [] []
                ]
            ]
        , div
            [ class "navbar-menu"
            , classList [ ( "is-active", model.menuClick ) ]
            ]
            [ navbarEnd model ]
        ]


navbarEnd : Model -> Html Msg
navbarEnd { user, state, menuClick } =
    div [ class "navbar-end" ]
        [ case user of
            Just user ->
                div
                    [ class "navbar-item has-dropdown"
                    , classList [ ( "is-active", menuClick ) ]
                    ]
                    [ div
                        [ class "navbar-link is-dark is-hidden-touch"
                        , onClick MenuClick
                        ]
                        [ img
                            [ user.iconUrl |> Maybe.withDefault "" |> src
                            , style [ ( "border-radius", "50%" ) ]
                            ]
                            []
                        ]
                    , div
                        [ class "navbar-dropdown" ]
                        [ a
                            [ class "navbar-item  has-text-danger"
                            , onClick Logout
                            ]
                            [ text "logout" ]
                        ]
                    ]

            Nothing ->
                text ""
        ]


loginView : Model -> Html Msg
loginView model =
    div [ class "columns is-centered" ]
        [ div
            [ class "column box is-half" ]
            [ figure
                [ class "image is-128x128"
                , style
                    [ ( "margin", "16px auto 32px" )
                    , ( "border-radius", "50%" )
                    ]
                ]
                [ img
                    [ src "https://bulma.io/images/placeholders/128x128.png"
                    , style
                        [ ( "border-radius", "50%" )
                        ]
                    ]
                    []
                ]
            , div
                [ class "field is-grouped is-grouped-centered" ]
                [ div
                    [ class "control" ]
                    [ button
                        [ class "button is-medium is-info"
                        , onClick <| Login Twitter
                        ]
                        [ span [ class "icon" ]
                            [ i [ class "fab fa-twitter" ] [] ]
                        , span [] [ text "Twitter" ]
                        ]
                    ]
                ]
            ]
        ]
