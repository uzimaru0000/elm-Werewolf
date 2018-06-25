module RoomListing.View exposing (..)

import Dict exposing (..)
import Room exposing (..)
import Rule exposing (..)
import User exposing (..)
import RoomListing.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ forms model
        , listView model
        ]


forms : Model -> Html Msg
forms model =
    div
        [ class "box" ]
        [ div [ class "title" ]
            [ text "Filter" ]
        , div [ class "field" ]
            [ div [ class "control" ]
                [ label [ class "label" ] [ text "RoomName" ]
                , input
                    [ class "input"
                    , onInput InputRoomName
                    ]
                    []
                ]
            ]
        , div [ class "field" ]
            [ label [ class "label" ] [ text "Rule" ]
            , [ Seer
              , Hunter
              , Madman
              , Psychic
              ]
                |> List.map (\x -> ( x, List.member x model.checkedRules ))
                |> List.map ruleCheckbox
                |> div [ class "field is-grouped" ]
            ]
        ]


listView : Model -> Html Msg
listView { roomList, isLoading, userDict } =
    let
        flag =
            isLoading
                |> Maybe.withDefault False
    in
        if flag then
            div [ class "level" ]
                [ div [ class "level-item has-text-centered" ]
                    [ span [ class "icon is-large" ]
                        [ i [ class "fas fa-spinner fa-3x fa-spin" ] []
                        ]
                    ]
                ]
        else
            roomList
                |> List.map (listItem userDict)
                |> div
                    [ class "content"
                    , style
                        [ ( "min-height", "800px" )
                        ]
                    ]


listItem : Dict String User -> Room -> Html Msg
listItem dict room =
    let
        ownerData =
            Dict.get room.ownerID dict
    in
        div
            [ class "box"
            , style
                [ ( "padding", "16px 32px" )
                ]
            ]
            [ article
                []
                [ div [ class "media" ]
                    [ div
                        [ class "media-left" ]
                        [ figure
                            [ class "image is-64x64" ]
                            [ img
                                [ ownerData
                                    |> Maybe.andThen .iconUrl
                                    |> Maybe.withDefault "https://bulma.io/images/placeholders/128x128.png"
                                    |> src
                                ]
                                []
                            ]
                        ]
                    , div
                        [ class "media-content" ]
                        [ h4 [ class "title" ] [ text room.name ]
                        , room.ruleSet
                            |> List.filter (\( _, n ) -> n > 0)
                            |> List.map (Tuple.first >> tag)
                            |> div [ class "tags" ]
                        , div
                            [ class "level" ]
                            [ List.range 0 room.maxNum
                                |> List.map ((<=) <| List.length room.member)
                                |> List.map
                                    (\x ->
                                        span
                                            [ class "icon is-small"
                                            , classList [ ( "has-text-grey-light", x ) ]
                                            ]
                                            [ i [ class "fas fa-user" ] [] ]
                                    )
                                |> div [ class "level-left" ]
                            ]
                        ]
                    ]
                ]
            ]


tag : Rule -> Html Msg
tag rule =
    span
        [ class "tag is-info" ]
        [ span
            [ class "icon" ]
            [ i [ class <| ruleIcon rule ] [] ]
        , span [] [ text <| toString rule ]
        ]


ruleCheckbox : ( Rule, Bool ) -> Html Msg
ruleCheckbox ( rule, flag ) =
    div [ class "control" ]
        [ button
            [ class "button"
            , classList
                [ ( "is-light", not flag )
                , ( "is-info", flag )
                ]
            , onClick <| CheckRule rule
            ]
            [ span [ class "icon is-medium" ] [ i [ class <| ruleIcon rule ] [] ]
            , span [] [ text <| toString rule ]
            ]
        ]
