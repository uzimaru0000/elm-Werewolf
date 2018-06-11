module Update exposing (..)

import Model exposing (..)
import Auth.Update as Auth exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        AuthMsg msg ->
            let
                (authModel, cmd) =
                    Auth.update msg model.authModel
            in
                ({ model | authModel = authModel }, Cmd.map AuthMsg cmd)
        _ ->
            model ! []