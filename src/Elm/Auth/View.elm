module Auth.View exposing (..)

import Auth.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Html Msg
view =
    div [ class "columns is-centered" ]
        [ div
            [ class "column" ]
            [ div
                [ class "has-text-centered title is-1" ]
                [ text "Sign in" ]
            , figure
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
                        [ class "button is-large is-info"
                        , onClick <| Login Twitter
                        , style btnStyle
                        ]
                        [ span [ class "icon" ]
                            [ i [ class "fab fa-twitter" ] [] ]
                        , span [] [ text "Twitter" ]
                        ]
                    ]
                ]
            , div
                [ class "field is-grouped is-grouped-centered" ]
                [ div
                    [ class "control" ]
                    [ button
                        [ class "button is-large"
                        , onClick <| Login Google
                        , style btnStyle
                        ]
                        [ span [ class "icon has-text-link" ]
                            [ i [ class "fab fa-google" ] [] ]
                        , span [] [ text "Google" ]
                        ]
                    ]
                ]
            , div
                [ class "field is-grouped is-grouped-centered" ]
                [ div
                    [ class "control" ]
                    [ button
                        [ class "button is-large is-black"
                        , onClick <| Login GitHub
                        , style btnStyle
                        ]
                        [ span [ class "icon" ]
                            [ i [ class "fab fa-github" ] [] ]
                        , span [] [ text "GitHub" ]
                        ]
                    ]
                ]
            ]
        ]

btnStyle : List (String, String)
btnStyle =
    [ ( "padding", "0 128px" )
    , ( "margin-bottom", "16px" )
    ]