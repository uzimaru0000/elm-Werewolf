module RoomListing.View exposing (..)

import Room exposing (..)
import RoomListing.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ loadingSpinner model.isLoading
        , model.roomList
            |> List.map listItem
            |> div []
        ]


loadingSpinner : Maybe Bool -> Html Msg
loadingSpinner isLoading =
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
            text ""


listItem : Room -> Html Msg
listItem room =
    div
        [ class "box" ]
        [ article
            [ class "media" ]
            [ div
                [ class "media-left" ]
                [ figure
                    [ class "image is-64x64" ]
                    []
                ]
            ]
        ]
