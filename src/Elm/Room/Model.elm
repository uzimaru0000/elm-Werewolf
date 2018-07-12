module Room.Model exposing (..)

import Room exposing (..)

type alias Model =
    { room : Room
    }

init : Room -> Model
init room =
    Model room