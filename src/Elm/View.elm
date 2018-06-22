module View exposing (..)

import Model exposing (..)
import Auth.View as Auth exposing (..)
import RoomCreate.View as RoomCreate exposing (..)
import RoomListing.View as RoomListing exposing (..)
import RoomCreate.Model as RoomCreate
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    div
        []
        [ Auth.view model.auth |> Html.map AuthMsg
        , section
            [ class "hero is-medium is-primary block" ]
            [ div
                [ class "hero-body" ]
                [ div
                    [ class "container" ]
                    [ h1
                        [ class "title" ]
                        [ text "WereWolf Local" ]
                    , h2
                        [ class "subtitle" ]
                        [ text "this is sub title" ]
                    ]
                ]
            , div
                [ class "hero-foot" ]
                [ nav
                    [ class "tabs is-boxed is-fullwidth" ]
                    [ div
                        [ class "container" ]
                        [ ul []
                            [ li [ class "is-active" ] [ a [] [ text "Rooms" ] ]
                            , li [] [ a [] [ text "Hoge" ] ]
                            , li [] [ a [] [ text "Foo" ] ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "container" ]
            [ RoomCreate.view model.roomCreate |> Html.map RoomCreateMsg
            ]
        ]
