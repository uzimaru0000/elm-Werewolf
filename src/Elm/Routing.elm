module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = RoomListing
    | RoomCreate
    | Login
    | Home
    | NotFound


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Home top
        , map RoomListing (s "listing")
        , map RoomCreate (s "create")
        , map Login (s "login")
        , map Home (s "home")
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
        Home ->
            "#home"
        
        RoomListing ->
            "#listing"
        
        RoomCreate ->
            "#create"

        Login ->
            "#login"

        NotFound ->
            "#notfound"