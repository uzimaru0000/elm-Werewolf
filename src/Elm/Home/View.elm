module Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

view : Html msg
view =
    div
        [ class "title" ]
        [ text "Welcome to WereWolfOnline" ]