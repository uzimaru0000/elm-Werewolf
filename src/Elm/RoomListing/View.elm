module RoomListing.View exposing (..)

import Room exposing (..)
import Rule exposing (..)
import RoomListing.Model exposing (..)
import Html exposing (Html, text, img, i, span)
import Html.Attributes exposing (class, style, src, href, value)
import Html.Events exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Modifiers exposing (..)
import Bulma.Modifiers.Typography as Typo


view : Model -> Html Msg
view model =
    section NotSpaced
        []
        [ container []
            [ listView model
            , case model.selectedRoom of
                Just room ->
                    passModal room model ModalOff InputPass Join

                Nothing ->
                    text ""
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
        [ onClick <| SelectRoom room
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
                    |> List.map (Tuple.first >> ruleTag Standard)
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

