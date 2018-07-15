module Room.View exposing (..)

import Html exposing (Html, text, span, div, a, img, i)
import Html.Attributes exposing (class, style, value)
import Html.Events exposing (onClick, onInput)
import Room.Model exposing (..)
import Room exposing (passModal)
import Rule exposing (..)
import User exposing (..)
import Bulma.Columns exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Modifiers exposing (..)
import Bulma.Modifiers.Typography as Typo
import Bulma.Form exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ header model
        , section NotSpaced
            []
            [ mainContent model ]
        , if not model.isAuth then
            passModal model.room model ModalOff InputPass Join
          else
            text ""
        ]


header : Model -> Html Msg
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


mainContent : Model -> Html Msg
mainContent ({ room, user } as model) =
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
            [ exitBtn model ]
        ]


ruleView : RuleSet -> Html Msg
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


exitBtn : Model -> Html Msg
exitBtn { room, user } =
    field
        []
        [ controlButton
            { buttonModifiers
                | color = Link
                , size = Medium
            }
            []
            [ fullWidth
            , onClick Exit
            ]
            [ span []
                [ text "Exit"
                ]
            ]
        ]
