module RoomListing.View exposing (..)

import Dict exposing (..)
import Room exposing (..)
import Rule exposing (..)
import User exposing (..)
import Routing
import Model
import RoomListing.Model exposing (..)
import Html exposing (Html, text, img, i, span)
import Html.Attributes exposing (class, style, src, href)
import Html.Events exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Modifiers exposing (..)
import Bulma.Modifiers.Typography as Typo


view : Model -> Html Msg
view model =
    section NotSpaced
        []
        [ container []
            [ forms model
            , listView model
            ]
        ]


forms : Model -> Html Msg
forms model =
    box
        []
        [ title H3 [] [ text "Filter" ]
        , field
            []
            [ controlLabel [] [ text "RoomName" ]
            , controlInput controlInputModifiers
                []
                [ onInput InputRoomName ]
                []
            ]
        , field
            []
            [ controlLabel [] [ text "Rule" ]
            , [ Seer
              , Hunter
              , Madman
              , Psychic
              ]
                |> List.map (\x -> ( x, List.member x model.checkedRules ))
                |> List.map ruleCheckBox
                |> levelLeft []
            ]
        ]


listView : Model -> Html Msg
listView { roomList } =
    roomList
        |> List.map (listItem)
        |> content Standard []


listItem : Room -> Html Msg
listItem room =
    box
        [ onClick <| MoveRoom room.uid
        , style [ ( "cursor", "pointer" ) ]
        ]
        [ media []
            [ mediaLeft []
                [ image (OneByOne X64)
                    []
                    [ img
                        [ room.owner.iconUrl
                            |> Maybe.withDefault "https://bulma.io/images/placeholders/128x128.png"
                            |> src
                        ]
                        []
                    ]
                ]
            , mediaContent []
                [ title H4 [] [ text room.name ]
                , room.ruleSet
                    |> List.filter (\( _, n ) -> n > 0)
                    |> List.map (Tuple.first >> ruleTag)
                    |> tags []
                , level []
                    [ List.range 0 room.maxNum
                        |> List.map ((<=) <| List.length room.member)
                        |> List.map
                            (\x ->
                                icon Small
                                    [ if x then
                                        Typo.textColor Typo.Grey
                                      else
                                        Typo.textColor Typo.Black
                                    ]
                                    [ i [ class "fas fa-user" ] [] ]
                            )
                        |> levelLeft []
                    ]
                ]
            ]
        ]


ruleTag : Rule -> Html Msg
ruleTag rule =
    tag { tagModifiers | color = Info }
        []
        [ icon Standard [] [ i [ class <| ruleIcon rule ] [] ]
        , span [] [ text <| toString rule ]
        ]


ruleCheckBox : ( Rule, Bool ) -> Html Msg
ruleCheckBox ( rule, flag ) =
    levelItem []
        [ controlButton
            { buttonModifiers
                | color =
                    if flag then
                        Info
                    else
                        Light
                , iconLeft = Just ( Medium, [], i [ class <| ruleIcon rule ] [] )
            }
            [ class "rule-checkbox" ]
            [ onClick <| CheckRule rule
            , fullWidth
            ]
            [ span [] [ text <| toString rule ]
            ]
        ]
