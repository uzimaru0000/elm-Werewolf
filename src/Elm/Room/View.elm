module Room.View exposing (..)

import Html exposing (Html, text, span, div, a, img, i)
import Html.Attributes exposing (class, style)
import Room.Model exposing (..)
import Rule exposing (..)
import User exposing (..)
import Bulma.Columns exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Modifiers exposing (..)
import Bulma.Modifiers.Typography as Typo
import Bulma.Form exposing (..)


view : Model -> Html msg
view model =
    div []
        [ header model
        , section NotSpaced
            []
            [ mainContent model ]
        ]


header : Model -> Html msg
header { room } =
    hero
        { heroModifiers
            | color = Primary
            , size = Small
        }
        []
        [ heroBody []
            [ container []
                [ title H1 [] [ text room.name ]
                , userView Medium room.owner
                ]
            ]
        ]


mainContent : Model -> Html msg
mainContent { room } =
    container
        []
        [ content Standard
            []
            [ title H3 [] [ text "Rules" ]
            , room.ruleSet
                |> List.filter (Tuple.second >> ((<) 0))
                |> List.map ruleView
                |> columns { columnsModifiers | multiline = True } []
            ]
        , content Standard
            []
            [ title H3
                []
                [ text <| "Member " ++ String.join "/" [ (toString << List.length) room.member, toString room.maxNum ] ]
            , level []
                [ room.member
                    |> List.map
                        (userView Medium
                            >> List.singleton
                            >> box []
                            >> List.singleton
                            >> column narrowColumnModifiers []
                        )
                    |> columns { columnsModifiers | multiline = True } []
                ]
            ]
        , content Standard
            []
            [ field
                []
                [ controlButton
                    { buttonModifiers
                        | color = Success
                        , size = Medium
                    }
                    []
                    [ fullWidth ]
                    [ span [] [ text "Join" ] ]
                ]
            ]
        ]


ruleView : RuleSet -> Html msg
ruleView ( rule, n ) =
    column narrowColumnModifiers
        []
        [ box
            [ paddingless
            , class "has-background-info"
            , Typo.textColor Typo.White
            ]
            [ horizontalLevel []
                [ levelLeft []
                    [ levelItem [] [ icon Large [] [ i [ class <| ruleIcon rule ] [] ] ]
                    , levelItem [] [ span [ Typo.textSize Typo.Large ] [ text <| toString rule ] ]
                    ]
                , levelRight []
                    [ levelItem [] [ span [ Typo.textSize Typo.Medium ] [ text <| toString n ] ]
                    ]
                ]
            ]
        ]
