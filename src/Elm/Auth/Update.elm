module Auth.Update exposing (..)

import Auth.Model exposing (..)
import Routing exposing (routeToUrl)
import Navigation exposing (newUrl)
import Firebase exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login loginType ->
            model ! [ login <| toString loginType ]

        Logout ->
            model ! [ logout () ]

        LoginSuccess user ->
            { model | user = Just user } ! [ newUrl <| routeToUrl Routing.RoomListing ]

        MenuClick ->
            { model | menuClick = not model.menuClick } ! []

        LogoutSuccess _ ->
            { model | user = Nothing } ! [ newUrl <| routeToUrl Routing.Login ]

        AuthStateCheck _ ->
            let
                cmd =
                    if model.user == Nothing then
                        newUrl <| routeToUrl Routing.Login
                    else
                        Cmd.none
                
            in
                { model | state = True } ! [ cmd ]
