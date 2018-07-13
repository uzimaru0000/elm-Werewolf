module User exposing (..)

import Json.Decode as JD
import Html exposing (Html)
import Html.Attributes as Html
import Bulma.Layout exposing (..)
import Bulma.Modifiers exposing (..)
import Bulma.Modifiers.Typography as Typo
import Bulma.Elements exposing (..)

type alias User =
    { uid : String
    , name : String
    , iconUrl : Maybe String
    }


userView : Size -> User -> Html msg
userView size user =
    let
        (iconSize, nameView) =
            case size of
                Small ->
                    (X16, Html.span [ Typo.textSize Typo.Small ])
                Standard ->
                    (X24, Html.span [ Typo.textSize Typo.Standard ])
                Medium ->
                    (X32, Html.span [ Typo.textSize Typo.Medium ])
                Large ->
                    (X48, Html.span [ Typo.textSize Typo.Large ])

    in
        [ levelItem []
            [ image (OneByOne iconSize)
                [ marginless ]
                [ Html.img [ user.iconUrl |> Maybe.withDefault "" |> Html.src ] [] ]
            ]
        , levelItem []
            [ nameView [ Html.text user.name ] ]
        ]
        |> levelLeft []
        |> List.singleton
        |> horizontalLevel []


userDecoder : JD.Decoder User
userDecoder =
    JD.map3 User
        (JD.field "uid" JD.string)
        (JD.field "name" JD.string)
        (JD.field "iconUrl" <| JD.nullable JD.string)