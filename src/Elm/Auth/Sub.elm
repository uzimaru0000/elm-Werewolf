module Auth.Sub exposing (..)

import Auth.Model exposing (..)
import Firebase exposing (..)


subscriptions : Model -> Sub Msg
subscriptions _ =
    [ loginSuccess LoginSuccess
    , logoutSuccess LogoutSuccess
    , authStateCheck AuthStateCheck
    ]
    |> Sub.batch
