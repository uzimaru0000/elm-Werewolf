module Auth.View exposing (..)

import Auth.Model exposing (..)
import Html exposing (Html, text, img, i, span)
import Html.Attributes exposing (src, style, class)
import Html.Events exposing (onClick)
import Bulma.Columns as Bulma exposing (..)
import Bulma.Elements as Bulma exposing (..)
import Bulma.Form as Bulma exposing (..)
import Bulma.Modifiers as Bulma exposing (..)
import Bulma.Modifiers.Typography as Bulma


loginViewColumnsModifiers : ColumnsModifiers
loginViewColumnsModifiers =
    { multiline = False
    , gap = Gap3
    , display = DesktopAndBeyond
    , centered = True
    }


view : Html Msg
view =
    columns loginViewColumnsModifiers
        []
        [ column columnModifiers
            []
            [ title H1
                [ Bulma.textCentered ]
                [ text "Sign in" ]
            , image (OneByOne X128)
                [ style
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
            , loginBtn Twitter
            , loginBtn Google
            , loginBtn GitHub
            ]
        ]


loginBtn : LoginType -> Field Msg
loginBtn loginType =
    let
        ( str, color ) =
            case loginType of
                Twitter ->
                    ( "fab fa-twitter", Info )

                Google ->
                    ( "fab fa-google", Default )

                GitHub ->
                    ( "fab fa-github", Black )
    in
        fields Bulma.Centered
            []
            [ controlButton
                { buttonModifiers
                    | color = color
                    , size = Large
                    , iconLeft = Just ( Standard, [], i [ class str ] [] )
                }
                []
                [ onClick <| Login loginType
                , style btnStyle
                ]
                [ span [] [ text <| toString loginType ] ]
            ]


btnStyle : List ( String, String )
btnStyle =
    [ ( "padding", "0 128px" )
    , ( "margin-bottom", "16px" )
    ]
