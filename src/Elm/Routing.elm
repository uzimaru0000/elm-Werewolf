module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = RoomListing
    | RoomCreate
    | NotFound


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map RoomListing top
        , map RoomListing (s "listing")
        , map RoomCreate (s "create")
        ]


parseLocation : Location -> Route
parseLocation loc =
    case (parseHash matchers loc) of
        Just route ->
            route
        Nothing ->
            NotFound


routeToUrl : Route -> String
routeToUrl route =
    case route of
        RoomListing ->
            "#listing"
        
        RoomCreate ->
            "#create"

        NotFound ->
            "#notfound"