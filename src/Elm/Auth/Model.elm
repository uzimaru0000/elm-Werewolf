module Auth.Model exposing (..)

type LoginType
    = Twitter
    | Google
    | GitHub

type Msg
    = Login LoginType