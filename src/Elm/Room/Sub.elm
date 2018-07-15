module Room.Sub exposing (..)

import Room.Model exposing (..)
import Firebase exposing (..)

subscriptions : Model -> Sub Msg
subscriptions model =
    [ getRoom FetchRoomInfo
    ]
    |> Sub.batch