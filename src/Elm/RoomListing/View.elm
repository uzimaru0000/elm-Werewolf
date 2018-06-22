module RoomListing.View exposing (..)

import Dict exposing (..)
import Room exposing (..)
import User exposing (..)
import RoomListing.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ listView model
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
                |> div [ class "box content" ]


listItem : Dict String User -> Room -> Html Msg
listItem dict room =
    let
        ownerData =
            Dict.get room.ownerID dict
    in
        div
            [ style
                [ ( "padding", "8px" )
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
