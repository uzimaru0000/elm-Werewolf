module Auth.View exposing (..)

import Auth.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
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
            , div
                [ class "field is-grouped is-grouped-centered" ]
                [ div
                    [ class "control" ]
                    [ button
                        [ class "button is-medium"
                        , onClick <| Login Google
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
                        [ class "button is-medium is-black"
                        , onClick <| Login GitHub
                        ]
                        [ span [ class "icon" ]
                            [ i [ class "fab fa-github" ] [] ]
                        , span [] [ text "GitHub" ]
                        ]
                    ]
                ]
            ]
        ]
