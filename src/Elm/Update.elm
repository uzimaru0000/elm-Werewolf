module Update exposing (..)

import Model exposing (..)
import Firebase exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Login ->
            model ! [ login () ]
        Logout ->
            model ! [ logout () ]
        LoginSuccess user ->
            { model | user = Just user } ! []
                |> Debug.log "login success"
        LogoutSuccess _ ->
            { model | user = Nothing } ! []
        AuthStateCheck _ ->
            let
                currentState = model.state
                newState = { currentState | auth = True }
            in
                { model | state = newState } ! []
        _ -> 
            model ! []