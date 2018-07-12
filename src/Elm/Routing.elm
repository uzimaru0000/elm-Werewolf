module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = RoomListing
    | RoomCreate
    | Login
    | Room String
    | NotFound


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map RoomListing top
        , map RoomCreate (s "create")
        , map Login (s "login")
        , map Room (s "room" </> string)
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
            "/"
        
        RoomCreate ->
            "#create"

        Login ->
            "#login"

        Room uid ->
            String.join "/" ["#room", uid]

        NotFound ->
            "#notfound"